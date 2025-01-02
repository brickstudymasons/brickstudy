#Since the last time I created tables for the ASH poster, I noticed some values were missing. We added these values and then exported again. Most code is similar to 1162024_Tablespaper1

## in this script, I will try to clean up the dataexport of castor on november 11th. At this thime, score repeated data, volbrain data and freesurfer data have not been uploaded yet
#weirdly enough, the age_T0_MRI_months is exported incorrectly by castor. I decided to limit my next export to just the baseline_MRI form at T0 and to merge it later
library(dplyr)
library(writexl) #to write the tables to excel files
library(tableone)#for creating summary tables
#read in the raw data file. For now in my personal folder, will get moved around when we arrive at the final datastructure
raw <- read.csv("Z:/Aida_experiment/25112024_BRICK_csv_export/BRICK_export_20241125.csv", sep= ";")
ages <-read.csv("Z:/Aida_experiment/combined_BRICK_marjolein_with_genotype.csv", sep=",") #this file contains the ages, genotype, QC and recon-all data, as I apparently cannot export calculated fields from castor
volbrain <- read.csv("Z:/castor_proof_files/csv_castor/current/volbrains_castor.csv") #contains volbrain output
rr <- read.csv("Z:/Aida_experiment/27112024_castor_export_radiology/BRICK_export_20241127.csv", sep= ";")

#rename first columns in order to merge later.
raw <- raw %>%
  rename(Participant_Id = `ï..Participant.Id`)

rr <- rr %>%
  rename(Participant_Id = `ï..Participant.Id`)

volbrain <- volbrain %>% 
  rename(Participant_Id = Participant.Id)

#I decided not to clean it up. Instead. Just start with creating the tables.
#here table 1 is a combination of demographics and lab values
table1 <- raw %>% select(Participant_Id, Hydrea_at_scan_T0, brick_genotype, mothersbirth, fathersbirth, alpha_thal_status, ERY0, HB0, MCV0, HT0, reticulocyte_count_percentage_1, LEU0, TROMBO0, FE0, FERT0, TRAF0, TSAT0, ALAT0, LDH0, TBIL0, DBIL0, KREA0, SCHWARTZ_Bedsite0, FOLZ0, UREU0, NA0, K00, VITD0, ASAT0, AFOS0, GGT0, CRP0, KREA_U0, TE_U0, TE_U_KR0, ALB_U0, ALB_U_KR0, B120, HPLC_HBF_T0, HPLC_HBF_date_T0, HPLC_HbS_T0, HPLC_HbS_date_T0)

#import age in years (months/12) and gender from the ages df
table1 <- table1 %>%
  left_join(select(ages, Participant_Id, Age_at_scan_y_T0X, gender_BRICK), by = "Participant_Id")


#create a real Table 1 for paper. Sequence: Age at MRI, Sex, SCD genotype, Heoglobin mmol/l mean(SD) Hemoglobin X fraction, %, median (IQR)

# Specify the categorical and continuous variables
continuous_vars <- c("Age_at_scan_y_T0X")
categorical_vars <- c("gender_BRICK", "brick_genotype", "alpha_thal_status", "Hydrea_at_scan_T0")# "HB0" #"HPLC_HbS_T0") these last variables cannot be nicely depicted in the table

# Specify the categorical and continuous variables for CreateTableOne
vars <- c(continuous_vars, categorical_vars)

# Create the table using CreateTableOne
table1_summary <- CreateTableOne(vars = vars, data = table1, factorVars = categorical_vars)

# Print the table1 summary
print(table1_summary)

#I want the median and IQR for HbS
# Manually calculate median and IQR for 'HPLC_HbS_T0' 
hplc_summary <- table1 %>%
  summarise(
    Median_HPLC_HbS_T0 = median(HPLC_HbS_T0, na.rm = TRUE),
    IQR_HPLC_HbS_T0 = IQR(HPLC_HbS_T0, na.rm = TRUE)
  )

# Manually calculate mean and SD for 'HB0' 
hb0_summary <- table1 %>%
  summarise(
    Mean_HB0 = mean(HB0, na.rm = TRUE),
    SD_HB0 = sd(HB0, na.rm = TRUE)
  )



# Print the custom summaries for HPLC_HbS_T0 and HB0
print("HPLC_HbS_T0 - Median and IQR:")
print(hplc_summary)

print("HB0 - Mean and SD:")
print(hb0_summary)

#missing data summary
# Check for missing values per variable
missing_summary <- sapply(table1[vars], function(x) sum(is.na(x)))
present_summary <- sapply(table1[vars], function(x) sum(!is.na(x)))


# Print the missing data summary
cat("\nMissing Data Summary:\n")
print(missing_summary)

cat("\nPresent Data Summary:\n")
print(present_summary)

# here create the radiology qualitative report summary. This is including the bad quality scans!
table2 <- rr %>% select(Participant_Id, WMH_observed_T0, Vascular_malformations_T0, Microbleeds_present_T0) 

#create overview with averages
categorical_vars2 <- c("WMH_observed_T0", "Vascular_malformations_T0", "Microbleeds_present_T0")
table2_summary <- CreateTableOne(vars = categorical_vars2, data = table2, factorVars = categorical_vars2)
print(table2_summary)