#Here, we would like to change the Participant Id numbers in the SCORE export repeating data files to BRICK participant Ids. This way, we can upload it to the BRICK castor
#here we read in the score repeating data files
library(dplyr)

# Read the subset key table and rename the Participant.Id to BRICK_Id
subset_key_table <- read.csv("Z:/castor_proof_files/csv_castor/current/brick_subset_key_table102024.csv") %>%
  rename(BRICK_Id = Participant.Id)

# Read in all of the repeating data files from SCORE #path is for windows machine /mnt/data on linux!.
# Read in all of the repeating data files from SCORE
file_paths <- list(
  visual_hearing = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Visual_and_hearing_disease_Medical_History_Clinical_manifestati_export_20240717.csv",
  acute_complications = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Acute_complications_export_20240717.csv",
  bone_extremities = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Bone_and_extremities_Medical_History_Clinical_manifestations_export_20240717.csv",
  cardiac_pulmonary = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Cardiac_and_pulmonary_disease_Medical_History_Clinical_manifest_export_20240717.csv",
  comorbidities = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Comorbidities_export_20240717.csv",
  endocrinological = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Endocrinological_disease_Medical_History_Clinical_manifestation_export_20240717.csv",
  registry = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__export_20240717.csv",
  liver_kidney = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Liver_and_kidney_disease_Medical_History_Clinical_manifestation_export_20240717.csv",
  neurological = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Neurological_disease_Medical_History_Clinical_manifestations_export_20240717.csv",
  specific_treatment = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Treatment_Use_of_specific_treatment_or_inclusion_in_Clinical_Tr_export_20240717.csv",
  chelation_treatment = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Treatments_chelation_export_20240717.csv",
  hydroxyurea_treatment = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Treatments_hydroxyurea_export_20240717.csv",
  visit = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Visit_export_20240717.csv"
)

# Read each file into a data frame and store in df_list
df_list <- lapply(file_paths, function(path) {
  read.csv(path, sep = ";", stringsAsFactors = FALSE)
})

# Rename the first column in each data frame to RADeep_id
df_list <- lapply(df_list, function(df) {
  colnames(df)[1] <- "RADeep_id"
  df
})

# Merge each data frame with subset_key_table, bringing in BRICK_Id and renaming it to Participant Id
df_list <- lapply(df_list, function(df) {
  df %>%
    left_join(subset_key_table, by = "RADeep_id") %>%  # Join on RADeep_id
    mutate(`Participant Id` = BRICK_Id) %>%  # Create Participant Id from BRICK_Id
    select(`Participant Id`, everything(), -BRICK_Id)  # Arrange columns accordingly
})

# Optionally assign back to original data frame names
names(df_list) <- names(file_paths)

# Assign back to individual data frames if needed
list2env(df_list, envir = .GlobalEnv)

# Define the output directory for the updated CSV files
output_dir <- "Z:/castor_proof_files/csv_castor/current/"

# Ensure the output directory exists
dir.create(output_dir, showWarnings = FALSE)

# Write each data frame to a CSV file in the output directory
for (name in names(df_list)) {
  write.csv(df_list[[name]], file = paste0(output_dir, name, "_updated.csv"), row.names = FALSE)
}

# Confirm file creation
cat("CSV files have been created in:", output_dir, "\n")
