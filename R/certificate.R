


#* Create certificate and return its name
#* @param name Name to go on certificate.
#* @param overall The overall score.
#* @param bat
#* @param bdt
#* @param edt
#* @param hpt
#* @param mdt
#* @param mpt
#* @param msa
#* @param mus_mellow
#* @param mus_unpretentious
#* @param mus_sophisticiated
#* @param mus_intense
#* @param mus_contemporary
#* @param piat
#* @param rat
#* @param saa
#* @param tpt
#* @get /createcertificate
function(name,
         overall_score,
         bat,
         bdt,
         edt,
         hpt,
         mdt,
         mpt,
         msa,
         mus_mellow,
         mus_unpretentious,
         mus_sophisticiated,
         mus_intense,
         mus_contemporary,
         piat,
         rat,
         saa,
         tpt) {

  gamifyr::create_certificate(name,
                              overall_score,
                              bat,
                              bdt,
                              edt,
                              hpt,
                              mdt,
                              mpt,
                              msa,
                              mus_mellow,
                              mus_unpretentious,
                              mus_sophisticiated,
                              mus_intense,
                              mus_contemporary,
                              piat,
                              rat,
                              saa,
                              tpt)

  gamifyr::create_certificate_filename(name, score)
}

# plumber::pr("R/certificate.R") %>% plumber::pr_run(port=8000)

# http://localhost:8000/createcertificate?name=Seb&score=50
# http://adaptiveeartraining.com:4000/createcertificate?name=Seb&score=50

# res <- httr::GET("http://localhost:8000/createcertificate", query = list(name = "Seb", score = 52))
# status_code(res)
# certificate_name <- httr::content(res)[[1]]



#' Create certificate
#'
#' @param name
#' @param overall_score
#* @param bat
#* @param bdt
#* @param edt
#* @param hpt
#* @param mdt
#* @param mpt
#* @param msa
#* @param mus_mellow
#* @param mus_unpretentious
#* @param mus_sophisticiated
#* @param mus_intense
#* @param mus_contemporary
#* @param piat
#* @param rat
#* @param saa
#* @param tpt
#'
#' @return
#' @export
#'
#' @examples
create_certificate <- function(name,
                               overall_score,
                               bat, # Core test
                               bdt = NA,
                               edt = NA,
                               hpt = NA,
                               mdt, # Core test
                               mpt, # Core test
                               msa = NA,
                               mus_mellow = NA,
                               mus_unpretentious = NA,
                               mus_sophisticiated = NA,
                               mus_intense = NA,
                               piat = NA,
                               rat = NA,
                               saa = NA,
                               tpt = NA) {

  # https://www.andreashandel.com/posts/2020-10-15-customized-documents-with-rmarkdown/#templates


  cat(file=stderr(), "create_certificate", "\n")

  cat(file=stderr(), system.file("extdata/certificate_template_pdf_v2.Rmd", package = "gamifyr"))

  cat(file=stderr(), "read_file...", "\n")


  # load either pdf or word certificate template
  template <- readr::read_file(system.file("extdata/certificate_template_pdf_v2.Rmd", package = "gamifyr"))

  #replace the placeholder words in the template with the student information
  current_cert <- template %>%
    stringr::str_replace("<<name>>", as.character(name)) %>%
    stringr::str_replace("<<overall_score>>", as.character(overall_score)) %>%
    stringr::str_replace("<<mpt>>", as.character(mpt)) %>%
    stringr::str_replace("<<mdt>>", as.character(mdt)) %>%
    stringr::str_replace("<<bat>>", as.character(bat)) %>%
    stringr::str_replace("<<rat>>", if(is.na(rat)) "n/a" else as.character(rat)) %>%
    stringr::str_replace("<<edt>>", if(is.na(edt)) "n/a" else as.character(edt)) %>%
    stringr::str_replace("<<tpt>>", if(is.na(tpt)) "n/a" else as.character(tpt)) %>%
    stringr::str_replace("<<bdt>>", if(is.na(bdt)) "n/a" else as.character(bdt)) %>%
    stringr::str_replace("<<piat>>", if(is.na(piat)) "n/a" else as.character(piat)) %>%
    stringr::str_replace("<<hpt>>", if(is.na(hpt)) "n/a" else as.character(hpt)) %>%
    stringr::str_replace("<<msa>>", if(is.na(msa)) "n/a" else as.character(msa)) %>%
    stringr::str_replace("<<mus_mellow>>", if(is.na(mus_mellow)) "n/a" else as.character(mus_mellow)) %>%
    stringr::str_replace("<<mus_unpretentious>>", if(is.na(mus_unpretentious)) "n/a" else as.character(mus_unpretentious)) %>%
    stringr::str_replace("<<mus_sophisticiated>>", if(is.na(mus_sophisticiated)) "n/a" else as.character(mus_sophisticiated)) %>%
    stringr::str_replace("<<mus_intense>>", if(is.na(mus_intense)) "n/a" else as.character(mus_intense)) %>%
    stringr::str_replace("<<mus_contemporary>>", if(is.na(mus_contemporary)) "n/a" else as.character(mus_contemporary)) %>%
    stringr::str_replace("<<saa>>", if(is.na(saa)) "n/a" else as.character(saa))

  print(current_cert)

  cat(file=stderr(), "create_certificate_filename", "\n")

  #generate an output file name based on student name
  out_filename <- create_certificate_filename(name, overall_score)

  cat(file=stderr(), out_filename, "\n")

  cat(file=stderr(), "write_file...", "\n")


  #save customized Rmd to a temporary file

  readr::write_file(current_cert, config::get("cert_render_path"))

  cat(file=stderr(), "render...", "\n")

  #create the certificates using R markdown.
  #it will detect the ending of the output file and use the right format
  rmarkdown::render(config::get("cert_render_path"), output_file = out_filename)

  cat(file=stderr(), "file.remove...", "\n")

  #temporary Rmd file can be deleted.
  file.remove(config::get("cert_render_path"))
}

# create_certificate(name = "Sebb", overall = 100, mdt = 50, mpt = 25, bat = 30)

#' Create certificate filename
#'
#' @param name
#' @param overall_score
#'
#' @return
#' @export
#'
#' @examples
create_certificate_filename <- function(name, overall_score) {
  paste(name, overall_score, 'Certificate',sep="_") %>% paste0(config::get("cert_location"), . ,'.pdf')
}





