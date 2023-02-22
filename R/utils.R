

# scp_up(c('inst/www/css/style_mdt.css', 'inst/www/css/style_mpt.css', 'inst/www/css/style.css', 'inst/www/css/style_bat.css'))


#' Scp up
#'
#' @param file_to_up
#'
#' @return
#' @export
#'
#' @examples
scp_up <- function(file_to_up) {
  system2('scp', args = c('-i',
                         '../shiny3.pem',
                         '-r',
                         file_to_up,
                         'ubuntu@adaptiveeartraining.com:/home/ubuntu'))
}

#' Scp down
#'
#' @param file_to_down
#'
#' @return
#' @export
#'
#' @examples
scp_down <- function(file_to_down) {
  system2('scp', args = c('-i',
                          '../shiny3.pem',
                          '-r',
                          paste0('ubuntu@adaptiveeartraining.com:',
                          file_to_down),
                          "/Users/sebsilas/Downloads"))
}


pretty_percentile <- function(percentile, number_of_people = NULL) {

  stopifnot(between(percentile, 0, 1))

  percentile <- round(percentile * 100)

  if(is.null(number_of_people)) {
    paste0("You are better than ", percentile, "% of the population!")
  } else {
    paste0("You are better than ", percentile, "% of the ", pretty_comma(number_of_people), " people that participated!")
  }

}


get_test_percentile <- function(test_name, raw_score) {

  test_name <- toupper(test_name)

  percentile_fun <- aggregated_data_long %>%
    filter(Test == test_name) %>%
    pull(PercentileFunction) %>%
    purrr::pluck(1)

  percentile_fun(raw_score)
}


get_test_benchmark_mean <- function(test_acronym) {
  aggregated_data %>%
    select(contains(test_acronym)) %>%
    select(contains("mean")) %>%
    pull()
}

get_test_benchmark_sd <- function(test_acronym) {
  aggregated_data %>%
    select(contains(test_acronym)) %>%
    select(contains("sd")) %>%
    pull()
}


pretty_comma <- function(n) {
  prettyNum(n,big.mark=",",scientific=FALSE, digits = 2)
}


is.scalar.character <- function(x) {
  is.character(x) && is.scalar(x)
}

is.scalar.numeric <- function(x) {
  is.numeric(x) && is.scalar(x)
}

is.scalar.logical <- function(x) {
  is.logical(x) && is.scalar(x)
}

is.scalar <- function(x) {
  identical(length(x), 1L)
}
