


update_element <- function(id, new_html) {
  shiny::tags$script(
    htmltools::HTML(paste0('document.getElementById(\'', id, '\').innerHTML = \'', new_html, '\''))
    )
}

update_image <- function(id, new_src) {
  shiny::tags$script(
    htmltools::HTML(paste0('document.getElementById(\'', id, '\').src = \'', new_src, '\''))
  )
}


update_background <- function(background_hex) {
  shiny::tags$script(htmltools::HTML(paste0('document.body.style.backgroundColor = \"', background_hex, '\";')))
}

update_header_background <- function(background_hex) {
  shiny::tags$script(htmltools::HTML(paste0('document.getElementById("psychTestR_header").style.backgroundColor = \"', background_hex, '\";')))
}


update_content_background <- function(background_hex) {
  shiny::tags$script(htmltools::HTML(paste0('document.getElementById("psychTestR_content").style.backgroundColor = \"', background_hex, '\";')))
}



update_header_background_image <- function(background_image) {
  shiny::tags$script(htmltools::HTML(paste0("document.getElementById('psychTestR_header').style.backgroundImage = 'url(\"", background_image, "\")\';")))
}



change_theme_one_button_page <- function(theme, body) {
  psychTestR::one_button_page(shiny::tags$div(change_theme(theme), body, tags$br()))
}

change_theme <- function(theme) {
  shiny::tags$div(
    tags$script(paste0('setTheme("', theme, '")')),
    update_image("logo", test_name_to_sticker(theme))#,
    #update_element("title", paste0("Discover Your Musical Genius! ", config::get("title", config = theme)))
  )
}


test_name_to_sticker <- function(name) {
  paste0('abcd_assets/img/stickers/', name, '_sticker.png')
}


#' Arrange a list into a grid of fluidRows and columns
#'
#' @param li A list
#' @param ncol Number of columns
#'
#' @export
list2grid <- function(li, ncol) {
  nrow <- ceiling(length(li) / ncol)
  width = floor(12 / ncol)

  # Ignore warning of data length not matching for the last row
  li <- suppressWarnings(split(li, rep(1:nrow, each = ncol)))

  out <- purrr::map(li, function(r) fluidRow(purrr::map(r, column, width = width)))
  tagList(out)
}
