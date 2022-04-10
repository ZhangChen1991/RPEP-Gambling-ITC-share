# R code to remove subject IDs

library(tidyverse)

# function to open a file, remove the subject ID,
# and save the data as a new file, while removing the old file
remove_ID <- function(file_name, old_ID, new_ID){
  # file_name: the rest of the file name, containing the directory names
  # old_ID: the original subject ID
  # new_ID: the new anonymous ID participants get
  
  old_file <- paste0(file_name, old_ID, ".csv")
  new_file <- paste0(file_name, new_ID, ".csv")
  
  # open the original file and replace the subject ID in the data
  d_tmp <- read_csv(old_file) %>%
    rename(subjectID = prolific_ID) %>%
    mutate(subjectID = ifelse(subjectID == "prolific_ID", "subjectID", new_ID))
  
  # the payoff file also contains the email address
  # remove it
  if("answer" %in% names(d_tmp)){
    d_tmp <- d_tmp %>%
      filter(question != "email")
  }
  
  # save the modified data as a new file
  write_csv(d_tmp, file = new_file)
  file.remove(old_file)
  
}

# get a list of all subject IDs
subjectID_list <- list.files("../../data/pilot/", pattern = "Gambling_ITC_main", full.names = FALSE)

subjectID_list <- subjectID_list %>%
  str_remove("Gambling_ITC_main_") %>%
  str_remove(".csv")

# go through the participants one by one
for (old_ID in subjectID_list){
  
  # each participant has three files, named main, memory and UPPSP
  file_name_list <- c("main", "MCQ", "payoff", "SAM")
  
  new_ID <- which(old_ID == subjectID_list) 
    
  for (a_file in file_name_list) {
      
    file_name <- paste0("../../data/pilot/Gambling_ITC_", a_file, "_")
      
    remove_ID(file_name, old_ID, new_ID)
      
  }
}
