

core_tests_feedback <- function() {
  psychTestR::reactive_page(function(state, ...) {

    results <- psychTestR::results(state)

    # mdt_ability <- results$MDT$ability
    # bat_ability <- results$BAT$ability
    # mpt_ability <- results$MPT$ability

    mdt_ability <- sample(0:100, 1, replace = TRUE)
    bat_ability <- sample(0:100, 1, replace = TRUE)
    mpt_ability <- sample(0:100, 1, replace = TRUE)

    leaderboard <- readr::read_csv(file = system.file('extdata/leaderboard.csv', package = 'gamifyr'))

    columns2hide <- c("mdt_ability", "bat_ability", "mpt_ability")

    dt <- DT::datatable(leaderboard, filter = 'top', rownames = FALSE,
                        options = list(sDom  = '<"top">rt<"bottom">',
                                       columnDefs = list(list(visible=FALSE, targets=columns2hide))),
                        selection = 'none',
                        elementId = "dt_table",
                        callback = callback_js())


    plot_3d_dat <- produce_3d_scatter(leaderboard, mdt_ability, bat_ability, mpt_ability)

    socials <- musicassessr::create_socials(socials = TRUE,
                                            test_name = "ABCD Study",
                                            score = 90,
                                            hashtag = "ABCDStudy",
                                            test = "ABCDStudy",
                                            url = "http://ABCDStudy.com")

    future::plan(future::multisession, workers = 2)

    future::future({
      httr::GET("http://adaptiveeartraining.com:4000/createcertificate?name=Seb&score=50", query = list(name = "Seb", score = 52))
      }) %...>% (function(certificate_req) {

    certificate_req_status <- httr::status_code(certificate_req)

    logging::loginfo(paste0('Certificate request status code: ', certificate_req_status))

    if(certificate_req_status == 200) {

      certificate_url <- httr::content(certificate_req)[[1]] %>% stringr::str_replace('/srv/shiny-server/', "https://adaptiveeartraining.com/")

      shinyjs::runjs(paste0("
                   var download_certficate_button = document.getElementById('download_certificate_button');
                   download_certficate_button.addEventListener('click', function() { window.open(\'", certificate_url, "\') });
                   download_certificate_button.classList.add('btn');
                   download_certficate_button.style.visibility = 'visible';
                   "))
    }

  })


    ui <- tags$div(
      tags$h3("Your Musical Genius Score!"),
      tags$h4("Leaderboard"),
      dt,
      tags$br(),
      tags$p("See your Musical Genius Score below in relation to everyone else. Filter to compare yourself to others."),
      tags$div(id = 'graph'),
      tags$div(style = "margin-top: 950px;",
        socials,
        tags$br(),
        shiny::tags$button("Download Your Certificate!", id = "download_certificate_button", style = "visibility: hidden"),
        tags$br(),
        psychTestR::trigger_button("next", "Next")
        )
      )

    page(ui)


  })
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





abcd_socials <- function(score) {
  function(){
    musicassessr::create_socials(socials = TRUE,
                                 test_name = "ABCD Study",
                                 score = score,
                                 hashtag = "ABCDStudy",
                                 test = "ABCDStudy",
                                 url = "http://ABCDStudy.com")
  }
}

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
