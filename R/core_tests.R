

core_tests <- function(num_items = NULL, take_training = FALSE) {
  psychTestR::join(

    psyquest::GMS(short_version = TRUE),

    psychTestR::randomise_at_run_time(
      label = "core_tests",
      logic = list( mdt_with_welcome(num_items = num_items, take_training = take_training),
                    bat_with_welcome(num_items = num_items, take_training = take_training),
                    mpt_with_welcome(num_items = num_items, take_training = take_training) )
    )

  )
}


mdt_with_welcome <- function(num_items, take_training) {
  join(
    change_theme_one_button_page('mdt', "Now you will do a melodic perception test!"),
    mdt::mdt(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items)
  )
}

mpt_with_welcome <- function(num_items, take_training) {
  join(
    change_theme_one_button_page('mpt', "Now you will do a mistuning perception test!"),
    mpt::mpt(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items)
  )
}


bat_with_welcome <- function(num_items, take_training) {
  join(
    change_theme_one_button_page('bat', "Now you will do a musical beat perception test!"),
    cabat::cabat(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items)
  )
}


