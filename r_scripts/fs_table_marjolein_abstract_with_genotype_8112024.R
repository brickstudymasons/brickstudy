## this script is for adding the genotype column to the original file I sent to Marjolein for the growth charts paper

library(dplyr)

ages <-read.csv("Z:/Aida_experiment/combined_BRICK_marjolein.csv", sep=",") #this file contains the ages and recon-all data, as I apparently cannot export calculated fields from castor
raw <- read.csv("Z:/Aida_experiment/6112024_brick_castor_data/BRICK_export_20241106.csv", sep= ";") #contains a castor-export

#select the genotype colum from the raw df
genotype <- raw %>% select(Participant_Id, brick_genotype)

#rename first columns in order to merge later.
raw <- raw %>%
  rename(Participant_Id = `ï..Participant.Id`)

ages <- ages %>% 
  rename(Participant_Id = Participant.Id)

#now link the brick_genotype to the data in the ages df and put it as a sixth column
# Merge the genotype with the ages dataset by Participant_Id
ages_with_genotype <- ages %>%
  left_join(genotype, by = "Participant_Id")

# Reorder columns to place 'brick_genotype' as the sixth column
ages_with_genotype <- ages_with_genotype %>%
  select(1:5, brick_genotype, everything())

# Add the 'severe_genotype' column: 1 for HbSS and HbSb0, 0 for the others
ages_with_genotype <- ages_with_genotype %>%
  mutate(severe_genotype = case_when(
    brick_genotype == "HbSS" ~ 1,
    brick_genotype == "HbSb0" ~ 1,
    TRUE ~ 0
  ))

# Reorder columns to place 'severe_genotype' after 'brick_genotype'
ages_with_genotype <- ages_with_genotype %>%
  select(1:6, severe_genotype, everything())

# Check the first few rows to ensure it looks correct
head(ages_with_genotype)

# Optionally, save the new dataset with the added genotype column
write.csv(ages_with_genotype, "Z:/Aida_experiment/combined_BRICK_marjolein_with_genotype.csv", row.names = FALSE)