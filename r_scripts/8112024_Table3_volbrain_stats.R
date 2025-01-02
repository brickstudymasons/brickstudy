library(dplyr)
library(writexl)
library(tidyr)

# Read in the raw data file, ages, and volbrain data
raw <- read.csv("Z:/Aida_experiment/6112024_brick_castor_data/BRICK_export_20241106.csv", sep= ";")
ages <- read.csv("Z:/Aida_experiment/combined_BRICK_marjolein.csv", sep=",") #this file contains the ages and recon-all data
volbrain <- read.csv("Z:/castor_proof_files/csv_castor/current/volbrains_castor.csv") #contains volbrain output

# Rename participant id for later merge
volbrain <- volbrain %>% rename(Participant_Id = Participant.Id)

# Rename first columns in the raw dataset for merging
raw <- raw %>% rename(Participant_Id = `ï..Participant.Id`)

# Table 4: White matter hyperintensities
table4 <- volbrain %>%
  select(
    Participant_Id, dl_Sex_T0, dl_Age_T0, dl_Quality_control_T1_T0, dl_Quality_control_FLAIR_T0,
    dl_Total_lesion_count_T0, dl_Total_lesion_volume_.absolute._cm3_T0,
    dl_Total_lesion_volume_.normalized._._T0, dl_Total_lesion_burden_T0,
    dl_Periventricular_lesion_count_T0, dl_Periventricular_lesion_volume_.absolute._cm3_T0,
    dl_Periventricular_lesion_volume_.normalized._._T0, dl_Periventricular_lesion_burden_T0,
    dl_Deep_white_lesion_count_T0, dl_Deep_white_lesion_volume_.absolute._cm3_T0,
    dl_Deep_white_lesion_volume_.normalized._._T0, dl_Deep_white_lesion_burden_T0,
    dl_Juxtacortical_lesion_count_T0, dl_Juxtacortical_lesion_volume_.absolute._cm3_T0,
    dl_Juxtacortical_lesion_volume_.normalized._._T0, dl_Juxtacortical_lesion_burden_T0,
    dl_Infratentorial_lesion_count_T0, dl_Infratentorial_lesion_volume_.absolute._cm3_T0,
    dl_Infratentorial_lesion_volume_.normalized._._T0, dl_Infratentorial_lesion_burden_T0
  )

# Merge Exclude_Score_QC_T1w_T0 from raw dataset into table4
table4_merged <- table4 %>%
  left_join(raw %>% select(Participant_Id, Exclude_Score_QC_T1w_T0), by = "Participant_Id")

# Clean the quality control columns: Convert to character and trim whitespace
table4_merged <- table4_merged %>%
  mutate(
    dl_Quality_control_T1_T0 = trimws(as.character(dl_Quality_control_T1_T0)),
    dl_Quality_control_FLAIR_T0 = trimws(as.character(dl_Quality_control_FLAIR_T0))
  )

# Now exclude the low-quality scans based on the quality control columns ("C") or Exclude_Score_QC_T1w_T0 being 1
table4_volbrain_df <- table4_merged %>%
  filter(
    !(grepl("C", dl_Quality_control_T1_T0) | grepl("C", dl_Quality_control_FLAIR_T0)) & 
      Exclude_Score_QC_T1w_T0 != 1
  )

# View the filtered table
print(table4_volbrain_df)

#now create a table with volbrains descriptives
# Define the continuous variables for which you want to calculate means and SDs
continuous_vars <- c(
  "dl_Age_T0", 
  "dl_Total_lesion_count_T0", 
  "dl_Total_lesion_volume_.absolute._cm3_T0",
  "dl_Total_lesion_volume_.normalized._._T0", 
  "dl_Total_lesion_burden_T0", 
  "dl_Periventricular_lesion_count_T0", 
  "dl_Periventricular_lesion_volume_.absolute._cm3_T0",
  "dl_Periventricular_lesion_volume_.normalized._._T0", 
  "dl_Periventricular_lesion_burden_T0", 
  "dl_Deep_white_lesion_count_T0", 
  "dl_Deep_white_lesion_volume_.absolute._cm3_T0", 
  "dl_Deep_white_lesion_volume_.normalized._._T0", 
  "dl_Deep_white_lesion_burden_T0", 
  "dl_Juxtacortical_lesion_count_T0", 
  "dl_Juxtacortical_lesion_volume_.absolute._cm3_T0", 
  "dl_Juxtacortical_lesion_volume_.normalized._._T0", 
  "dl_Juxtacortical_lesion_burden_T0", 
  "dl_Infratentorial_lesion_count_T0", 
  "dl_Infratentorial_lesion_volume_.absolute._cm3_T0", 
  "dl_Infratentorial_lesion_volume_.normalized._._T0", 
  "dl_Infratentorial_lesion_burden_T0"
)

# Define the categorical variables if needed
categorical_vars <- c("dl_Sex_T0")  # If you want to include categorical variables like sex

# Create the descriptive table and assign it to table4_volbrain
table4_volbrain <- CreateTableOne(
  vars = c(continuous_vars, categorical_vars),  # Include both continuous and categorical variables
  data = table4_volbrain_df,                        # The dataset to summarize
  factorVars = categorical_vars,                 # Specify categorical variables
  includeNA = TRUE                               # Include NA values in the table if desired
)

# Print the table
print(table4_volbrain)


