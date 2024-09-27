## Experiment with Volbrain data. At this point, we do not have analysed all of the T0 scans

library(dplyr)
library(tidyr)
voldf <- read.csv("Z:/Aida_experiment/volbrainsnew.csv")

# Define participants to exclude
excluded_participants <- c("BRICK_003", "BRICK_009", "BRICK_024", "BRICK_025", "BRICK_040")

#Turn Paricipant.Id into Participant.Id
voldf <- voldf %>%
  rename( Participant.Id = Paricipant.Id)


# Filter voldf based on your criteria
voldf_clean <- voldf %>%
  filter(Quality.control.T1 != "C",      # Exclude rows where Quality.control.T1 is "C"
         Quality.control.FLAIR != "C",   # Exclude rows where Quality.control.FLAIR is "C"
         !(Participant.Id %in% excluded_participants))  # Exclude specific participants

# View the cleaned DataFrame
head(voldf_clean)                         


#We would like to know where the lesion burden is highest in the patients
# Calculate average lesion count and volume for each region using voldf_clean
lesion_avg_summary <- data.frame(
  Region = c("Periventricular", "Deep white", "Juxtacortical", "Infratentorial", "Cerebellar", "Medular"),
  
  Avg_Lesion_Count = c(
    mean(voldf_clean$Periventricular.lesion.count, na.rm = TRUE),
    mean(voldf_clean$Deep.white.lesion.count, na.rm = TRUE),
    mean(voldf_clean$Juxtacortical.lesion.count, na.rm = TRUE),
    mean(voldf_clean$Infratentorial.lesion.count, na.rm = TRUE),
    mean(voldf_clean$Cerebellar.lesion.count, na.rm = TRUE),
    mean(voldf_clean$Medular.lesion.count, na.rm = TRUE)
  ),
  
  Avg_Lesion_Volume_Absolute = c(
    mean(voldf_clean$Periventricular.lesion.volume..absolute..cm3, na.rm = TRUE),
    mean(voldf_clean$Deep.white.lesion.volume..absolute..cm3, na.rm = TRUE),
    mean(voldf_clean$Juxtacortical.lesion.volume..absolute..cm3, na.rm = TRUE),
    mean(voldf_clean$Infratentorial.lesion.volume..absolute..cm3, na.rm = TRUE),
    mean(voldf_clean$Cerebellar.lesion.volume..absolute..cm3, na.rm = TRUE),
    mean(voldf_clean$Medular.lesion.volume..absolute..cm3, na.rm = TRUE)
  ),
  
  Avg_Lesion_Volume_Normalized = c(
    mean(voldf_clean$Periventricular.lesion.volume..normalized..., na.rm = TRUE),
    mean(voldf_clean$Deep.white.lesion.volume..normalized..., na.rm = TRUE),
    mean(voldf_clean$Juxtacortical.lesion.volume..normalized..., na.rm = TRUE),
    mean(voldf_clean$Infratentorial.lesion.volume..normalized..., na.rm = TRUE),
    mean(voldf_clean$Cerebellar.lesion.volume..normalized..., na.rm = TRUE),
    mean(voldf_clean$Medular.lesion.volume..normalized..., na.rm = TRUE)
  )
)

# Sort by average lesion count and/or average absolute lesion volume
lesion_avg_summary_sorted <- lesion_avg_summary[order(-lesion_avg_summary$Avg_Lesion_Count, -lesion_avg_summary$Avg_Lesion_Volume_Absolute), ]

# Print the sorted summary
print(lesion_avg_summary_sorted)


