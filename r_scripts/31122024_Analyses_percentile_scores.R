# this script is for the analyses in the growthcurve paper. With the percentile scores, the participants are already adjusted for age and sex. The growth curves have combined participants
#from all ethnicities.
library(dplyr)
#the percentile score files are rds files
#read in table with genotypes, we will use this column later
marjolein_fs_table <- read.csv("Z:/Aida_experiment/Growthcurves_paper/marjolein_fs_table_qc_genotype.csv")

# Define the file paths
file_paths <- list(
  TDGMV_girls = "Z:/Aida_experiment/Growthcurves_paper/Percentiel_scores_Marjolein/TDGMV_percentiles_girls_SCD.rds",
  TCV_boys = "Z:/Aida_experiment/Growthcurves_paper/Percentiel_scores_Marjolein/TCV_percentiles_boys_SCD.rds",
  TCV_girls = "Z:/Aida_experiment/Growthcurves_paper/Percentiel_scores_Marjolein/TCV_percentiles_girls_SCD.rds",
  TDGMV_boys = "Z:/Aida_experiment/Growthcurves_paper/Percentiel_scores_Marjolein/TDGMV_percentiles_boys_SCD.rds",
  TWMV_girls = "Z:/Aida_experiment/Growthcurves_paper/Percentiel_scores_Marjolein/TWMV_percentiles_girls_SCD.rds",
  TWMV_boys = "Z:/Aida_experiment/Growthcurves_paper/Percentiel_scores_Marjolein/TWMV_percentiles_boys_SCD.rds"
)

# Load the files and assign them to variables
for (name in names(file_paths)) {
  assign(name, readRDS(file_paths[[name]]))
}

#After this, I identified how many zeroes are in the percentile scores (all of the children that are on the average line (50th percentile)). See below
#the percentile scores are characters, so I have to convert them to numeric first. Always run this part of the script below, before going to descriptive part.
#answer: TCV_boys has 3 zeroes and TWMV_boys 1  The rest of the datasets don't have zeroes


#now perform a descriptive overview of the percentiles. Data of interest:
#mean(SD), median (IQR), min-max, %below the 10th percentile, N

# List of datasets
datasets <- list(TDGMV_girls = TDGMV_girls, 
                 TDGMV_boys = TDGMV_boys, 
                 TCV_girls = TCV_girls, 
                 TCV_boys = TCV_boys, 
                 TWMV_girls = TWMV_girls, 
                 TWMV_boys = TWMV_boys)

generate_descriptive_stats <- function(dataset, percentile_col) {
  data <- dataset[[percentile_col]]
  data <- as.numeric(data)  # Ensure it's numeric
  valid_data <- data[!is.na(data)]  # Remove NAs
  
  mean_val <- round(mean(valid_data), 2)
  sd_val <- round(sd(valid_data), 2)
  median_val <- round(median(valid_data), 2)
  q25 <- round(quantile(valid_data, 0.25), 2)
  q75 <- round(quantile(valid_data, 0.75), 2)
  min_val <- round(min(valid_data), 2)
  max_val <- round(max(valid_data), 2)
  percent_below_10 <- round(mean(valid_data < 0.1) * 100, 1)
  percent_10_to_90 <- round(mean(valid_data >= 0.1 & valid_data <= 0.9) * 100, 1)
  n_val <- length(valid_data)
  
  list(
    Mean_SD = paste0(mean_val, " (", sd_val, ")"),
    Median_IQR = paste0(median_val, " (", q25, "-", q75, ")"),
    Min_Max = paste0(min_val, "-", max_val),
    Percent_Below_10 = paste0(percent_below_10, "%"),
    Percent_10_to_90 = paste0(percent_10_to_90, "%"),
    N = n_val
  )
}


#generate the relevant descriptive data for the other percentile data
results <- list(
  TDGMV_girls = generate_descriptive_stats(TDGMV_girls, "TDGMV_percentile"),
  TDGMV_boys = generate_descriptive_stats(TDGMV_boys, "TDGMV_percentile"),
  TCV_girls = generate_descriptive_stats(TCV_girls, "TCV_percentile"),
  TCV_boys = generate_descriptive_stats(TCV_boys, "TCV_percentile"),
  TWMV_girls = generate_descriptive_stats(TWMV_girls, "TWMV_percentile"),
  TWMV_boys = generate_descriptive_stats(TWMV_boys, "TWMV_percentile")
)

# Print the results
results

#mean and SD for the absolute volumes for in the decriptives table
# Generate descriptive statistics for TCV_girls
tcv_girls_stats <- generate_descriptive_stats(TCV_girls, "TCV")
print(tcv_girls_stats)

# Generate descriptive statistics for TCV_boys
tcv_boys_stats <- generate_descriptive_stats(TCV_boys, "TCV")
print(tcv_boys_stats)

# Generate descriptive statistics for TDGMV_girls
tdgmv_girls_stats <- generate_descriptive_stats(TDGMV_girls, "TDGMV")
print(tdgmv_girls_stats)

# Generate descriptive statistics for TDGMV_boys
tdgmv_boys_stats <- generate_descriptive_stats(TDGMV_boys, "TDGMV")
print(tdgmv_boys_stats)

# Generate descriptive statistics for TWMV_girls
twmv_girls_stats <- generate_descriptive_stats(TWMV_girls, "TWMV")
print(twmv_girls_stats)

# Generate descriptive statistics for TWMV_boys
twmv_boys_stats <- generate_descriptive_stats(TWMV_boys, "TWMV")
print(twmv_boys_stats)

#create a descriptive table for clarity
results_df <- do.call(rbind, results)
results_df <- as.data.frame(results_df)
results_df$Data_Frame <- rownames(results_df)  # Add a column with data frame names

# Print the results in a table
print(results_df, row.names = FALSE)

##then perform linear regression analysis with Hb, Ht, HbF and the volbrain outputs
#hb, ht normal distribution
#Total.lesion.count and Total.lesion.volume..absolute..cm3 not normal distribution
# check hbf distribution and volbrain outputs

Lab_percentiles <- table2 %>%
  select(Participant_Id, ERY0, HB0, MCV0, HT0, reticulocyte_count_percentage_1, LEU0, 
         TROMBO0, FE0, FERT0, TRAF0, TSAT0, ALAT0, LDH0, TBIL0, DBIL0, KREA0, 
         FOLZ0, UREU0, NA0, K00, VITD0, ASAT0, AFOS0, GGT0, CRP0, KREA_U0, 
         TE_U0, TE_U_KR0, ALB_U0, ALB_U_KR0, B120, HPLC_HBF_T0, HPLC_HBF_date_T0, HPLC_HbS_T0, HPLC_HbS_date_T0)#from 1162024Tables_paper_1.R


# Combine the girls' dataframes
girls_combined <- TDGMV_girls %>%
  full_join(TWMV_girls, by = "Participant_Id") %>%
  full_join(TCV_girls, by = "Participant_Id")

# Combine the boys' dataframes
boys_combined <- TDGMV_boys %>%
  full_join(TWMV_boys, by = "Participant_Id") %>%
  full_join(TCV_boys, by = "Participant_Id")

# Combine all relevant volumetric participant data (girls and boys)
volumes_combined <- bind_rows(girls_combined, boys_combined)

#remove AgeChild.y and AgeChild.x since they are remnants of the merge
volumes_combined <- volumes_combined[, !names(volumes_combined) %in% c("AgeChild.y", "AgeChild.x")]

#now merge the lab value table with volumnes_combined
Percentile_analysis <- merge(volumes_combined, Lab_percentiles, 
                             by = "Participant_Id", 
                             all.x = TRUE)
#merge this df with the volbrain df from 8112024_Table3_volbrain_stats
Percentile_analysis <- merge(Percentile_analysis, table4_volbrain_df, 
                             by = "Participant_Id", 
                             all.x = TRUE)

# Merge Percentile_analysis with marjolein_fs_table, keeping only the severe_genotype
Percentile_analysis <- merge(Percentile_analysis, marjolein_fs_table[, c("Participant_Id", "severe_genotype")], 
                             by = "Participant_Id", 
                             all.x = TRUE)


# Merge lab values with combined volumes dataframe
final_data <- volumes_combined %>%
  inner_join(Lab_percentiles, by = "Participant_Id")

# Ensure Participant_Id is the first column
final_data <- final_data %>%
  select(Participant_Id, everything())

# View the final dataframe
head(final_data)


###########################
#how many zeroes in datasets

# Function to process a single dataset
count_zeroes_in_percentiles <- function(dataset) {
  # Find percentile columns
  percentile_cols <- grep("percentile", names(dataset), value = TRUE, ignore.case = TRUE)
  
  # Initialize a result list
  zero_counts <- list()
  
  # Loop over percentile columns
  for (col in percentile_cols) {
    # Convert column to numeric
    dataset[[col]] <- as.numeric(dataset[[col]])
    
    # Count zeroes
    zero_counts[[col]] <- sum(dataset[[col]] == 0, na.rm = TRUE)
  }
  
  return(zero_counts)
}

# Apply the function to all datasets
all_zero_counts <- lapply(datasets, count_zeroes_in_percentiles)

# Print results
all_zero_counts
