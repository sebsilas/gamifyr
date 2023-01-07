

feedback_page_single_test <- function(num_items) {

  num_items_correct <- sample(0:num_items, 1)

  score <- sample(0:100, 1)/100

  one_button_page(
    shiny::tags$div(
      shiny::tags$p(paste0("You got ", num_items_correct, "/", num_items, " questions correct.")),
      shiny::tags$p(pretty_percentile(score)),
      shiny::renderPlot({
        musicassessr::plot_normal_dist_plus_score(mean = 50, sd = 10, highlighted_score = score*100)
      })
    )
  )
}
