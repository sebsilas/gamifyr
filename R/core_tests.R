

core_tests <- function(num_items = NULL, take_training = config::get("take_training") ) {
  psychTestR::join(

   # MPT always first

   mpt_with_welcome(num_items = num_items, take_training = take_training),

   change_theme_one_button_page(theme = 'main',
                                body = "Now you will answer some musical questions!"),

   psyquest::GMS(short_version = TRUE, configuration_filepath = system.file('extdata/GMSI_items.csv', package = 'gamifyr')),

    psychTestR::randomise_at_run_time(
      label = "core_tests",
      logic = list( mdt_with_welcome(num_items = num_items, take_training = take_training),
                    bat_with_welcome(num_items = num_items, take_training = take_training) )
    )

  )
}


mdt_with_welcome <- function(num_items, take_training) {
  join(
    change_theme_one_button_page(theme = 'mdt',
                                 body = "Now you will do a melodic perception test!"),
    mdt::mdt(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items, test_acronym = "MDT")
  )
}

mpt_with_welcome <- function(num_items, take_training) {
  join(
    change_theme_one_button_page(theme = 'mpt',
                                 body = "To start off, you will do a mistuning perception test!"),
    mpt::mpt(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items, test_acronym = "MPT")
  )
}


bat_with_welcome <- function(num_items, take_training) {
  join(
    change_theme_one_button_page(theme = 'bat',
                                 body = "Now you will do a musical beat perception test!"),
    cabat::cabat(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items, test_acronym = "BAT")
  )
}


