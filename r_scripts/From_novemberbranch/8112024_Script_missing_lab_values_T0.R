### this script is meant for missing lab identification, so that we can check in castor,First run the script 1172024_Table2_Growthcurves_script_attempt.R

library(dplyr)
library(tidyr)
library(writexl)

# Identify missing values for each Participant_Id, excluding `reticulocyte_count_percentage_1`
missing_values <- table2_filtered %>%
  pivot_longer(cols = -Participant_Id, names_to = "Variable", values_to = "Value") %>% # Transform to long format
  filter(is.na(Value) & Variable != "reticulocyte_count_percentage_1") %>%             # Filter for missing values, excluding reticulocyte_count_percentage_1
  select(Participant_Id, Variable)                                                     # Select only relevant columns

# Write the result to an Excel file
write_xlsx(missing_values, path = "Z:/Aida_experiment/Growthcurves_paper/Uittezoeken/missing_values_per_participant.xlsx")


# Display the result
print(missing_values)
