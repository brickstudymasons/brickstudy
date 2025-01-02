#In this file, we will build the design matrix for the TBSS analysis
#We will compare male vs female and severe genotype vs less severe genotype
#the continous variables we will include, are age and point of sickling

library(dplyr)
library(stringr)

#find the files with PoS, age, sex
pos <- read.csv("Z:/Oxygenscan_data_BRICK/20240723_BRICK_Oxygenscan data_bewerkt.csv")

#rename_columns
pos <- pos %>%
  rename(Participant_Id = `BRICK.ID`) %>%
  mutate(Participant_Id = str_replace_all(str_to_upper(Participant_Id), "-", "_")) %>%
  rename(point_of_sickling = 'Point.of.sickling..pO2.95.EI.')


dems <- read.csv("Z:/Aida_experiment/combined_BRICK_marjolein_with_genotype.csv")

#create a combined table with age in months, years, gender and pos and severe genotype. There will be NAs in point of sickling columns 
for_design_matrix_TBSS <- dems %>%
  mutate(Participant_Id = str_replace_all(str_to_upper(Participant_Id), "-", "_")) %>% # Ensure consistent formatting
  select(Participant_Id, Age_at_scan_y_T0X, Age_at_scan_m_T0X, gender_BRICK, severe_genotype) %>%
  left_join(pos %>% select(Participant_Id, point_of_sickling), by = "Participant_Id")

# change gender_BRICK into 0 and 1s. So male=1 and female is 0
for_design_matrix_TBSS <- for_design_matrix_TBSS %>%
  mutate(gender_BRICK = ifelse(gender_BRICK == 2, 0, 1))

#check how many PoS observations we have. This is 45!
count_non_na <- sum(!is.na(for_design_matrix_TBSS$point_of_sickling))
count_non_na


