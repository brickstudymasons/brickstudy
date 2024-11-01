#Here, we would like to change the Participant Id numbers in the SCORE export repeating data files to BRICK participant Ids. This way, we can upload it to the BRICK castor
#here we read in the score repeating data files

library(dplyr)

#path is for windows machine /mnt/data on linux!. 
subset_key_table <- read.csv("Z:/castor_proof_files/csv_castor/current/brick_subset_key_table102024.csv")

# Read in all of the repeating data files from SCORE #path is for windows machine /mnt/data on linux!.

file_paths <- list(
  "visual_hearing" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Visual_and_hearing_disease_Medical_History_Clinical_manifestati_export_20240717.csv",
  "acute_complications" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Acute_complications_export_20240717.csv",
  "bone_extremities" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Bone_and_extremities_Medical_History_Clinical_manifestations_export_20240717.csv",
  "cardiac_pulmonary" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Cardiac_and_pulmonary_disease_Medical_History_Clinical_manifest_export_20240717.csv",
  "comorbidities" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Comorbidities_export_20240717.csv",
  "endocrinological" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Endocrinological_disease_Medical_History_Clinical_manifestation_export_20240717.csv",
  "registry" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__export_20240717.csv",
  "liver_kidney" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Liver_and_kidney_disease_Medical_History_Clinical_manifestation_export_20240717.csv",
  "neurological" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Neurological_disease_Medical_History_Clinical_manifestations_export_20240717.csv",
  "specific_treatment" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Treatment_Use_of_specific_treatment_or_inclusion_in_Clinical_Tr_export_20240717.csv",
  "chelation_treatment" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Treatments_chelation_export_20240717.csv",
  "hydroxyurea_treatment" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Treatments_hydroxyurea_export_20240717.csv",
  "visit" = "Z:/score_clinical_manifestationTOBEREVIEWED/SCORE_RADeep-registry__Visit_export_20240717.csv"
)

# Read each file into a data frame and assign to a variable with a short name
for (name in names(file_paths)) {
  assign(name, read.csv(file_paths[[name]], sep = ";", stringsAsFactors = FALSE))
}

# Example: Check the names of the data frames loaded
ls(pattern = "^visual_hearing|acute_complications|bone_extremities|cardiac_pulmonary|comorbidities|endocrinological|registry|liver_kidney|neurological|specific_treatment|chelation_treatment|hydroxyurea_treatment|visit$")

#solve weird encoding problem for participant id name
# List of your data frames
df_list <- list(
  visual_hearing = visual_hearing,
  acute_complications = acute_complications,
  bone_extremities = bone_extremities,
  cardiac_pulmonary = cardiac_pulmonary,
  comorbidities = comorbidities,
  endocrinological = endocrinological,
  registry = registry,
  liver_kidney = liver_kidney,
  neurological = neurological,
  specific_treatment = specific_treatment,
  chelation_treatment = chelation_treatment,
  hydroxyurea_treatment = hydroxyurea_treatment,
  visit = visit
)

# Clean the column name in each data frame. Weird encoding problem.
df_list <- lapply(df_list, function(df) {
  df %>%
    rename(Participant.Id = `ï..Participant.Id`)
})

# Optionally assign back to original data frame names
visual_hearing <- df_list$visual_hearing
acute_complications <- df_list$acute_complications
bone_extremities <- df_list$bone_extremities
cardiac_pulmonary <- df_list$cardiac_pulmonary
comorbidities <- df_list$comorbidities
endocrinological <- df_list$endocrinological
registry <- df_list$registry
liver_kidney <- df_list$liver_kidney
neurological <- df_list$neurological
specific_treatment <- df_list$specific_treatment
chelation_treatment <- df_list$chelation_treatment
hydroxyurea_treatment <- df_list$hydroxyurea_treatment
visit <- df_list$visit


# List of your data frames
df_list <- list(visual_hearing, acute_complications, bone_extremities, cardiac_pulmonary, comorbidities, endocrinological, registry, liver_kidney, neurological, specific_treatment, chelation_treatment, hydroxyurea_treatment, visit)

# Apply the left join and replacement across all data frames
df_list <- lapply(df_list, function(df) {
  df %>%
    left_join(subset_key_table, by = c("Participant.Id" = "RADeep_id")) %>%
    mutate(Participant.Id = Participant.Id.y) %>%
    select(-Participant.Id.y, -Participant.Id.x)
})

# Optionally assign back to original data frame names
names(df_list) <- c("visual_hearing", "acute_complications", "bone_extremities", "cardiac_pulmonary", "comorbidities", "endocrinological", "registry", "liver_kidney", "neurological", "specific_treatment", "chelation_treatment", "hydroxyurea_treatment", "visit")



