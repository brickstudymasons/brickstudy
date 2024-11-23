## in this script, I will try to clean up the dataexport of castor on november 11th. At this thime, score repeated data, volbrain data and freesurfer data have not been uploaded yet
#weirdly enough, the age_T0_MRI_months is exported incorrectly by castor. I decided to limit my next export to just the baseline_MRI form at T0 and to merge it later
library(dplyr)
library(writexl) #to write the tables to excel files
#read in the raw data file. For now in my personal folder, will get moved around when we arrive at the final datastructure
raw <- read.csv("Z:/Aida_experiment/6112024_brick_castor_data/BRICK_export_20241106.csv", sep= ";")
ages <-read.csv("Z:/Aida_experiment/combined_BRICK_marjolein.csv", sep=",") #this file contains the ages and recon-all data, as I apparently cannot export calculated fields from castor
volbrain <- read.csv("Z:/castor_proof_files/csv_castor/current/volbrains_castor.csv") #contains volbrain output

#rename first columns in order to merge later.
raw <- raw %>%
  rename(Participant_Id = `ï..Participant.Id`)

ages <- ages %>% 
  rename(Participant_Id = Participant.Id)

volbrain <- volbrain %>% 
  rename(Participant_Id = Participant.Id)

#I decided not to clean it up. Instead. Just start with creating the tables.

table1 <- raw %>% select(Participant_Id, Hydrea_at_scan_T0, brick_genotype, mothersbirth, fathersbirth)

#import age in months from the ages df
table1 <- table1 %>%
  left_join(select(ages, Participant_Id, Age_at_scan_m_T0X, gender_BRICK), by = "Participant_Id")

#add a column in years. now we have the ingredients for table1
table1 <- table1 %>%
  mutate(Age_at_scan_years = round(Age_at_scan_m_T0X / 12, 1))

#Table 2: Lab values including HbF

table2 <- raw %>% select(Participant_Id, ERY0, HB0, MCV0, HT0, reticulocyte_count_percentage_1, LEU0, TROMBO0, FE0, FERT0, TRAF0, TSAT0, ALAT0, LDH0, TBIL0, DBIL0, KREA0, SCHWARTZ_Bedsite0, FOLZ0, UREU0, NA0, K00, VITD0, ASAT0, AFOS0, GGT0, CRP0, KREA_U0, TE_U0, TE_U_KR0, ALB_U0, ALB_U_KR0, B120, HPLC_HBF_T0, HPLC_HBF_date_T0, HPLC_HbS_T0, HPLC_HbS_date_T0)
                      
#Table 3: Descriptives on radiology reports
table3 <- raw %>% select(Participant_Id,Measurement_moment_QC_T1w_T0, Score_QC_T1w_T0, Exclude_Score_QC_T1w_T0, Remarks_Score_QC_T1w_T0, Screened_for_WMH_T0, WMH_observed_T0, Vasculature_examined_T0, Vascular_malformations_T0, Microbleeds_screened_T0, Microbleeds_present_T0, Incidental_finding_T0, Marjolein_T0, Remarks_MRI_T0)

#Table 4: White matter hyperintensities
table4 <- volbrain %>%
  select(
    Participant_Id, dl_Sex_T0, dl_Age_T0,
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
#Table 5: Recon-all volumetrics (white, grey and subcortical matter) with z-scores for 2 different kinds of growth charts.
# Calculate the Total Cortical Volume and Total Cerebellar Volume
table5 <- ages %>%
  mutate(
    Total_Cortical_Volume = CortexVol + Left.Cerebellum.Cortex + Right.Cerebellum.Cortex,
    Total_Cerebellar_Volume = Left.Cerebellum.Cortex + Right.Cerebellum.Cortex
  ) %>%
  
  # Select relevant columns for the table and rename for clarity
  select(
    `Participant ID` = Participant_Id,
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
#Table 5_1: Neuropsychologic outcomes(WISCV&WAISIV) + Education level parents
#WiscV
table6_wisc <- raw %>%
  select(
    Participant_Id,
    scorePrimIndex_TIQ_S_1,    # Full Scale IQ
    scorePrimIndex_VBI_IQ_1, # Verbal Comprehension Index
    scorePrimIndex_VRI_IQ_1, # Visual Spatial Index
    scorePrimIndex_FRI_IQ_1, # Fluid Reasoning Index
    scorePrimIndex_WgI_IQ_1, # Working Memory Index
    scorePrimIndex_VsI_IQ_1, # Processing Speed Index
    scoreSecIndex_KRI_IQ_1,      # Quantitative Reasoning Index
    scoreSecIndex_AWI_IQ_1,     # Auditory Working Memory Index
    scoreSecIndex_NVI_IQ_1,      # Nonverbal Index
    scoreSecIndex_AVI_IQ_1,      # General Ability Index
   )

#waisIV

table6_wais <- raw %>%
  select(
    "Participant_Id",
    "ScoreTIQ_1",             # Full Scale IQ (FSIQ)
    "ScoreSomVBI_1",          # Verbal Comprehension Index (VCI)
    "ScorePerVBI_1",          # Perceptual Verbal Comprehension Index (related to FRI)
    "ScoreBIVBI_1",           # Blocked Verbal Comprehension Index (related to FRI)
    "ScoreWgI_1",             # Working Memory Index (WMI)
    "ScoreVsI_1"              # Processing Speed Index (PSI)
  )

#create a real table1
library(tableone)

# Specify the categorical and continuous variables
categorical_vars <- c("Hydrea_at_scan_T0", "brick_genotype", "gender_BRICK")
continuous_vars <- c("Age_at_scan_years")

# Specify the categorical and continuous variables for CreateTableOne
vars <- c(categorical_vars, continuous_vars)

# Create the table using CreateTableOne
table1_summary <- CreateTableOne(vars = vars, data = combined_data, factorVars = categorical_vars)

# Print the table1 summary
print(table1_summary)

#I want the median and IQR for HbS
# Manually calculate median and IQR for 'HPLC_HbS_T0' 
hplc_summary <- combined_data %>%
  summarise(
    Median_HPLC_HbS_T0 = median(HPLC_HbS_T0, na.rm = TRUE),
    IQR_HPLC_HbS_T0 = IQR(HPLC_HbS_T0, na.rm = TRUE)
  )

# Manually calculate mean and SD for 'HB0' 
hb0_summary <- combined_data %>%
  summarise(
    Mean_HB0 = mean(HB0, na.rm = TRUE),
    SD_HB0 = sd(HB0, na.rm = TRUE)
  )

# Print the custom summaries for HPLC_HbS_T0 and HB0
print("HPLC_HbS_T0 - Median and IQR:")
print(hplc_summary)

print("HB0 - Mean and SD:")
print(hb0_summary)


