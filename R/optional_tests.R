
get_completed_test_score <- function(test_acronym, state, as_percentile = FALSE) {

  test_acronym_lower <- tolower(test_acronym)

  score <- psychTestR::get_global("test_scores", state) %>%
    filter(test_acronym == !!test_acronym_lower ) %>%
    pull(score) %>%
    as.numeric()

  if(as_percentile) {
    get_test_percentile(test_acronym, score) %>% round(2) %>% magrittr::multiply_by(100)
  } else {
    score
  }
}

optional_tests <- function() {
  c(
    "Rhythm Ability Test" = "RAT::RAT",
    "Emotional Discrimination Test" = "EDT::EDT",
    "Timbre Perception Test" = "tptR::TPT",
    "Beat Drop Alignment" = "BDT::BDT",
    "Pitch Imagery Ability Test" = "piat::piat",
    "Harmonic Perception Test" = "HPT::HPT",
    "Musical Scene Analysis Test" = "MSA::MSA",
    "Musical Preferences Test" = "psyquest::MUS"
    #"Singing Ability Test" = "SAA::SAA"
  )
}

test_acronym_to_name_list <- list(
  # NB, used in two places
  "mpt" = "Mistuning Perception Test",
  "bat" = "Beat Ability Test",
  "mdt" = "Melodic Discrimination Test",
  "rat" = "Rhythm Ability Test",
  "edt" = "Emotional Discrimination Test",
  "tpt" = "Timbre Perception Test",
  "bdt" = "Beat Drop Alignment",
  "piat" = "Pitch Imagery Ability Test",
  "hpt" = "Harmonic Perception Test",
  "msa" = "Musical Scene Analysis Test",
  "mus" = "Musical Preferences Test"
  #"saa" = "Singing Ability Test"
)

test_acronym_to_name <- function(acronym) {
  tests <- test_acronym_to_name_list
  tests[[acronym]]
}

test_acronym_to_description <- function(acronym) {
  tests <- list(
    "rat" = "How good is your sense of rhythm?",
    "edt" = "Are you able to detect intended emotions in music?",
    "tpt" = "How good are you at telling apart different types of musical sounds?",
    "bdt" = "How good are you at finding the beat in a piece of music?",
    "piat" = "How good are you at imaging pitches in your mind?",
    "hpt" = "How good is your perception of changes in chords?",
    "msa" = "Can you hear out the melody from the background music?",
    "mus" = "What are your musical preferences?",
    "saa" = "How good are you at singing?"
  )

  tests[[acronym]]
}


test_acronym_to_fun <- function(acronym) {
  tests <- list(
    "rat" = "RAT::RAT",
    "edt" = "EDT::EDT",
    "tpt" = "tptR::TPT",
    "bdt" = "BDT::BDT",
    "piat" = "piat::piat",
    "hpt" = "HPT::HPT",
    "msa" = "MSA::MSA",
    "mus" = "psyquest::MUS"
    #"saa" = "SAA::SAA"
    )

  tests[[acronym]]
}


test_fun_to_acronym <- function(test_fun) {
  tests <- list(
    "RAT::RAT" = "rat",
    "EDT::EDT" = "edt",
    "tptR::TPT" = "tpt",
    "BDT::BDT" = "bdt",
    "piat::piat" = "piat",
    "HPT::HPT" = "hpt",
    "MSA::MSA" = "msa",
    "psyquest::MUS" = "mus"
    #"SAA::SAA" = "saa"
    )

  tests[[test_fun]]
}

test_name_to_acronym <- function(test) {

  tests <- setNames(names(test_acronym_to_name_list), test_acronym_to_name_list) %>%
    as.list()

  tests[[test]]
}



optional_test_acronyms <- function() {
  setdiff(names(test_acronym_to_name_list), c("mdt", "mpt", "bat"))
}

optional_test_selector <- function(test = FALSE) {

    join(

      code_block(function(state, ...) {
        set_global("remaining_tests", optional_test_acronyms(), state)
      }),

      optional_test_selector_page(test = test),

      psychTestR::code_block(function(state, answer, ...) {
        if(answer == "back_to_core_results") {
          psychTestR::skip_n_pages(state, n = -5)
        }
      }),

      psychTestR::while_loop(test = function(state, ...) {
        all(answer(state) %in% unname(optional_tests())) | is.list(answer(state))
      }, logic = join(

        order_at_run_time(
          label = "optional_test",
          get_order = function(state, ...) {
            1:length(optional_test_acronyms()) # we have to update this retrospectively, because we don't know in advance what the user's free choice will be
          },
          logic = conditional_optional_test()),

          optional_test_selector_page(test = test)

          )
      )
  )

}


optional_test_selector_page <- function(remaining_tests = NULL, test = FALSE) {


  reactive_page(function(state, ...) {

    if(is.null(remaining_tests)) {
      remaining_tests <- get_global("remaining_tests", state)
    }

    previously_selected_tests <- setdiff(optional_test_acronyms(), remaining_tests) %>%
      setNames(rep("completed", length(.)))

    if(length(remaining_tests) == length(optional_test_acronyms())) {
      finished_button <- tags$br()

      text <- tags$p("Well done! Now please do another test of your choice.")

    } else {
      finished_button <- psychTestR::trigger_button("test_finished", "I'm Finished")

      text <- tagList(
        tags$p("Well done! Now you can choose to do another test of your choice."),
        tags$p("Or if you'd like to finish, click \"I'm Finished\" below.")
      )
    }

    logging::loginfo(paste0("Remaining tests: ", paste(remaining_tests, collapse = ", ")))

    optional_test_acronyms_shuffled <- shuffle_optional_test_acronyms(remaining_tests, previously_selected_tests)

    tagged_tests <- produce_tagged_tests(optional_test_acronyms_shuffled, state)
    tagged_tests_completed <- produce_tagged_tests_completed(optional_test_acronyms_shuffled, state)

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

    core_test_plot <- produce_core_test_plot(mpt_percentile_score, bat_percentile_score, mdt_percentile_score)



    ui <- optional_test_ui(text, tagged_tests, core_test_plot, tagged_tests_completed, finished_button)

    page(ui, get_answer = function(input, state, ...) {


      if(input$last_btn_pressed == "back_to_core_results") {
        return("back_to_core_results")
      }

      test_acronym <- test_fun_to_acronym(input$optional_test_selection)

      previously_selected_tests <- psychTestR::get_global("previously_selected_tests", state)
      previously_selected_tests <- c(previously_selected_tests, test_acronym)


      set_global("previously_selected_tests", previously_selected_tests, state)

      remaining_tests <- setdiff(optional_test_acronyms(), previously_selected_tests)

      set_global("remaining_tests", remaining_tests, state)

      if(input$last_btn_pressed == "test_finished") {
        FALSE
      } else if(input$last_btn_pressed == "back_to_core_results") {
        "back_to_core_results"
      } else {
        input$optional_test_selection
      }
    })

  })


}


set_test <- function(test) {
  paste0("Shiny.onInputChange(\'optional_test_selection\', \'", test_acronym_to_fun(test), "\'); next_page();")
}

conditional_optional_test <- function(num_items = 1L) {

  purrr::imap(optional_tests(), function(test_fun, test_name) {


    if(test_name == "Singing Ability Test") {
      fun_eval <- eval(parse(text = paste0(test_fun, '(app_name = "ABCD", demographics = FALSE, gold_msi = FALSE, final_results = FALSE)')))
    } else if(test_name == 'Musical Scene Analysis Test') {
      fun_eval <- eval(parse(text = paste0(test_fun, '(num_items = ', num_items, ', with_finish = FALSE, with_feedback = FALSE)')))
    } else if(test_name == "Musical Preferences Test") {
      fun_eval <- eval(parse(text = paste0(test_fun, '(num_items = ', num_items, ')')))
    } else {
      fun_eval <- eval(parse(text = paste0(test_fun, '(num_items = ', num_items, ')')))
    }

    psychTestR::conditional(test = function(state, ...) {

      if(is.list(answer(state))) {
        FALSE
      } else {
        answer(state) == test_fun
      }
    }, logic = join(fun_eval, feedback_page_single_test(num_items, test_acronym = toupper(test_name_to_acronym(test_name))))  )

  })

}


optional_test_ui <- function(text, tagged_tests, core_test_plot, tagged_tests_completed, finished_button) {
  tags$div(

    text,

    tags$hr(),


    tags$h2("Optional Tests"),
    tags$p("Feel free to do another test you haven't done yet!"),

    list2grid(tagged_tests, 3),

    tags$br(),

    tags$h3("Completed Test Results"),

    tags$br(),

    tags$div(core_test_plot),

    list2grid(tagged_tests_completed, 3),

    tags$br(),

    psychTestR::trigger_button("back_to_core_results", "Go back to core test results"),

    finished_button
  )
}


get_mus_score_plot <- function(state) {
  score_contemporary <- get_completed_test_score("mus_contemporary", state)
  score_sophisticated <- get_completed_test_score("mus_sophisticated", state)
  score_unpretentious <- get_completed_test_score("mus_unpretentious", state)
  score_mellow <- get_completed_test_score("mus_mellow", state)
  score_intense <- get_completed_test_score("mus_intense", state)

  score_holder <- tibble(
    Contemporary = score_contemporary,
    Unpretentious = score_unpretentious,
    Intense = score_intense,
    Sophisticated = score_sophisticated,
    Mellow = score_mellow)

  completed_plot <- ggradar::ggradar(score_holder, grid.max = 7, grid.mid = 3.5)
}

produce_tagged_tests_completed <- function(optional_test_acronyms_shuffled, state) {
  purrr::imap(optional_test_acronyms_shuffled, function(test_name, status) {

    i <- which(test_name == optional_test_acronyms_shuffled)

    if(status == "completed") {
      print('produce_tagged_tests_completed')
      print(test_name)
      if(test_name == "mus") {
        completed_plot <- get_mus_score_plot(state)
      } else {
        score <- get_completed_test_score(test_name, state)
        score <- as.numeric(score)
        percentile_score <- get_test_percentile(test_name, score)
        completed_plot <- musicassessr::plot_normal_dist_plus_score(mean = 50, sd = 10, highlighted_score = percentile_score*100)
      }

      tags$div(
        tags$h4(test_acronym_to_name(optional_test_acronyms_shuffled[i])),
        tags$div(renderPlot({ completed_plot }))
      )
    } else {
      tags$div()
    }



  })
}


shuffle_optional_test_acronyms <- function(remaining_tests, previously_selected_tests) {
  if(is.null(remaining_tests)) {
    optional_test_acronyms_shuffled <- sample(optional_test_acronyms(), length(optional_test_acronyms()))

  } else {
    optional_test_acronyms_shuffled <- sample(remaining_tests, length(remaining_tests))
    optional_test_acronyms_shuffled <- setNames(optional_test_acronyms_shuffled, rep("remaining", length(optional_test_acronyms_shuffled)))
    optional_test_acronyms_shuffled <- c(optional_test_acronyms_shuffled, previously_selected_tests)
  }
}


produce_tagged_tests <- function(optional_test_acronyms_shuffled, state) {
  purrr::imap(optional_test_acronyms_shuffled, function(test_name, status) {

    i <- which(test_name == optional_test_acronyms_shuffled)

    if(status == "completed") {

      if(test_name == "mus") {

        score_contemporary <- get_completed_test_score("mus_contemporary", state)
        score_sophisticated <- get_completed_test_score("mus_sophisticated", state)
        score_unpretentious <- get_completed_test_score("mus_unpretentious", state)
        score_mellow <- get_completed_test_score("mus_mellow", state)
        score_intense <- get_completed_test_score("mus_intense", state)
        percentile_score <- NA

        res <- paste0("Your scores were: ",
                      "Contemporary: ", score_contemporary,
                      "Mellow: ", score_mellow,
                      "Unpretentious: ", score_unpretentious,
                      "Sophisticated: ", score_sophisticated,
                      "Intense: ", score_intense)


      } else {
        score <- get_completed_test_score(test_name, state)
        score <- as.numeric(score)
        percentile_score <- get_test_percentile(test_name, score)
        res <- paste0("Your score was ", round(percentile_score*100), ".")
      }
      res <- shiny::tags$p(res) %>% as.character()

      completed_plot <- get_plot(test_name,
                                 percentile_score = percentile_score,
                                 score_contemporary = score_contemporary,
                                 score_unpretentious = score_unpretentious,
                                 score_intense = score_intense,
                                 score_sophisticated = score_sophisticated,
                                 score_mellow = score_mellow)

    }

    tagList(

      if(status == "remaining") shinyBS::bsTooltip(optional_test_acronyms_shuffled[i], title = test_acronym_to_description(optional_test_acronyms_shuffled[i]), placement = "bottom", trigger = "hover"),
      if(status == "completed") shinyBS::bsPopover(id = optional_test_acronyms_shuffled[i], title = "Test Completed!", content = res),

      tags$div(tags$h4(test_acronym_to_name(optional_test_acronyms_shuffled[i]),
                       style = if(status == "completed") "opacity: 0.25;" else ""),

               tags$img(id = optional_test_acronyms_shuffled[i],
                        style = if(status == "completed") "opacity: 0.25;" else "",
                        src = test_name_to_sticker(optional_test_acronyms_shuffled[i]),
                        onclick = if(status == "completed") NULL else set_test(optional_test_acronyms_shuffled[i]),
                        height = "100px", width = "100px")
      )

    )
  })
}
