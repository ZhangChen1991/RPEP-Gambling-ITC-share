# R code to randomly select five participants,
# and pick one of the six blocks.

library(tidyverse)
set.seed(1234)

files_pilot <- list.files("../../data/plot/", pattern = "payoff", full.names = TRUE)
files_main <- list.files("../../data/raw/", pattern = "payoff", full.names = TRUE)

files <- c(files_pilot, files_main)

df_payoff <- files %>%
  map_dfr(~read_csv(.x, col_types = cols(.default = "c"))) %>%
  filter(prolific_ID != "prolific_ID") %>%
  pivot_wider(id_cols = prolific_ID,
              names_from = question, values_from = answer)

# only select participants who have left their email address
# and then randomly pick 5 out of the remaining participants
df_selected <- df_payoff %>%
  drop_na() %>%
  sample_n(size = 5)

# for each selected participant, we need to randomly pick one block
df_selected_block <- df_selected %>%
  pivot_longer(cols = Block1:Block6,
               names_to = "Block", values_to = "Points") %>%
  group_by(prolific_ID) %>%
  sample_n(size = 1) %>%
  mutate(
    Points = as.numeric(Points),
    Money = ifelse(Points >= 1000, 10.00, Points/100)
  )

write_csv(df_selected_block, "winner.csv")
