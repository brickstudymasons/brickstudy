library(dplyr)
library(tableone)
library(writexl)
library(tibble)  # For rownames_to_column()

# Select relevant columns from table2
table2_filtered <- table2 %>%
  select(Participant_Id, ERY0, HB0, MCV0, HT0, reticulocyte_count_percentage_1, LEU0, 
         TROMBO0, FE0, FERT0, TRAF0, TSAT0, ALAT0, LDH0, TBIL0, DBIL0, KREA0, 
         FOLZ0, UREU0, NA0, K00, VITD0, ASAT0, AFOS0, GGT0, CRP0, KREA_U0, 
         TE_U0, TE_U_KR0, ALB_U0, ALB_U_KR0, B120)


# Define continuous variables
continuous_vars <- c("ERY0", "HB0", "MCV0", "HT0", "reticulocyte_count_percentage_1", 
                     "LEU0", "TROMBO0", "FE0", "FERT0", "TRAF0", "TSAT0", "ALAT0", 
                     "LDH0", "TBIL0", "DBIL0", "KREA0", "FOLZ0", "UREU0", "NA0", 
                     "K00", "VITD0", "ASAT0", "AFOS0", "GGT0", "CRP0", "KREA_U0", 
                     "TE_U0", "TE_U_KR0", "ALB_U0", "ALB_U_KR0", "B120")

# Create a named vector of labels for the continuous variables, with units
labels <- c(
  "ERY0" = "Red blood cell (RBC) count (x10^12/L)",
  "HB0" = "Hemoglobin (g/dL)",
  "MCV0" = "Mean corpuscular volume (MCV) (fL)",
  "HT0" = "Hematocrit (HCT) (%)",
  "reticulocyte_count_percentage_1" = "Reticulocyte count (%)",
  "LEU0" = "White blood cell (WBC) count (x10^9/L)",
  "TROMBO0" = "Platelet count (x10^9/L)",
  "FE0" = "Serum iron (µg/dL)",
  "FERT0" = "Ferritin serum (ng/mL)",
  "TRAF0" = "Transferrin (mg/dL)",
  "TSAT0" = "Transferrin saturation (%)",
  "ALAT0" = "Alanine transaminase (ALT) (U/L)",
  "LDH0" = "Lactate Dehydrogenase (LDH) (U/L)",
  "TBIL0" = "Total bilirubin (mg/dL)",
  "DBIL0" = "Conjugated/direct bilirubin (mg/dL)",
  "KREA0" = "Creatinine (mg/dL)",
  "FOLZ0" = "Folate (ng/mL)",
  "UREU0" = "Urea (mg/dL)",
  "NA0" = "Sodium (mmol/L)",
  "K00" = "Potassium (mmol/L)",
  "VITD0" = "Vitamin D (ng/mL)",
  "ASAT0" = "Aspartate transaminase (AST) (U/L)",
  "AFOS0" = "Alkaline phosphatase (ALP) (U/L)",
  "GGT0" = "Gamma-glutamyl transferase (GGT) (U/L)",
  "CRP0" = "C-reactive protein (CRP) (mg/L)",
  "KREA_U0" = "Creatinine (Urine) (mg/dL)",
  "TE_U0" = "Iron (Urine) (µg/dL)",
  "TE_U_KR0" = "Iron (Urine, Kr) (µg/dL)",
  "ALB_U0" = "Albumin (Urine) (g/dL)",
  "ALB_U_KR0" = "Albumin (Urine, Kr) (g/dL)",
  "B120" = "Bilirubin 120 (mg/dL)"
)

# Create a summary table with continuous variables
table2_summary <- CreateTableOne(
  vars = continuous_vars,
  data = table2_filtered,
  factorVars = character(0)  # No factor variables
)

# Convert the table summary to a data frame
table2_df <- as.data.frame(print(table2_summary, quote = FALSE, noSpaces = TRUE))

# Add the labels as a new column by matching with continuous_vars
table2_df <- table2_df %>%
  rownames_to_column(var = "Variable") %>%
  mutate(Variable = labels[continuous_vars])

# Rename the 'Overall' column to "Mean (SD)" to indicate the values
colnames(table2_df)[colnames(table2_df) == "Overall"] <- "Mean (SD)"


# View the final table
print(table2_df)
#question: weird results, how do we impute missing values?

