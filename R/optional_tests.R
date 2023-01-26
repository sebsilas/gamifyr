

optional_tests <- function() {
  c(
    "Rhythm Ability Test" = "RAT::RAT",
    "Emotional Discrimination Test" = "EDT::EDT",
    "Timbre Perception Test" = "tptR::TPT",
    "Beat Drop Alignment" = "BDT::BDT",
    "Pitch Imagery Ability Test" = "piat::piat",
    "Singing Ability Test" = "SAA::SAA"
  )
}

test_acronym_to_name <- function(acronym) {
  tests <- list(
        "rat" = "Rhythm Ability Test",
        "edt" = "Emotional Discrimination Test",
        "tpt" = "Timbre Perception Test",
        "bdt" = "Beat Drop Alignment",
        "piat" = "Pitch Imagery Ability Test",
        "saa" = "Singing Ability Test"
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
    "saa" = "SAA::SAA"
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
    "SAA::SAA" = "saa"
    )

  tests[[test_fun]]
}

test_name_to_acronym <- function(test) {
  tests <- list(
    "Rhythm Ability Test" = "rat",
    "Emotional Discrimination Test" = "edt",
    "Timbre Perception Test" = "tpt",
    "Beat Drop Alignment" = "bdt",
    "Pitch Imagery Ability Test" = "piat",
    "Singing Ability Test" = "saa"
    )

  tests[[test]]
}



optional_test_acronyms <- function() {
  c('rat', 'edt', 'tpt', 'bdt', 'piat', 'saa'
    )
}

optional_test_selector <- function() {

    join(

      code_block(function(state, ...) {
        set_global("remaining_tests", optional_test_acronyms(), state)
      }),

      optional_test_selector_page(),

      psychTestR::while_loop(test = function(state, ...) {
        all(answer(state) %in% unname(optional_tests())) | is.list(answer(state))
      }, logic = join(

          # conditional_optional_test(num_items = 1L),

        order_at_run_time(
          label = "optional_test",
          get_order = function(state, ...) {
            1:length(optional_test_acronyms()) # we have to update this retrospectively, because we don't know in advance what the user's free choice will be
          },
          logic = conditional_optional_test()),

          optional_test_selector_page()

          )
      )
  )

}


optional_test_selector_page <- function() {


  reactive_page(function(state, ...) {

    remaining_tests <- get_global("remaining_tests", state)

    print('remain..')
    print(remaining_tests)

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

    if(is.null(remaining_tests)) {
      optional_test_acronyms_shuffled <- sample(optional_test_acronyms(), length(optional_test_acronyms()))

    } else {
      optional_test_acronyms_shuffled <- sample(remaining_tests, length(remaining_tests))
    }

    tagged_tests <- purrr::imap(optional_test_acronyms_shuffled, function(name, i) {
      tags$div(tags$h4(test_acronym_to_name(optional_test_acronyms_shuffled[i])), tags$img(src = test_name_to_sticker(optional_test_acronyms_shuffled[i]), onclick = set_test(optional_test_acronyms_shuffled[i]), height = "100px", width = "100px"))
    })

    # Might want to make this more programatic, if we had more tests

    ui <- tags$div(

      text,

      tags$hr(),

      list2grid(tagged_tests, 3),

      tags$br(),

      finished_button
    )

    page(ui, get_answer = function(input, state, ...) {

      previously_selected_tests <- get_global("previously_selected_tests", state)

      previously_selected_tests <- c(previously_selected_tests, test_fun_to_acronym(input$optional_test_selection))

      set_global("previously_selected_tests", previously_selected_tests, state)

      remaining_tests <- setdiff(optional_test_acronyms(), previously_selected_tests)

      set_global("remaining_tests", remaining_tests, state)


      if(input$last_btn_pressed == "test_finished") {
        FALSE
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
    } else {
      fun_eval <- eval(parse(text = paste0(test_fun, '(num_items = ', num_items, ')')))
    }

    psychTestR::conditional(test = function(state, ...) {

      if(is.list(answer(state))) {
        FALSE
      } else {
        answer(state) == test_fun
      }
    }, logic = fun_eval )

  })

}



