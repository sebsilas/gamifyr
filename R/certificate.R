
# https://www.andreashandel.com/posts/2020-10-15-customized-documents-with-rmarkdown/#templates


# library(gamifyr)

#* Create certificate and return its name
#* @param a The first number to add
#* @param b The second number to add
#* @get /createcertificate
function(name, score) {
  gamifyr::create_certificate(name, score)
  gamifyr::create_certificate_filename(name, score)
}

# plumber::pr("R/certificate.R") %>% plumber::pr_run(port=8000)

# http://localhost:8000/createcertificate?name=Seb&score=50

# res <- httr::GET("http://localhost:8000/createcertificate", query = list(name = "Seb", score = 52))
# status_code(res)
# certificate_name <- httr::content(res)[[1]]


certificate_app <- function() {

  # Define UI for data download app ----
  ui <- fluidPage(

    titlePanel("Get your Discover Your Musical Genius Certificate"),

    downloadButton("download_certiciate", "Download Certificate")

  )

  server <- function(input, output, session) {

    observe({

      query <- parseQueryString(session$clientData$url_search)

      if(!is.null(query[['name']]) & !is.null(query[['score']])) {
        create_certificate(query[['name']], query[['score']])
      }

    })

    # http://127.0.0.1:5065/?name=Seb&score=40

    output$download_certiciate <- downloadHandler(
      filename = create_certificate_filename("Seb", 50),
      content = function(con) {
        file.copy(create_certificate_filename("Seb", 50), con)
      }
    )

  }

  shinyApp(ui, server)

}



#' Create certificate
#'
#' @param name
#' @param score
#'
#' @return
#' @export
#'
#' @examples
create_certificate <- function(name, score) {

  score <- as.character(score)


  # load either pdf or word certificate template
  template <- readr::read_file(system.file("extdata/certificate_template_pdf.Rmd", package = "gamifyr"))

  #replace the placeholder words in the template with the student information
  current_cert <- template %>%
    stringr::str_replace("<<FIRSTNAME>>", name) %>%
    stringr::str_replace("<<SCORE>>", score)

  #generate an output file name based on student name
  out_filename <- create_certificate_filename(name, score)

  #save customized Rmd to a temporary file
  readr::write_file(current_cert, "tmp.Rmd")

  #create the certificates using R markdown.
  #it will detect the ending of the output file and use the right format
  rmarkdown::render("tmp.Rmd", output_file = out_filename)

  #temporary Rmd file can be deleted.
  file.remove("tmp.Rmd")
}


#' Create certificate filename
#'
#' @param name
#' @param score
#'
#' @return
#' @export
#'
#' @examples
create_certificate_filename <- function(name, score) {
  paste(name, score, 'Certificate',sep="_") %>% paste0('certificates/', . ,'.pdf')
}


# create_certificate("Seb", 50)

