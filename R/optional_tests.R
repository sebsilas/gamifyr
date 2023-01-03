

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
        "saa" = "Singing Ability Test")

  tests[[acronym]]
}


test_acronym_to_fun <- function(acronym) {
  tests <- list(
    "rat" = "RAT::RAT",
    "edt" = "EDT::EDT",
    "tpt" = "tptR::TPT",
    "bdt" = "BDT::BDT",
    "piat" = "piat::piat",
    "saa" = "SAA::SAA")

  tests[[acronym]]
}

test_name_to_acronym <- function(test) {
  tests <- list(
    "Rhythm Ability Test" = "rat",
    "Emotional Discrimination Test" = "edt",
    "Timbre Perception Test" = "tpt",
    "Beat Drop Alignment" = "bdt",
    "Pitch Imagery Ability Test" = "piat",
    "Singing Ability Test" = "saa")

  tests[[test]]
}


# optional_test_selector <- function() {
#   dropdown_page(label = "optional_test_selector",
#                 prompt = "What test would you like to do next?",
#                 choices = optional_tests())
# }

optional_test_acryonyms <- c('rat', 'edt', 'tpt', 'bdt', 'piat', 'saa')


optional_test_selector <- function() {

  optional_test_acryonyms_shuffled <- sample(optional_test_acryonyms, length(optional_test_acryonyms))

  # Might want to make this more programatic, if we had more tests

  ui <- tags$div(

    tags$p("Well done! Now you can choose to do another test of your choice."),

    tags$hr(),

    fluidRow(
      column(4, tags$h4(test_acronym_to_name(optional_test_acryonyms_shuffled[1])), tags$img(src = test_name_to_sticker(optional_test_acryonyms_shuffled[1]), onclick = set_test(optional_test_acryonyms_shuffled[1]), height = "100px", width = "100px")),
      column(4, tags$h4(test_acronym_to_name(optional_test_acryonyms_shuffled[2])), tags$img(src = test_name_to_sticker(optional_test_acryonyms_shuffled[2]), onclick = set_test(optional_test_acryonyms_shuffled[2]), height = "100px", width = "100px")),
      column(4, tags$h4(test_acronym_to_name(optional_test_acryonyms_shuffled[3])), tags$img(src = test_name_to_sticker(optional_test_acryonyms_shuffled[3]), onclick = set_test(optional_test_acryonyms_shuffled[3]), height = "100px", width = "100px"))
    ),
    fluidRow(
      column(4, tags$h4(test_acronym_to_name(optional_test_acryonyms_shuffled[4])), tags$img(src = test_name_to_sticker(optional_test_acryonyms_shuffled[4]), onclick = set_test(optional_test_acryonyms_shuffled[4]), height = "100px", width = "100px")),
      column(4, tags$h4(test_acronym_to_name(optional_test_acryonyms_shuffled[5])), tags$img(src = test_name_to_sticker(optional_test_acryonyms_shuffled[5]), onclick = set_test(optional_test_acryonyms_shuffled[5]), height = "100px", width = "100px")),
      column(4, tags$h4(test_acronym_to_name(optional_test_acryonyms_shuffled[6])), tags$img(src = test_name_to_sticker(optional_test_acryonyms_shuffled[6]), onclick = set_test(optional_test_acryonyms_shuffled[6]), height = "100px", width = "100px"))
    ),

    tags$br()
   )

  page(ui, get_answer = function(input, ...) {
    print(input$optional_test_selection)
    input$optional_test_selection
    })
}



set_test <- function(test) {
  paste0("Shiny.onInputChange(\'optional_test_selection\', \'", test_acronym_to_fun(test), "\'); next_page();")
}

conditional_optional_test <- function(num_items = 1L) {

  purrr::imap(optional_tests(), function(test_fun, test_name) {

    if(test_name == "Singing Ability Test") {
      fun_eval <- eval(parse(text = paste0(test_fun, '(app_name = "ABCD")')))
    } else {
      fun_eval <- eval(parse(text = paste0(test_fun, '(num_items = ', num_items, ')')))
    }

    psychTestR::conditional(test = function(state, ...) {
      answer(state) == test_fun
    }, logic = fun_eval )

  })

}
