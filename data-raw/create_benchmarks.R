

library(tidyverse)

benchmark_data <- read.csv('data-raw/all_data.csv') %>%
  select(time.finished, time.started, age,gender,
         GMS.general,
         MPT.score, BAT.score, MDI.score,
         # Optional Tests
         RAT.score,
         EDT.score,
         PIAT.score,
         HPT.score,
         MSA.score
         ) %>%
  rename(MDT.score = MDI.score,
         GMS.score = GMS.general)


aggregated_data <- benchmark_data %>%
  select(contains(".score")) %>%
  summarise(across(everything(), .fns = list(mean = mean, sd = sd), na.rm = TRUE))


# Add manually:


# "Timbre Perception Test" = "tptR::TPT",
# "Beat Drop Alignment" = "BDT::BDT",
# "Musical Preferences Test" = "psyquest::MUS"
#"Singing Ability Test" = "SAA::SAA"


aggregated_data <- aggregated_data %>%
  mutate(
    TPT.score_mean = 3.629,
    TPT.score_sd = 0.501,

    BDT.score_mean = 0.04,
    BDT.score_sd = 1.17,

    STOMPMellow.score_mean = 5.9,
    STOMPMellow.score_sd = 1.53,

    STOMPUnpretentious.score_mean = 5.14,
    STOMPUnpretentious.score_sd = 1.63,

    STOMPSophisticated.score_mean = 4.54,
    STOMPSophisticated.score_sd = 1.49,

    STOMPIntense.score_mean = 4.2,
    STOMPIntense.score_sd = 1.76,

    SAA.score_mean = 0.00,
    SAA.score_sd = 0.11
  )






aggregated_data_long <- aggregated_data %>%
  pivot_longer(everything(), names_sep = "_", names_to = c("Test", "Statistic")) %>%
  pivot_wider(everything(), names_from = "Test") %>%
  t() %>%
  as.data.frame() %>%
  tibble::rownames_to_column(var = "Test") %>%
  janitor::row_to_names(row_number = 1) %>%
  rename(Test = Statistic) %>%
  mutate(across(mean:sd, as.numeric)) %>%
  rowwise() %>%
  mutate(
    PercentileFunction = list(ecdf(rnorm(1000, mean, sd)))
  ) %>%
  ungroup() %>%
  mutate(Test = stringr::str_remove(Test, ".score"))


processFile <- function(filepath) {
  con <- file(filepath, "r")
  lines <- readLines(con)
  close(con)
  lines
}

female_names <- processFile('data-raw/female_names.txt')
male_names <- processFile('data-raw/male_names.txt')


benchmark_leaderboard <- benchmark_data %>%
  select(age:MDT.score) %>%
  rename(Age = age, Gender = gender,
         `Musical Sophistication` = GMS.score,
         `Mistuning Perception` = MPT.score,
         `Beat Perception` = BAT.score,
         `Melody Perception` = MDT.score) %>%
  na.omit %>%
  mutate(Gender = case_when(Gender == "male" ~ "Male", TRUE ~ Gender)) %>%
  rowwise() %>%
  mutate(Name = if(Gender == "Male") sample(male_names, 1) else sample(female_names, 1),
         `Musical Sophistication` = get_test_percentile("GMS", `Musical Sophistication`),
         `Mistuning Perception` = get_test_percentile("MPT", `Mistuning Perception`),
         `Beat Perception` = get_test_percentile("BAT", `Beat Perception`),
         `Melody Perception` = get_test_percentile("MDT", `Melody Perception`)
         ) %>%
  ungroup() %>%
  relocate(Name) %>%
  mutate(`Musical Sophistication` = `Musical Sophistication` * 100,
        `Mistuning Perception` =  `Mistuning Perception` * 100,
        `Beat Perception` =  `Beat Perception` * 100,
        `Melody Perception` =  `Melody Perception` * 100) %>%
  rowwise() %>%
  mutate(`Musical Genius` = mean(`Mistuning Perception`:`Melody Perception`)) %>%
  ungroup()


# use_data(aggregated_data, aggregated_data_long, benchmark_data, benchmark_leaderboard, internal = TRUE, overwrite = TRUE)
