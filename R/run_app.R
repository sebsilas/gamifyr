


run_app <- function(title = "Discover Your Musical Genius!",
                            admin_password = "demo",
                            researcher_email = "D.Mullensiefen@gold.ac.uk") {

  shiny::addResourcePath(
    prefix = "abcd_assets", # custom prefix that will be used to reference your directory
    directoryPath = system.file("www", package = "gamifyr") # path to resource in your package
  )


  tl <- psychTestR::join(

    one_button_page(
      tags$div(
        tags$head(
          tags$link(rel="stylesheet", type="text/css", href="https://adaptiveeartraining.com/abcd-assets/style_mpt.css", id="mpt"),
          tags$link(rel="stylesheet", type="text/css", href="https://adaptiveeartraining.com/abcd-assets/style_mdt.css", id="mdt"),
          tags$link(rel="stylesheet", type="text/css", href="https://adaptiveeartraining.com/abcd-assets/style_bat.css", id="bat"),
          tags$link(rel="stylesheet", type="text/css", href="https://adaptiveeartraining.com/abcd-assets/style.css", id="main"),
          ),
            update_header_background_image('https://i.ibb.co/wBh0TDN/header-bg.jpg'),
            update_content_background('#fafafa'),
            tags$p("Hello there and welcome to the Musical Genius Study!"),
            tags$img(src = 'abcd_assets/img/main_logo.png', height = "300px", width = "300px", style = "margin: 0 0 30px 0")
               )
    ),


    core_tests(num_items = 1L),

    change_theme_one_button_page('main', "Well done! You have finished the main tests, click to see your results before moving onto one final test of your choice."),

    core_tests_feedback(),

    optional_test_selector(),

    conditional_optional_test(num_items = 1L),

    psychTestR::final_page("You have reached the end, congratulations!")
  )

  psychTestR::make_test(tl,
                        psychTestR::test_options(title, admin_password, researcher_email,
                                                 theme = "live",
                                                 display = abcd_display,
                                                 logo = 'abcd_assets/img/main_logo.png',
                                                 logo_height = "100px",
                                                 logo_width = "100px",
                                                 logo_right = FALSE,
                                                 additional_scripts = c("https://cdn.plot.ly/plotly-latest.min.js",
                                                                        system.file('www/js/scatter_3d.js', package = 'gamifyr'),
                                                                        system.file('www/js/themes.js', package = 'gamifyr'),
                                                                        musicassessr::musicassessr_js(musicassessr_aws = TRUE, visual_notation = TRUE, app_name = "ABCD")
                                                                        ))
                        )
}




abcd_display <- display_options(
  content_background_colour = "none",
  content_border = "none",
  show_header = TRUE,
  show_footer = FALSE,
  left_margin = 2L,
  right_margin = 2L,
  admin_panel = FALSE)



