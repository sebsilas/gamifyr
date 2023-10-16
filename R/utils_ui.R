


#' Update an element
#'
#' @param id
#' @param new_html
#'
#' @return
#' @export
#'
#' @examples
update_element <- function(id, new_html) {
  shiny::tags$script(
    htmltools::HTML(paste0('document.getElementById(\'', id, '\').innerHTML = \'', new_html, '\''))
    )
}

#' Update an image
#'
#' @param id
#' @param new_src
#'
#' @return
#' @export
#'
#' @examples
update_image <- function(id, new_src) {
  shiny::tags$script(
    htmltools::HTML(paste0('document.getElementById(\'', id, '\').src = \'', new_src, '\''))
  )
}

#' Update the background
#'
#' @param background_hex
#'
#' @return
#' @export
#'
#' @examples
update_background <- function(background_hex) {
  shiny::tags$script(htmltools::HTML(paste0('document.body.style.backgroundColor = \"', background_hex, '\";')))
}

#' Update the header
#'
#' @param background_hex
#'
#' @return
#' @export
#'
#' @examples
update_header_background <- function(background_hex) {
  shiny::tags$script(htmltools::HTML(paste0('document.getElementById("psychTestR_header").style.backgroundColor = \"', background_hex, '\";')))
}

#' Update the content background
#'
#' @param background_hex
#'
#' @return
#' @export
#'
#' @examples
update_content_background <- function(background_hex) {
  shiny::tags$script(htmltools::HTML(paste0('document.getElementById("psychTestR_content").style.backgroundColor = \"', background_hex, '\";')))
}

#' Update an element
#'
#' @param background_image
#'
#' @return
#' @export
#'
#' @examples
update_header_background_image <- function(background_image) {
  shiny::tags$script(htmltools::HTML(paste0("document.getElementById('psychTestR_header').style.backgroundImage = 'url(\"", background_image, "\")\';")))
}



#' Change the theme with a new page
#'
#' @param theme
#' @param body
#' @param content_background
#'
#' @return
#' @export
#'
#' @examples
change_theme_one_button_page <- function(theme, body, content_background = NULL) {
  psychTestR::one_button_page(
    shiny::tags$div(change_theme(theme),
                    if(!is.null(content_background)) update_content_background(content_background),
                    body,
                    tags$br()))
}


#' Change the theme
#'
#' @param theme
#'
#' @return
#' @export
#'
#' @examples
change_theme <- function(theme) {
  shiny::tags$div(
    tags$script(paste0('setTheme("', theme, '")')),
    update_image("logo", test_name_to_sticker(theme))
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
