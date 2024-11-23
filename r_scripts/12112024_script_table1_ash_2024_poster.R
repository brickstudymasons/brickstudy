# in this script, the definite table 1 was made for the ash 2024 poster. Hb has 2 missing values so this shoul dbe adressed separately.
library(dplyr)
library(tableone)

# Read male and female brick data
male_brick <- read.csv("Z:/Aida_experiment/ASH_poster_2024/12112024_TCV_BRICK_BRIDGE_gen_boys.csv")
female_brick <- read.csv("Z:/Aida_experiment/ASH_poster_2024/12112024_TCV_BRICK_BRIDGE_gen_girls.csv")


# Extract the relevant columns from table1, table2_filtered, and raw for males (with NA included)
table1_filtered_male_withna <- table1 %>%
  select(Participant_Id, Hydrea_at_scan_T0)

table2_filtered_male_withna <- table2_filtered %>%
  select(Participant_Id, HB0)

raw_filtered_male_withna <- raw %>%
  select(Participant_Id, HPLC_HbS_T0)

# Merge male data with additional columns (keeping NAs)
male_data_merged_withna <- male_brick %>%
  inner_join(table1_filtered_male_withna, by = "Participant_Id") %>%
  inner_join(table2_filtered_male_withna, by = "Participant_Id") %>%
  inner_join(raw_filtered_male_withna, by = "Participant_Id")

# Repeat the process for females (with NA included)
table1_filtered_female_withna <- table1 %>%
  select(Participant_Id, Hydrea_at_scan_T0)

table2_filtered_female_withna <- table2_filtered %>%
  select(Participant_Id, HB0)

raw_filtered_female_withna <- raw %>%
  select(Participant_Id, HPLC_HbS_T0)

# Merge female data with additional columns (keeping NAs)
female_data_merged_withna <- female_brick %>%
  inner_join(table1_filtered_female_withna, by = "Participant_Id") %>%
  inner_join(table2_filtered_female_withna, by = "Participant_Id") %>%
  inner_join(raw_filtered_female_withna, by = "Participant_Id")

# Combine male and female data into one dataset
combined_data_withna <- bind_rows(male_data_merged_withna, female_data_merged_withna)

# Check for missing values in each column and count the number of observations
missing_values <- combined_data_withna %>%
  summarise(across(everything(), 
                   list(Missing = ~sum(is.na(.)), 
                        Observed = ~sum(!is.na(.)))))

# Print missing values and observed counts for each variable
print("Missing and Observed Values for Each Variable:")
print(missing_values)

# Only in Hb0 2 values are missing! Keep the 18 for the rest of table1. We keep the table1 script from 

# Define categorical and continuous variables (excluding HB0 from Table 1)
categorical_vars_withna <- c("Hydrea_at_scan_T0", "genotype", "gender_brick")
continuous_vars_withna <- c("AgeChild", "HPLC_HbS_T0")  # Exclude HB0 from here

# Create Table 1 summary without HB0
table1_summary_wna <- CreateTableOne(
  vars = c("Hydrea_at_scan_T0", "genotype", "gender_brick", 
           "AgeChild", "HPLC_HbS_T0"),  # Include all variables except HB0
  data = combined_data_withna, 
  factorVars = categorical_vars_withna  # Specify categorical variables
)

# Print the Table 1 summary
print("Table 1 Summary (Excluding HB0):")
print(table1_summary_wna)

# Create a custom summary for the continuous variables (mean and SD for AgeChild, median and IQR for HPLC_HbS_T0)
custom_summary_withna <- combined_data_withna %>%
  summarise(
    AgeChild_mean = mean(AgeChild, na.rm = TRUE),  # Mean of AgeChild
    AgeChild_sd = sd(AgeChild, na.rm = TRUE),      # SD of AgeChild
    HPLC_HbS_T0_median = median(HPLC_HbS_T0, na.rm = TRUE),  # Median of HPLC_HbS_T0
    HPLC_HbS_T0_IQR = IQR(HPLC_HbS_T0, na.rm = TRUE)  # IQR of HPLC_HbS_T0
  )

# Print the custom summary
print("Custom Summary (Mean, SD for AgeChild; Median, IQR for HPLC_HbS_T0):")
print(custom_summary_withna)

# Calculate the mean and SD of HB0, excluding NAs (missing values)
hb0_summary <- combined_data_withna %>%
  summarise(
    HB0_mean = mean(HB0, na.rm = TRUE),  # Mean excluding NAs
    HB0_sd = sd(HB0, na.rm = TRUE)  # SD excluding NAs
  )

# Print the summary for HB0
print("Summary of HB0 (Excluding Missing Data):")
print(hb0_summary)

# Add a footnote about missing HB0 values
footnote <- "Note: For the variable 'HB0', only data from 16/18 participants was included due to missing values."

# Print the footnote
print(footnote)
