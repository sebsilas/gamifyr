

feedback_page_single_test <- function() {

  score <- sample(0:100, 1)/100

  one_button_page(
    shiny::tags$div(
      shiny::tags$p(pretty_percentile(score)),
      shiny::renderPlot({
        musicassessr::plot_normal_dist_plus_score(mean = 50, sd = 10, highlighted_score = score)
      })
    )
  )
}
