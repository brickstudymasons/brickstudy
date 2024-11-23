library(dplyr)
Koppelfile <-read.csv("Z:/Aida_experiment/Part_ID_PID.csv", sep= ";")
Marjolein_file <- read.csv("Z:/Aida_experiment/SCD_output_vol_table_BRIDGE_Marjolein.csv", sep= ",")

# Join the datasets based on "PID" and bring in "Participant Id" from Koppelfile
combined_data <- merge(Marjolein_file, Koppelfile[, c("PID", "Participant.Id")], by = "PID", all.x = TRUE)


#remove PID from the resulting file
combined_data <- combined_data[, !names(combined_data) %in% "PID"]

# Move "Participant Id" to the first column
combined_data <- combined_data[, c("Participant.Id", setdiff(names(combined_data), "Participant.Id"))]

# Write combined_data to a CSV file in the specified directory
write.csv(combined_data, "Z:/Aida_experiment/BRIDGE_T0.csv", row.names = FALSE)

##

#vergelijken freesurfer met marjolein data
brick_freesurfer <- read.csv("Z:/processed_data/freesurfer_stats/brain_volumes_from_freesurfer_no_qc.csv")

# Replace "-" with "_" in the "Participant Id" column of brick_freesurfer
brick_freesurfer$`Participant Id` <- gsub("-", "_", brick_freesurfer$`Participant Id`)

# Rename the 'Participant.Id' column to 'Participant Id' in combined_data
colnames(combined_data)[colnames(combined_data) == "Participant.Id"] <- "Participant Id"
colnames(brick_freesurfer)[colnames(brick_freesurfer) == "Participant.Id"] <- "Participant Id"


# First, rename the "Participant Id" columns in both dataframes
colnames(brick_freesurfer)[colnames(brick_freesurfer) == "Participant Id"] <- "Participant Id_brick"
colnames(combined_data)[colnames(combined_data) == "Participant Id"] <- "Participant Id_bridge"

# Replace "-" with "_" in the "Participant Id" column of brick_freesurfer
brick_freesurfer$`Participant Id_brick` <- gsub("-", "_", brick_freesurfer$`Participant Id_brick`)

# Now merge the two dataframes on the renamed Participant Id columns
merged_data <- merge(
  brick_freesurfer[, c("Participant Id_brick", "Right.Amygdala")],
  combined_data[, c("Participant Id_bridge", "Right.Amygdala")],
  by.x = "Participant Id_brick",
  by.y = "Participant Id_bridge",
  suffixes = c("_brick", "_bridge")
)

# View the resulting merged dataframe
head(merged_data)

###twice BRICK003 appears here. check for duplicates in Marjolein_file. Dit zijn 5873683 1192976 BRICK_009 en BRICK_003
# Extract the duplicate PID values
duplicate_values <- Marjolein_file$PID[duplicated(Marjolein_file$PID) | duplicated(Marjolein_file$PID, fromLast = TRUE)]

# Remove duplicates from the result to get unique duplicate values
unique_duplicates <- unique(duplicate_values)

# Display the unique duplicate values
print(unique_duplicates)

# now check ages. everything else looks fin
age_check <- read.csv("Z:/castor_proof_files/csv_castor/current/HbF_TCD_age_months_T020082024_ano_pres_castor.csv",sep=";")

# Step 1: Rename the 'ï..BRICK' column for clarity (optional)
colnames(age_check)[colnames(age_check) == "ï..BRICK"] <- "Participant_Id"

# Step 2: Merge the two dataframes on the relevant columns
merged_data <- merge(
  age_check[, c("Participant_Id", "Age_at_scan_y_T0X")],
  combined_data[, c("Participant Id_bridge", "Age.at.time.of.Scan")],
  by.x = "Participant_Id",
  by.y = "Participant Id_bridge",
  suffixes = c("_age_check", "_combined")
)

# Step 3: Compare the age columns
comparison_result <- merged_data[, c("Participant_Id", "Age_at_scan_y_T0X", "Age.at.time.of.Scan")]
comparison_result$Age_Match <- comparison_result$Age_at_scan_y_T0X == comparison_result$Age.at.time.of.Scan

# Display the comparison results
print(comparison_result)

#marjoleins data is niet in maanden uitgedrukt maar in . nogwat. ziet er goed genoeg uit wmb

 
