

#' Run the ABCD study
#'
#' @param title
#' @param admin_password
#' @param researcher_email
#' @param musicassessr_aws
#' @param app_name
#'
#' @return
#' @export
#'
#' @examples
run_app <- function(title = "Discover Your Musical Genius!",
                    admin_password = "demo",
                    researcher_email = "D.Mullensiefen@gold.ac.uk",
                    musicassessr_aws = FALSE,
                    app_name = "ABCD") {

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
            tags$h3("Welcome to the Musical Genius Study!"),
            tags$p("In this study you can test your ", tags$strong("music skills"), " and discover whether you’re a ", tags$p("musical genius"), "."),
            tags$img(src = 'abcd_assets/img/main_logo.png', height = "300px", width = "300px", style = "margin: 0 0 30px 0")
               )
    ),

    one_button_page(tags$div(
                    tags$h3("About"),
                    tags$p("The study has three ", tags$strong("listening tests"), " and a questionnaire.
                    You'll get ", tags$strong("feedback"), " on how you performed and you can compare your score to other people who have taking the test.
                    You might get ranked on the ", tags$strong("leaderboard"), " and you can download a ", tags$strong("certificate"), " to share. "))),

    one_button_page(tags$div(tags$h3("About"),
                    tags$p("Finally, there is also a choice of ",
                           tags$strong("9 optional tests"), " if you are up for ", tags$strong("more musical challenges!")))),

    one_button_page(tags$div(
      tags$h3("About"),
      tags$p("This study is an addition to the ABCD study that you are already taking part in."))),


    NAFC_page(label = "playback_device",
              prompt = "Are you using speakers or headphones to playback sound?",
              choices = c("Speakers", "Headphones") ),

    text_input_page(label = "username",
                    prompt = "For our leaderboard later, what is your name, or choose a username",
                    on_complete = function(state, answer, ...){
                      set_global("username", answer, state)
                    }),

    NAFC_page(label = "gender",
              prompt = "For our leaderboard later, what is your gender?",
              choices = c("Male", "Female", "Other", "Rather not say"),
              on_complete = function(state, answer, ...){
                set_global("gender", answer, state)
              }),

    slider_page(label = "age",
              prompt = "For our leaderboard later, what is your age?",
              min = 12,
              max = 100,
              value = 40,
              on_complete = function(state, answer, ...){
                set_global("age", answer, state)
              }),

    psychTestR::new_timeline(musicassessr::get_user_info_page(), dict = musicassessr::dict(NULL) ),

    core_tests(num_items = 1L),

    one_button_page("Well done! You have finished the main tests, click to see your results before moving onto one final test of your choice."),

    core_tests_feedback(),

    optional_test_selector(),

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
                                                                        musicassessr::musicassessr_js(musicassessr_aws = musicassessr_aws, visual_notation = TRUE, app_name = app_name)
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



