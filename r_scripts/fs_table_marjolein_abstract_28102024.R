library(dplyr)
#this script is for preparing a table for Marjolein to plot in the references curves and pull out z-scores
#load relevant datasets
brick_fs <- read.csv("Z:/processed_data/freesurfer_stats/brain_volumes_from_freesurfer_no_qc.csv") #freesurfer output all brick subjects
Koppelfile <-read.csv("Z:/Aida_experiment/Part_ID_PID.csv", sep= ";") #contain PID and BRICK Participant ID
Marjolein_file <- read.csv("Z:/Aida_experiment/SCD_output_vol_table_BRIDGE_Marjolein.csv", sep= ",") #contains BRIDGE data and PID
age_check <- read.csv("Z:/castor_proof_files/csv_castor/current/HbF_TCD_age_months_T020082024_ano_pres_castor.csv",sep=";")#contains ages of brick participants in months
permissions <- read.csv("Z:/Aida_experiment/BRICK_export_permissions_20241029.csv", sep=";")

# Perform a left join to keep all rows from Koppelfile, adding "SubjectID" from Marjolein_file where PID matches
brickbridge_fs <- merge(Koppelfile, Marjolein_file[, c("PID", "SubjectID")], by = "PID", all.x = TRUE)

# Remove the PID column
brickbridge_fs <- brickbridge_fs[, !names(brickbridge_fs) %in% "PID"]

# Move "SubjectID" to the first column
brickbridge_fs <- brickbridge_fs[, c("SubjectID", setdiff(names(brickbridge_fs), "SubjectID"))]

# Replace hyphens with underscores in Participant.ID of brick_fs
brick_fs$Participant.ID <- gsub("-", "_", brick_fs$Participant.ID)

# Perform a left join to combine brickbridge_fs with brick_fs based on matching Participant IDs
combined_brick <- merge(brickbridge_fs, brick_fs, by.x = "Participant.Id", by.y = "Participant.ID", all = TRUE)

#now add the age in months to this df

# Rename the first column of age_check to Participant.Id
colnames(age_check)[1] <- "Participant.Id"

# Trim whitespace and standardize case in both data frames
combined_brick$Participant.Id <- trimws(toupper(combined_brick$Participant.Id))
age_check$Participant.Id <- trimws(toupper(age_check$Participant.Id))


# Merge combined_brick with age_check based on Participant.Id
# Merge combined_brick with age_check based on Participant.Id, including both age and gender columns
combined_brick <- merge(combined_brick, age_check[, c("Participant.Id", "Age_at_scan_m_T0X", "gender_BRICK")], 
                         by = "Participant.Id", all.x = TRUE)

# Remove the column called "X" if it exists
combined_brick <- combined_brick[, !names(combined_brick) %in% "X"]

# Create the Age_at_scan_y_T0X column (age in years)
combined_brick$Age_at_scan_y_T0X <- combined_brick$Age_at_scan_m_T0X / 12

# Reorder the columns to place Age_at_scan_m_T0X as the third column, 
# Age_at_scan_y_T0X as the fourth column, and gender_BRICK as the fifth column
column_order <- c(names(combined_brick)[1:2], "Age_at_scan_m_T0X", "Age_at_scan_y_T0X", "gender_BRICK", 
                  setdiff(names(combined_brick), c("Participant.Id", "Age_at_scan_m_T0X", "Age_at_scan_y_T0X", "gender_BRICK")))
combined_brick <- combined_brick[, column_order]

# Remove duplicates based on Participant.Id while keeping the first occurrence .That would be brick 3 and 9
combined_brick <- combined_brick %>%
  distinct(Participant.Id, .keep_all = TRUE)

#add the permissions from castor export
# Rename the column in permissions
colnames(permissions)[colnames(permissions) == "ï..Participant.Id"] <- "Participant Id"

# Merge the two data frames, keeping only the necessary column from permissions
combined_brick <- merge(
  combined_brick, 
  permissions[, c("Participant Id", "permission_data_sharing_for_other_studies")], 
  by.x = "Participant.Id", 
  by.y = "Participant Id", 
  all.x = TRUE
)

# Reorder columns to place "permission_data_sharing_for_other_studies" as the sixth column
combined_brick <- combined_brick[, c(1:5, ncol(combined_brick), 6:(ncol(combined_brick) - 1))]

#it seems we have a duplicae SubjectID column, remove this
combined_brick$SubjectID.1 <- NULL


# Write the updated combined data to a CSV file
write.csv(combined_brick, "Z:/Aida_experiment/combined_BRICK_marjolein.csv", row.names = FALSE)




