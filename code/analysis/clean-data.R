library(tidyverse)

# Participants may refresh the experiment, which will restart the experiment.
# Here I define a function that reads a csv file, and adds a new variable 
# 'attempt' that stands for from which attempt each data row comes from.
# For instance, if a participant re-started the experiment, all data from the 
# second time will be from attempt 2, and so forth.
read_csv_add_attempt <- function(file_name) {
  
  # read the raw data file
  d_tmp <- read_csv(file_name, col_types = cols(.default = col_character()))
  
  # initialize the new variable 'attempt'
  d_tmp$attempt <- 0
  
  # each time when participants restarted the experiment,
  # the header would be written to the file as a row
  # thus, each time when the headers occurred in the file
  # we know that participants have re-started the experiment
  d_tmp <- d_tmp %>%
    mutate(
      attempt_increment = ifelse(time_elapsed == "time_elapsed", 1, 0),
      attempt = attempt + attempt_increment,
      attempt = cumsum(attempt),
      # the attempt variable starts counting from 0, change it into 1
      attempt = attempt + 1
    ) %>%
    # delete the variable attempt_increment
    select(-attempt_increment) %>%
    # delete the rows that include the header
    filter(time_elapsed != 'time_elapsed')
  
  return(d_tmp)
  
}



# clean the main data -----------------------------------------------------

# get a list of all files containing the main data
main_file_list <- list.files("../../data/raw/",
                             pattern = "Gambling_ITC_main",
                             full.names = TRUE)

# load data
d_main <- main_file_list %>%
  map_dfr(read_csv_add_attempt) 

# potentially due to an issue with the server, 
# some rows seem to be written to the data twice
d_main <- d_main %>%
  group_by(subjectID, trial_number, stage) %>%
  mutate(count = n())

# select rows that are registered once
d_main_ok <- d_main %>%
  filter(count == 1)

# for the repeatedly registered data, select one
d_main_not_ok <- d_main %>%
  filter(count == 2) %>%
  group_by(subjectID, trial_number, stage) %>%
  sample_n(1)

# put the two data frames back together
d_main <- bind_rows(d_main_ok, d_main_not_ok) %>%
  ungroup()

# change the data type of variables
d_main <- d_main %>%
  mutate(
    across(c(subjectID, block_number, trial_number, delay_time, immediate_amount), as.numeric),
    across(c(respRT, blur_count:attempt), as.numeric)
  )

d_main <- d_main %>%
  mutate(stage = factor(stage, levels = c("guess_start", "guess_choice", "guess_outcome", "ITC_start", "ITC_choice", "ITC_wait", "ITC_collect","ITC_outcome"))) %>%
  arrange(subjectID, block_number, trial_number, stage)

# some design checks
# number of stages per trial
stage_count <- d_main %>%
  count(subjectID, block_number, trial_number)

# check the last trial of each block
last_trial_count <- stage_count %>%
  group_by(subjectID, block_number) %>%
  filter(trial_number == max(trial_number))

# check the number of rows registered for each attempt
attempt_count <- d_main %>%
  count(subjectID, attempt)

# check all the other trials
# a few trials have fewer than 8 stages registered,
# data missing probably due to internet connection issues.
not_last_trial_count <- stage_count %>%
  group_by(subjectID, block_number) %>%
  filter(trial_number < max(trial_number))

# turn the data into wide format, so that one row contains data from one trial
# first do this for the RT data
d_RT_wide <- d_main %>%
  pivot_wider(
    id_cols = c(subjectID:trial_number, guess_outcome:immediate_amount),
    names_from = stage,
    names_prefix = "RT_",
    values_from = respRT) %>%
  # delete variables we do not need
  select(-c(RT_guess_outcome, RT_ITC_wait, RT_ITC_outcome))

# then do this for the keys pressed data
d_keys_wide <- d_main %>%
  pivot_wider(
    id_cols = c(subjectID, block_number, trial_number),
    names_from = stage,
    names_prefix = "key_",
    values_from = respKey) %>%
  # delete variables we do not need
  select(-c(key_guess_outcome, key_ITC_wait, key_ITC_outcome))

# then do this for the number of 'blur' (when participants leave the current page)
# and 'focus' (when participants enter the current page)
# to simplify things a bit, here we take the sum of both counts
d_blur_wide <- d_main %>%
  mutate(blur_count = blur_count + focus_count) %>%
  pivot_wider(
    id_cols = c(subjectID, block_number, trial_number),
    names_from = stage,
    names_prefix = "blur_",
    values_from = blur_count)

# now put everything together
d_wide <- d_RT_wide %>%
  full_join(d_keys_wide, by = c("subjectID", "block_number", "trial_number")) %>%
  full_join(d_blur_wide, by = c("subjectID", "block_number", "trial_number"))

# add a new variable for the choice in intertemporal choices
d_wide <- d_wide %>%
  mutate(
    ITC_chosen_pos = ifelse(key_ITC_choice == "f", "left", "right"),
    ITC_choice = ifelse(ITC_chosen_pos == delay_pos, "delay", "immediate")
  )

# save as csv file
write_csv(d_wide, "../../data/processed/Gambling_ITC_main.csv")


# data from the MCQ -------------------------------------------------------

# get a list of all files containing the MMCQ data
MCQ_file_list <- list.files("../../data/raw/",
                             pattern = "Gambling_ITC_MCQ",
                             full.names = TRUE)

# load data
d_MCQ <- MCQ_file_list %>%
  map_dfr(read_csv_add_attempt) 

# save as csv file
write_csv(d_MCQ, "../../data/processed/Gambling_ITC_MCQ.csv")



# data from the SAM -------------------------------------------------------

# get a list of all files containing the SAM data
SAM_file_list <- list.files("../../data/raw/",
                            pattern = "Gambling_ITC_SAM",
                            full.names = TRUE)

# load data
d_SAM <- SAM_file_list %>%
  map_dfr(~read_csv(.x, col_types = cols(.default = "c")))%>%
  filter(subjectID != "subjectID")

# save as csv file
write_csv(d_SAM, "../../data/processed/Gambling_ITC_SAM.csv")



# payoff data -------------------------------------------------------------

# get a list of all files containing the payoff data
payoff_file_list <- list.files("../../data/raw/",
                            pattern = "Gambling_ITC_payoff",
                            full.names = TRUE)

# load data
d_payoff <- payoff_file_list %>%
  map_dfr(~read_csv(.x, col_types = cols(.default = "c"))) %>%
  filter(subjectID != "subjectID")

# save as csv file
write_csv(d_payoff, "../../data/processed/Gambling_ITC_payoff.csv")


