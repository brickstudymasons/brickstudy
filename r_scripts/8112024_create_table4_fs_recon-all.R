library(dplyr)
library(writexl)
library(tidyr)

# Read in the raw data file, ages, and volbrain data
raw <- read.csv("Z:/Aida_experiment/6112024_brick_castor_data/BRICK_export_20241106.csv", sep= ";")
ages <- read.csv("Z:/Aida_experiment/combined_BRICK_marjolein.csv", sep=",") #this file contains the ages and recon-all data
volbrain <- read.csv("Z:/castor_proof_files/csv_castor/current/volbrains_castor.csv") #contains volbrain output

# Rename first columns in the raw dataset for merging
raw <- raw %>% rename(Participant_Id = `ï..Participant.Id`)

# Rename participant id for later merge
ages <- ages %>% rename(Participant_Id = Participant.Id)


#Table 5: Recon-all volumetrics (white, grey and subcortical matter) with z-scores for 2 different kinds of growth charts.
# Calculate the Total Cortical Volume and Total Cerebellar Volume
table5 <- ages %>%
  mutate(
    Total_Cortical_Volume = CortexVol + Left.Cerebellum.Cortex + Right.Cerebellum.Cortex,
    Total_Cerebellar_Volume = Left.Cerebellum.Cortex + Right.Cerebellum.Cortex
  ) %>%
  
  # Select relevant columns for the table and rename for clarity
  select(
    `Participant_Id` = Participant_Id,
    `Age (years)` = Age_at_scan_y_T0X,
    `Gender` = gender_BRICK,
    
    # Total Volumes
    `Total Cortical Volume` = Total_Cortical_Volume,
    `Total White Matter Volume` = CerebralWhiteMatterVol,
    `Total Gray Matter Volume` = TotalGrayVol,
    `Total Cerebellar Volume` = Total_Cerebellar_Volume,
    
    # Subcortical Structures
    `Thalamus Left` = Left.Thalamus.Proper,
    `Thalamus Right` = Right.Thalamus.Proper,
    `Caudate Left` = Left.Caudate,
    `Caudate Right` = Right.Caudate,
    `Putamen Left` = Left.Putamen,
    `Putamen Right` = Right.Putamen,
    `Pallidum Left` = Left.Pallidum,
    `Pallidum Right` = Right.Pallidum,
    `Hippocampus Left` = Left.Hippocampus,
    `Hippocampus Right` = Right.Hippocampus
  )


#merge table5 with quality control column
table5_merged <- table5 %>%
  left_join(raw %>% select(Participant_Id, Exclude_Score_QC_T1w_T0), by = "Participant_Id")


#throw out the low-quality scans
table5_fs <- table5_merged %>%
  filter(
    Exclude_Score_QC_T1w_T0 != 1
  )
#now create the descriptive table

# Exclude Age (years) and Participant_Id from the variables list
vars <- c(
  "Total Cortical Volume", 
  "Total White Matter Volume", 
  "Total Gray Matter Volume", 
  "Total Cerebellar Volume",
  "Thalamus Left", "Thalamus Right", 
  "Caudate Left", "Caudate Right", 
  "Putamen Left", "Putamen Right", 
  "Pallidum Left", "Pallidum Right", 
  "Hippocampus Left", "Hippocampus Right"
)

# Using the tableone package to create the summary table with means and standard deviations
library(tableone)

# Creating a summary table using CreateTableOne
table_summary <- CreateTableOne(vars = vars, data = table5_fs, factorVars = c("Gender"))

# Print the table
print(table_summary)
