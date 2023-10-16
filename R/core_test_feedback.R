

core_tests_feedback <- function(scatter = FALSE, test = FALSE) {

  join(

    psychTestR::reactive_page(function(state, ...) {

      if(test) {
        mdt_percentile_score <- sample(0:100, 1)
        bat_percentile_score <- sample(0:100, 1)
        mpt_percentile_score <- sample(0:100, 1)
      } else {

        results <- psychTestR::results(state)
        mdt_ability <- results$MDT$ability
        bat_ability <- results$BAT$ability
        mpt_ability <- results$MPT$ability
        gms_score <- results$GMS$General

        mdt_percentile_score <- get_test_percentile("MDT", mdt_ability) %>% round(2) %>% magrittr::multiply_by(100)
        bat_percentile_score <- get_test_percentile("BAT", bat_ability) %>% round(2) %>% magrittr::multiply_by(100)
        mpt_percentile_score <- get_test_percentile("MPT", mpt_ability) %>% round(2) %>% magrittr::multiply_by(100)

      }

     three_way_plot <- produce_core_test_plot(mpt_percentile_score, bat_percentile_score, mdt_percentile_score)

      ui <- tags$div(
        tags$h4("Your Results"),
        tags$br(),
        tags$p("Congratulations! You’ve completed the three core tests of the Musical Genius study."),
        tags$br(),
        tags$div(three_way_plot),
        tags$br(),
        tags$p("On the next page discover your Musical Genius Score and compare it to others.")
      )

      change_theme_one_button_page(theme = 'main', body = ui)


    }),


    psychTestR::reactive_page(function(state, ...) {

      if(test) {

        mdt_percentile_score <- sample(0:100, 1)
        bat_percentile_score <- sample(0:100, 1)
        mpt_percentile_score <- sample(0:100, 1)
        gms_percentile_score <- sample(0:100, 1)

        musical_genius_score <- round(mean(c(mdt_percentile_score, bat_percentile_score, mpt_percentile_score), na.rm = TRUE))

        username <- "Seb"
        gender <- "Male"
        age <- 30

      } else {

        results <- psychTestR::results(state)

        mdt_ability <- results$MDT$ability
        bat_ability <- results$BAT$ability
        mpt_ability <- results$MPT$ability
        gms_score <- results$GMS$General

        mdt_percentile_score <- get_test_percentile("MDT", mdt_ability) %>% round(2) %>% magrittr::multiply_by(100)
        bat_percentile_score <- get_test_percentile("BAT", bat_ability) %>% round(2) %>% magrittr::multiply_by(100)
        mpt_percentile_score <- get_test_percentile("MPT", mpt_ability) %>% round(2) %>% magrittr::multiply_by(100)
        gms_percentile_score <- get_test_percentile("GMS", gms_score) %>% round(2) %>% magrittr::multiply_by(100)

        musical_genius_score <- round(mean(c(mdt_percentile_score, bat_percentile_score, mpt_percentile_score), na.rm = TRUE))

        username <- psychTestR::get_global('username', state)
        gender <- psychTestR::get_global('gender', state)
        age <- psychTestR::get_global('age', state)
      }


      # leaderboard <- readr::read_csv(file = system.file('extdata/leaderboard.csv', package = 'gamifyr')) %>%
      #   mutate(Gender = as.factor(Gender))

      leaderboard <- benchmark_leaderboard %>%
        add_row(Name = username,
                Age = age,
                Gender = gender,
                `Musical Sophistication` = gms_percentile_score,
                `Mistuning Perception` = mpt_percentile_score,
                `Beat Perception` = bat_percentile_score,
                `Melody Perception` = mdt_percentile_score,
                `Musical Genius` = musical_genius_score) %>%
        mutate(Gender = as.factor(Gender),
               Age = as.integer(Age)) %>%
        mutate(across(`Musical Sophistication`:`Musical Genius`, ~as.integer(round(.x))))

      columns2hide <- c("Mistuning Perception", "Beat Perception", "Melody Perception")

      dt <- DT::datatable(leaderboard, filter = 'top', rownames = FALSE,
                          options = list(sDom  = '<"top">rt<"bottom">',
                                         columnDefs = list(list(visible=FALSE, targets=columns2hide))),
                          selection = 'none',
                          elementId = "dt_table",
                          callback = callback_js()) %>%
        DT::formatStyle(columns = c(1, 2, 3, 4, 5), fontSize = '14px')

      if(scatter) {
        plot_3d_dat <- produce_3d_scatter(leaderboard, mdt_percentile_score, bat_percentile_score, mpt_percentile_score)
      }

      socials <- musicassessr::create_socials(socials = TRUE,
                                              test_name = "ABCD Study",
                                              score = musical_genius_score,
                                              hashtag = "#ABCDStudy",
                                              test = "ABCD Study",
                                              url = "http://ABCDStudy.com")

      # Plots
      musical_genius_plot <- shiny::renderPlot({
        musicassessr::plot_normal_dist_plus_score(data = leaderboard %>% rename(score = `Musical Genius`),
                                                  #mean = 50, sd = 10,
                                                  vertical_line_colour = "#7c4191",
                                                  highlighted_score = musical_genius_score, title = "Musical Genius")
      })

      # Certificate

      future::plan(future::multisession, workers = 2)

      # Construct query url

      query_url <- construct_query_url(username, musical_genius_score, bat_percentile_score, mdt_percentile_score, mpt_percentile_score, state)

      print(query_url)

      future::future({
        httr::GET(query_url, query = list(name = username, score = musical_genius_score))
        }) %...>% (function(certificate_req) {

      certificate_req_status <- httr::status_code(certificate_req)

      logging::loginfo(paste0('Certificate request status code: ', certificate_req_status))

      if(certificate_req_status == 200) {

        certificate_url <- httr::content(certificate_req)[[1]] %>% stringr::str_replace('/srv/shiny-server/', "https://adaptiveeartraining.com/")

        shinyjs::runjs(certificate_js(certificate_url))
      }

    })


      ui <- tags$div(
        tags$h2("Your Musical Genius Score!"),
        tags$div(musical_genius_plot),
        tags$p(paste0(" Your total Musical Genius score is ", musical_genius_score,". This means that you are better than ", musical_genius_score, "% of about ", pretty_comma(nrow(leaderboard)), " teenagers who have taken the tests already."),

        tags$p("Check out the leaderboard and filter for people with similar age and amount of musical training.
  Download and share a certificate with your test results if you like.
  If you are up for more musical challenges check out the 9 optional tests from the next page and get a score for each of them.")),

        tags$h3("Leaderboard"),
        dt,
        tags$br(),
        tags$div(id = 'graph'),
        if(!scatter) tags$script("var g = document.getElementById('graph'); g.parentNode.removeChild(g);"),
        tags$div(
          if(scatter) style = "margin-top: 950px;",
          socials,
          tags$br(),
          shiny::tags$button("Download Your Certificate!", id = "download_certificate_button", style = "visibility: hidden"),
          tags$br(),
          psychTestR::trigger_button("next", "Next")
          )
        )

      page(ui)


    })

  ) # End join
}



callback_js <- function() {
  DT::JS(
  c("

               function after_load() {

                    var columns = table.columns( { filter : 'applied'} ).data().toArray();

                    console.log(columns);
                    var x_coords = columns[4];
                    var y_coords = columns[5];
                    var z_coords = columns[6];

                    plot_3d(x_coords, y_coords, z_coords);
            }

            $(document).ready(function () {

                setTimeout(after_load, 500);

            });",
    "table.on('search.dt', function() {
        //filtered rows data as arrays
        console.log('search');
        var new_columns = table.columns( { filter : 'applied'} ).data().toArray();
        console.log(new_columns[4]);
        var x_coords = new_columns[4];
        var y_coords = new_columns[5];
        var z_coords = new_columns[6];

        update_plot_3d(x_coords, y_coords, z_coords);

      })"
    )
  )
}



#' Produce a 3D scatter graph of three scores
#'
#' @param leaderboard
#' @param mdt_ability
#' @param bat_ability
#' @param mpt_ability
#'
#' @return
#' @export
#'
#' @examples
produce_3d_scatter <- function(leaderboard, mdt_ability, bat_ability, mpt_ability) {

  leaderboard <- leaderboard %>%
    mutate(participant_score = 0) %>%
      add_row(
        Name = "Seb",
        Gender = "Male",
        Musicianship = 50,
        mdt_ability = mdt_ability,
        bat_ability = bat_ability,
        mpt_ability = mpt_ability,
        participant_score = 1) %>%
    mutate(
      participant_score = as.factor(participant_score)
    )

}



produce_core_test_plot <- function(mpt_percentile_score, bat_percentile_score, mdt_percentile_score) {

  print(mpt_percentile_score)

  mpt_plot <- musicassessr::plot_normal_dist_plus_score(mean = 50, sd = 10, highlighted_score = mpt_percentile_score, title = "Mistuning Perception", colour = "#268251", alpha = .90, vertical_line_colour = "#ffffff")

  bat_plot <- musicassessr::plot_normal_dist_plus_score(mean = 50, sd = 10, highlighted_score = bat_percentile_score, title = "Beat Perception", colour = "#2596be", alpha = .90, vertical_line_colour = "#ffffff")

  mdt_plot <- musicassessr::plot_normal_dist_plus_score(mean = 50, sd = 10, highlighted_score = mdt_percentile_score, title = "Melodic Perception", colour = "#80D0C7", alpha = .90, vertical_line_colour = "#ffffff")

  three_way_plot <- shiny::renderPlot({ gridExtra::grid.arrange(mpt_plot, bat_plot, mdt_plot, nrow = 1, ncol = 3) })

}




set_score <- function(score_tb, acronym, new_score) {

  new_score <- as.character(new_score)

  score_tb %>%
    mutate(score = case_when(test_acronym == !! acronym ~ new_score, TRUE ~ score))

}




construct_query_url <- function(username, musical_genius_score, bat_percentile_score, mdt_percentile_score, mpt_percentile_score, state) {

  bdt_percentile_score <- get_completed_test_score("bdt", state, as_percentile = TRUE)
  edt_percentile_score <- get_completed_test_score("edt", state, as_percentile = TRUE)
  hpt_percentile_score <- get_completed_test_score("hpt", state, as_percentile = TRUE)
  msa_percentile_score <- get_completed_test_score("msa", state, as_percentile = TRUE)
  mus_mellow_percentile_score <- get_completed_test_score("mus_mellow", state, as_percentile = TRUE)
  mus_unpretentious_percentile_score <- get_completed_test_score("mus_unpretentious", state, as_percentile = TRUE)
  mus_sophisticated_percentile_score <- get_completed_test_score("mus_sophisticated", state, as_percentile = TRUE)
  mus_contemporary_percentile_score <- get_completed_test_score("mus_contemporary", state, as_percentile = TRUE)
  mus_intense_percentile_score <- get_completed_test_score("mus_intense", state, as_percentile = TRUE)
  piat_percentile_score <- get_completed_test_score("piat", state, as_percentile = TRUE)
  rat_percentile_score <- get_completed_test_score("rat", state, as_percentile = TRUE)
  saa_percentile_score <- get_completed_test_score("saa", state, as_percentile = TRUE)
  saa_percentile_score <- NA
  warning('SAA percentile fixed to NA for now...')
  tpt_percentile_score <- get_completed_test_score("tpt", state, as_percentile = TRUE)


  paste0("http://adaptiveeartraining.com:4000/createcertificate?name=", username,
         "&overall_score=", musical_genius_score,
         "&bat=", bat_percentile_score,
         if(!is.na(bdt_percentile_score)) paste0("&bdt=", get_completed_test_score("bdt", state, as_percentile = TRUE)),
         if(!is.na(edt_percentile_score)) paste0("&edt=", get_completed_test_score("edt", state, as_percentile = TRUE)),
         if(!is.na(hpt_percentile_score)) paste0("&hpt=", get_completed_test_score("hpt", state, as_percentile = TRUE)),
         "&mdt=", mdt_percentile_score,
         "&mpt=", mpt_percentile_score,
         if(!is.na(msa_percentile_score)) paste0("&msa=", get_completed_test_score("msa", state, as_percentile = TRUE)),
         if(!is.na(mus_mellow_percentile_score)) paste0("&mus_mellow=", get_completed_test_score("mus_mellow", state, as_percentile = TRUE)),
         if(!is.na(mus_unpretentious_percentile_score)) paste0("&mus_unpretentious=", get_completed_test_score("mus_unpretentious", state, as_percentile = TRUE)),
         if(!is.na(mus_sophisticated_percentile_score)) paste0("&mus_sophisticated=", get_completed_test_score("mus_sophisticated", state, as_percentile = TRUE)),
         if(!is.na(mus_intense_percentile_score)) paste0("&mus_intense=", get_completed_test_score("mus_intense", state, as_percentile = TRUE)),
         if(!is.na(mus_contemporary_percentile_score)) paste0("&mus_contemporary=", get_completed_test_score("mus_contemporary", state, as_percentile = TRUE)),
         if(!is.na(piat_percentile_score)) paste0("&piat=", get_completed_test_score("piat", state, as_percentile = TRUE)),
         if(!is.na(rat_percentile_score)) paste0("&rat=", get_completed_test_score("rat", state, as_percentile = TRUE)),
         if(!is.na(saa_percentile_score)) paste0("&saa=", get_completed_test_score("saa", state, as_percentile = TRUE)),
         if(!is.na(tpt_percentile_score)) paste0("&tpt=", get_completed_test_score("tpt", state, as_percentile = TRUE))
  )
}


certificate_js <- function(certificate_url) {
  paste0("var download_certficate_button = document.getElementById('download_certificate_button');
          download_certficate_button.addEventListener('click', function() { window.open(\'", certificate_url, "\') });
          download_certificate_button.classList.add('btn');
          download_certficate_button.style.visibility = 'visible';")
}


# Create dummy leaderboard data

# l <- tibble(Name = sample(LETTERS, 100, replace = TRUE),
#             Gender = sample(c("Male", "Female"), 100, replace = TRUE),
#             Age = sample(18:100, 100, replace = TRUE),
#             Musicianship = sample(0:100, 100,replace = TRUE),
#             mdt_ability = sample(0:100, 100,replace = TRUE),
#             bat_ability = sample(0:100, 100,replace = TRUE),
#             mpt_ability = sample(0:100, 100,replace = TRUE))
#
# write.csv(l, file = "leaderboard.csv", row.names = FALSE)
#









# fig <- plotly::plot_ly(leaderboard, x = ~mdt_ability, y = ~mpt_ability, z = ~bat_ability, color = ~participant_score, colors = c('#BF382A', '#0C4B8E'))
# fig <- fig %>% plotly::add_markers()
# fig <- fig %>% plotly::add_annotations(
#   x = mdt_ability,
#   y = mpt_ability,
#   z = bat_ability,
#   xref = "x",
#   yref = "y",
#   zref = "z",
#   text = "Your Musical Genius Score!",
#   showarrow = TRUE,
#   ax = 20,
#   ay = -40)
#
# fig <- fig %>% plotly::layout(scene = list(
#                                    xaxis = list(title = 'Melodic Perception'),
#                                    yaxis = list(title = 'Mistuning Perception'),
#                                    zaxis = list(title = 'Beat Perception')))
#
# fig
