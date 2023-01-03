


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





# change_theme <- function(theme = 'yeti') {
#   shiny::tags$script(
#     paste0("$('#shinytheme-selector').ready(function() {
#             console.log('boom');
#     var allThemes = $(this).find('option').map(function() {
#     console.log('hasda');
#     console.log($(this).val());
#       if ($(this).val() === 'default')
#         return 'bootstrap';
#       else
#         return $(this).val();
#     });
#     // Find the current theme
#     var curTheme = '", theme, "';
#     if (curTheme === 'default') {
#       curTheme = 'bootstrap';
#       curThemePath = 'shared/bootstrap/css/bootstrap.min.css';
#     } else {
#       curThemePath = 'shinythemes/css/' + curTheme + '.min.css';
#     }
#     // Find the <link> element with that has the bootstrap.css
#     var $link = $('link').filter(function() {
#       var theme = $(this).attr('href');
#       theme = theme.replace(/^.*\\//, '').replace(/(\\.min)?\\.css$/, '');
#       return $.inArray(theme, allThemes) !== -1;
#     });
#
#     // Set it to the correct path
#     $link.attr('href', curThemePath);
#   });"))
# }
#
# allThemes <- function() {
#   themes <- dir(system.file("shinythemes/css", package = "shinythemes"),
#                 ".+\\.min.css")
#   sub(".min.css", "", themes)
# }



# change_theme_one_button_page(theme = 'cerulean',
#                              body = shiny::tags$div(
#                                shiny::tags$script(
#                                  "document.getElementsByClassName('draggable')[0].style.visibility = 'hidden';" # This hides the theme selector
#                                ),
#                                shiny::tags$p("Welcome to the battery!")
#                              )),

