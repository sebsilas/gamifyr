

core_tests <- function(num_items = NULL, take_training = TRUE) {
  psychTestR::join(

   psyquest::GMS(short_version = TRUE, configuration_filepath = system.file('extdata/GMSI_items.csv', package = 'gamifyr')),

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
    change_theme_one_button_page(theme = 'mdt',
                                 body = "Now you will do a melodic perception test!",
                                 content_background = '#f2f9ff'),
    mdt::mdt(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items)
  )
}

mpt_with_welcome <- function(num_items, take_training) {
  join(
    change_theme_one_button_page(theme = 'mpt',
                                 body = "Now you will do a mistuning perception test!",
                                 content_background = '#e0ffef'),
    mpt::mpt(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items)
  )
}


bat_with_welcome <- function(num_items, take_training) {
  join(
    change_theme_one_button_page(theme = 'bat',
                                 body = "Now you will do a musical beat perception test!",
                                 content_background = '#fff7ff'),
    cabat::cabat(num_items = num_items, take_training = take_training),
    feedback_page_single_test(num_items)
  )
}


