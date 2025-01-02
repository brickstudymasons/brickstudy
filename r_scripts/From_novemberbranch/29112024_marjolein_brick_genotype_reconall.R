#this script is to add the quality check column to the marjolein with genotype file
library(dplyr)

marjolein <- read.csv("Z:/Aida_experiment/combined_BRICK_marjolein_with_genotype.csv", sep=",") #this file contains the demographics and recon-all data
qc <- read.csv("Z:/Aida_experiment/25112024_BRICK_csv_export/BRICK_export_20241125.csv", sep= ";") #most recent 29-11 export castor with qc column
  

qc <- qc %>%
  rename(Participant_Id = `ï..Participant.Id`)


marjolein<- marjolein %>%
left_join(qc %>% select(Participant_Id, Exclude_Score_QC_T1w_T0), by = "Participant_Id")

marjolein <- marjolein %>%
  relocate(Exclude_Score_QC_T1w_T0, .after = 8)

write.csv(marjolein, "Z:/Aida_experiment/Growthcurves_paper/marjolein_fs_table_qc_genotype.csv", row.names = FALSE)
