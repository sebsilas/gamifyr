

scp_up <- function(file_to_up) {
  system2('scp', args = c('-i',
                         '../shiny3.pem',
                         '-r',
                         file_to_up,
                         'ubuntu@adaptiveeartraining.com:/home/ubuntu'))
}

# scp_up('inst/www/css/style_bat.css')
# scp_up(c('inst/www/css/style_mdt.css', 'inst/www/css/style_mpt.css', 'inst/www/css/style.css'))

pretty_percentile <- function(percentile, number_of_people = NULL) {

  stopifnot(between(percentile, 0, 1))

  percentile <- round(percentile * 100)

  if(is.null(number_of_people)) {
    paste0("You are better than ", percentile, "% of the population!")
  } else {
    paste0("You are better than ", percentile, "% of the ", pretty_comma(number_of_people), " people that participated!")
  }

}


pretty_comma <- function(n) {
  prettyNum(n,big.mark=",",scientific=FALSE, digits = 2)
}


