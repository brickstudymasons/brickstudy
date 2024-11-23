#this script is to find the gentotypes that apply to the bridge subset of brick for the ash poster 2024
library(dplyr)
library(readr)
library(tableone)

#load dataset with genotypes
genotype <-read.csv("Z:/Aida_experiment/combined_BRICK_marjolein_with_genotype.csv")

# Create a new column with rounded "Age_at_scan_y_T0X" values in the genotype DataFrame. This is needed for an exact match
genotype <- genotype %>%
  mutate(Age_at_scan_y_T0X = round(Age_at_scan_y_T0X, 2))

# Define ages for each gender
ages_male <- c(9.94, 11.74, 12.73, 12.81, 13.94, 15.09, 15.22, 16.02, 16.65, 17.4, 17.48)
ages_female <- c(8.05, 9.16, 10.32, 13.72, 13.77, 14.85, 16.25)

# Filter genotype DataFrame based on matching ages for males and females separately
matched_data_male <- genotype %>%
  filter(Age_at_scan_y_T0X %in% ages_male & gender_BRICK == 1) %>%
  select(Participant_Id, brick_genotype, Age_at_scan_y_T0X, gender_BRICK)

matched_data_female <- genotype %>%
  filter(Age_at_scan_y_T0X %in% ages_female & gender_BRICK == 2) %>%
  select(Participant_Id, brick_genotype, Age_at_scan_y_T0X, gender_BRICK)

# Assign to BRIDGE_male and BRIDGE_female DataFrames
BRIDGE_male <- matched_data_male
BRIDGE_female <- matched_data_female

# Display the resulting DataFrames
print("BRIDGE_male:")
print(BRIDGE_male)

print("BRIDGE_female:")
print(BRIDGE_female)

#not an exact match. let's just compare it manually

genotype_male <- genotype %>% filter(gender_BRICK == 1)

genotype_female <- genotype %>% filter(gender_BRICK == 2)

#now some relevant extra rows are the hydrea use row, Hb and HbF that are interesting for table 1
#load the bridge subset of participants, I manually added gender, brick number and genotype to the bridge subset. I've also ran th script of 1162024Tables_paper_1.R and 1172024_Table2_Growthcurves_script
#beforehand
male_brick <- read.csv("Z:/Aida_experiment/ASH_poster_2024/12112024_TCV_BRICK_BRIDGE_gen_boys.csv")
female_brick <- read.csv("Z:/Aida_experiment/ASH_poster_2024/12112024_TCV_BRICK_BRIDGE_gen_girls.csv")

#from df table1 I need "Hydrea_at_scan_T0" and from dataframe "table2_filtered" I need HB0. The NA values need to be kicked out. merge on Participant_Id into new df for males and females

# Extract the relevant columns from table1, table2_filtered, and raw for males
table1_filtered_male <- table1 %>%
  select(Participant_Id, Hydrea_at_scan_T0) %>%
  filter(!is.na(Hydrea_at_scan_T0))

table2_filtered_male <- table2_filtered %>%
  select(Participant_Id, HB0) %>%
  filter(!is.na(HB0))

raw_filtered_male <- raw %>%
  select(Participant_Id, HPLC_HbS_T0) %>%
  filter(!is.na(HPLC_HbS_T0))

# Merge male data with additional columns
male_data_merged <- male_brick %>%
  inner_join(table1_filtered_male, by = "Participant_Id") %>%
  inner_join(table2_filtered_male, by = "Participant_Id") %>%
  inner_join(raw_filtered_male, by = "Participant_Id")

# Repeat the process for females
table1_filtered_female <- table1 %>%
  select(Participant_Id, Hydrea_at_scan_T0) %>%
  filter(!is.na(Hydrea_at_scan_T0))

table2_filtered_female <- table2_filtered %>%
  select(Participant_Id, HB0) %>%
  filter(!is.na(HB0))

raw_filtered_female <- raw %>%
  select(Participant_Id, HPLC_HbS_T0) %>%
  filter(!is.na(HPLC_HbS_T0))

# Merge female data with additional columns
female_data_merged <- female_brick %>%
  inner_join(table1_filtered_female, by = "Participant_Id") %>%
  inner_join(table2_filtered_female, by = "Participant_Id") %>%
  inner_join(raw_filtered_female, by = "Participant_Id")

# Display the resulting data frames
print("Male Data Merged:")
print(male_data_merged)

print("Female Data Merged:")
print(female_data_merged)


#now make the dfs one and create a table 1
# Merge male and female brick datasets into one, keeping the 'gender' column intact
combined_data <- bind_rows(male_data_merged, female_data_merged)

# Define categorical and continuous variables
categorical_vars <- c("Hydrea_at_scan_T0", "genotype", "gender_brick")
continuous_vars <- c("AgeChild", "HB0", "HPLC_HbS_T0")

# Use the table1 package to create a summary table
table1_summary <-  CreateTableOne(~ Hydrea_at_scan_T0 + genotype + gender_brick + 
                           AgeChild + HB0 + HPLC_HbS_T0, 
                         data = combined_data, 
                         render.categorical = "Freq", 
                         render.continuous = c("Median", "IQR"))

# Print the table1 summary
print(table1_summary)




