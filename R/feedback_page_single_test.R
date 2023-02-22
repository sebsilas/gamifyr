

feedback_page_single_test <- function(num_items, test_acronym, items_correct = FALSE) {

  reactive_page(function(state, ...) {

    results <- psychTestR::results(state)

    if(test_acronym == "MSA") {
      score <- results[["MSA_results"]]$ability %>% as.numeric()
    } else if(test_acronym == "TPT") {
      score <- results$results$tpt_general_score
    }  else if(test_acronym == "MUS") {
      score_contemporary <- results$MUS$Contemporary
      score_unpretentious <- results$MUS$Unpretentious
      score_intense <- results$MUS$Intense
      score_sophisticated <- results$MUS$Sophisticated
      score_mellow <- results$MUS$Mellow
    } else {
      score <- as.numeric(results[[test_acronym]]$ability)
    }


    test_scores <- psychTestR::get_global("test_scores", state)

    if(is.null(test_scores)) {
      test_scores <- produce_scores_holder()
    }

    # Set test scores
    if(test_acronym == "MUS") {
      test_scores <-  test_scores %>%
        set_score("mus_contemporary", score_contemporary) %>%
        set_score("mus_mellow", score_mellow) %>%
        set_score("mus_unpretentious", score_unpretentious) %>%
        set_score("mus_sophisticated", score_sophisticated) %>%
        set_score("mus_intense", score_intense)

      percentile_score <- NA
    } else {
      test_scores <- set_score(test_scores, tolower(test_acronym), score)
      # Get test percentile for later (if appropriate)
      percentile_score <- get_test_percentile_wrapper(test_acronym, score)
    }
    psychTestR::set_global("test_scores", test_scores, state)



    if(items_correct) {
      num_items_correct <- 9999999
    }

    test_result_description <- get_test_result_description(test_acronym)

    par(mar=c(1,1,1,1))
    # Fix figure margins too large error

    # Grab plot
    plot <- get_plot(test_acronym, percentile_score, score_contemporary, score_unpretentious, score_intense, score_sophisticated, score_mellow)

    one_button_page(
      shiny::tags$div(
        tags$p(paste0("Well done, you finished the ", test_acronym_to_name(tolower(test_acronym)), ".")),
        tags$p(test_result_description),
        if(items_correct) shiny::tags$p(paste0("You got ", num_items_correct, "/", num_items, " questions correct.")),
        if(test_acronym != "MUS") shiny::tags$p(pretty_percentile(percentile_score)),
        tags$div(shiny::renderPlot({ plot }) )
    ))

  })

}


get_plot <- function(test_acronym,
                     percentile_score = NULL,
                     score_contemporary = NULL,
                     score_unpretentious = NULL,
                     score_intense = NULL,
                     score_sophisticated = NULL,
                     score_mellow = NULL) {

  test_acronym <- tolower(test_acronym)

  if(test_acronym == "mus") {

    score_holder <- tibble(
      Contemporary = score_contemporary,
      Unpretentious = score_unpretentious,
      Intense = score_intense,
      Sophisticated = score_sophisticated,
      Mellow = score_mellow)

    plot <- ggradar::ggradar(score_holder, grid.max = 7, grid.mid = 3.5)

  } else {
    plot <- musicassessr::plot_normal_dist_plus_score(mean = 50, sd = 10, highlighted_score = percentile_score*100)
  }

}

get_test_percentile_wrapper <- function(test_acronym, score) {
  print('get_test_percentile_wrapper')
  print(test_acronym)
  if(test_acronym == "TPT") {
    percentile_score <- score/100
  } else if(test_acronym == "mus") {
    percentile_score <- NA # A percentile doesn't make sense for the STOMP
  } else {
    percentile_score <- get_test_percentile(test_acronym, score)
  }
  percentile_score
}

produce_scores_holder <- function() {
  tibble::tibble(
    test_acronym = c("overall", "mpt", "bat", "mdt", setdiff(optional_test_acronyms(), "mus"))
  ) %>% rbind(
    tibble::tibble( test_acronym = c("mus_mellow", "mus_unpretentious", "mus_sophisticated", "mus_intense", "mus_contemporary") )
  ) %>%
    mutate(score = as.character(NA) )
}




get_test_result_description <- function(test_acronym) {
  test_acronym <- tolower(test_acronym)
  switch(test_acronym,
         mpt = "The mistuning perception test evaluates how good you are at detecting whether someone sings in tune, which is an important aspect of the perceived quality of vocal music.",
         mdt = "The melodic discrimation task measures ability to detect differences between melodies, which are often part of musical aptitude tests.  assess an individual’s innate capacity for musical success. Musical aptitude tests are still often used as part of entrance exams for school music scholarships, in order to distinguish musical potential from learned ability.",
         bat = "The beat alignment test measures beat perception, the process of inferring an underlying pulse or beat from an extract of music. Beat perception is increasingly being recognised as a fundamental musical ability. It may indicate musical aptitude (a student’s capacity for future musical success) as well as forming an important aspect of trained musicianship.",
         rat = "The rhythm ability test measures rhythmic pattern recognition, an important musical ability, which may predict musical success.",
         edt = "The emotional discrimination test measures ability to determine emotions in a piece of music. Previous research has shown that levels of musical training and emotional engagement with music are associated with an individual’s ability to decode the intended emotional expression from a music performance.",
         tpt = "The timbre pereception test measures the ability to discriminate between different types of sound. Timbre is a primary perceptual attribute of complex sound, alongside pitch and loudness. Though, unlike pitch and loudness that are mainly related to a single physical parameter (i.e., frequency and sound intensity), timbre is multidimensional and arises from complex acoustic properties. It is broadly defined as colour or texture of an instrument. Our ability to perceive such qualities from sounds enable us to discriminate a musical piece played by a buzzy trumpet from the same piece played by a mellow flute, even when both instruments are equal in loudness, tempo, and pitch.",
         bdt = "The beat detection test measures beat detection, the process of inferring an underlying pulse or beat from an extract of music. Beat perception is increasingly being recognised as a fundamental musical ability. It may indicate musical aptitude (a student’s capacity for future musical success) as well as forming an important aspect of trained musicianship.",
         piat = "The pitch imagery arrow test measures the ability to engage with musical imagery. Musical imagery can be described as 'hearing a tune in your head'. It is a common, everyday experience even for those with no musical training. ",
         hpt = "The harmonic perception test measures the ability to detect chord changes. It may be a particularly useful skill e.g., for jazz musicians, who think about improvising based on changing chord patterns.",
         msa = "The musical scene analysis test detects our ability to detect a particular musical sound among others - an important problem the brain has to solve: the so-called 'cocktail party problem'!",
         mus = "The musical preferences test measures our musical preferences across five domains thought to be important to musical listening: mellowness, sophisticatedness, unpretentiousness, intensity and how contemporary a piece is.",
         saa = "The singing ability assessment measures our ability to sing in tune as well as remember melodies - two fundamental human skills. Singing is the most primitive, well-known musical capacity which could be a fundamental basis of all musicianship.",
         stop("Invalid test_acronym value")
  )
}
