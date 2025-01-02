#this script is a continuation of 31122024_Analyses_percentile_scores.R We have created Percentile_analysis, the datafram with lab values and percentiles and brain volumes.
#now we perform the analyses
#the volbrain lesion data is not normally distributed as are the percentile brain volume scores

#make the percentiles numeric and not characters
# Convert TWMV_percentile to numeric
Percentile_analysis$TWMV_percentile <- as.numeric(Percentile_analysis$TWMV_percentile)

# Convert TCV_percentile to numeric
Percentile_analysis$TCV_percentile <- as.numeric(Percentile_analysis$TCV_percentile)

# Convert TDGMV_percentile to numeric
Percentile_analysis$TDGMV_percentile <- as.numeric(Percentile_analysis$TDGMV_percentile)

#analyses between hemoglobin and brain volumes
#univariate regression analysis. these all do not seem significant
# Univariate linear regression: HB0 vs TGMV_percentile
model_TGMV <- lm(TDGMV_percentile ~ HB0, data = Percentile_analysis)
summary(model_TGMV)

# Univariate linear regression: HB0 vs TCV_percentile
model_TCV <- lm(TCV_percentile ~ HB0, data = Percentile_analysis)
summary(model_TCV)

# Univariate linear regression: HB0 vs TWMV_percentile
model_TWMV <- lm(TWMV_percentile ~ HB0, data = Percentile_analysis)
summary(model_TWMV)

#regression analyses between hematocrit and brain volumes
# Univariate linear regression: HT0 vs TDGMV_percentile
model_TGMV_HT <- lm(TDGMV_percentile ~ HT0, data = Percentile_analysis)
summary(model_TGMV_HT)

# Univariate linear regression: HT0 vs TCV_percentile
model_TCV_HT <- lm(TCV_percentile ~ HT0, data = Percentile_analysis)
summary(model_TCV_HT)

# Univariate linear regression: HT0 vs TWMV_percentile
model_TWMV_HT <- lm(TWMV_percentile ~ HT0, data = Percentile_analysis)
summary(model_TWMV_HT)

# Univariate linear regression: HPLC_HBF_T0 vs TDGMV_percentile
model_TGMV_HBF <- lm(TDGMV_percentile ~ HPLC_HBF_T0, data = Percentile_analysis)
summary(model_TGMV_HBF)

# Univariate linear regression: HPLC_HBF_T0 vs TCV_percentile
model_TCV_HBF <- lm(TCV_percentile ~ HPLC_HBF_T0, data = Percentile_analysis)
summary(model_TCV_HBF)

# Univariate linear regression: HPLC_HBF_T0 vs TWMV_percentile
model_TWMV_HBF <- lm(TWMV_percentile ~ HPLC_HBF_T0, data = Percentile_analysis)
summary(model_TWMV_HBF)

#look at HbS and percentiles
# Univariate linear regression: HPLC_HBS_T0 vs TDGMV_percentile
model_TGMV_HBS <- lm(TDGMV_percentile ~ HPLC_HbS_T0, data = Percentile_analysis)
summary(model_TGMV_HBS)

# Univariate linear regression: HPLC_HBS_T0 vs TCV_percentile
model_TCV_HBS <- lm(TCV_percentile ~ HPLC_HbS_T0, data = Percentile_analysis)
summary(model_TCV_HBS)

# Univariate linear regression: HPLC_HBS_T0 vs TWMV_percentile
model_TWMV_HBS <- lm(TWMV_percentile ~ HPLC_HbS_T0, data = Percentile_analysis)
summary(model_TWMV_HBS)


#seems like the HbF has an associastion with the volumes
#now let's have a look at the lesion count and total lesion volume and the percentiles
# Univariate linear regression: dl_Total_lesion_count_T0 vs TDGMV_percentile
model_TDGMV_dlesion_count <- lm(TDGMV_percentile ~ dl_Total_lesion_count_T0, data = Percentile_analysis)
summary(model_TDGMV_dlesion_count)

# Univariate linear regression: dl_Total_lesion_count_T0 vs TCV_percentile
model_TCV_dlesion_count <- lm(TCV_percentile ~ dl_Total_lesion_count_T0, data = Percentile_analysis)
summary(model_TCV_dlesion_count)

# Univariate linear regression: dl_Total_lesion_count_T0 vs TWMV_percentile
model_TWMV_dlesion_count <- lm(TWMV_percentile ~ dl_Total_lesion_count_T0, data = Percentile_analysis)
summary(model_TWMV_dlesion_count)

# Univariate linear regression: dl_Total_lesion_volume.absolute.cm3_T0 vs TDGMV_percentile
model_TDGMV_dlesion_volume <- lm(TDGMV_percentile ~ dl_Total_lesion_volume_.absolute._cm3_T0, data = Percentile_analysis)
summary(model_TDGMV_dlesion_volume)

# Univariate linear regression: dl_Total_lesion_volume.absolute.cm3_T0 vs TCV_percentile
model_TCV_dlesion_volume <- lm(TCV_percentile ~ dl_Total_lesion_volume_.absolute._cm3_T0, data = Percentile_analysis)
summary(model_TCV_dlesion_volume)

# Univariate linear regression: dl_Total_lesion_volume.absolute.cm3_T0 vs TWMV_percentile
model_TWMV_dlesion_volume <- lm(TWMV_percentile ~ dl_Total_lesion_volume_.absolute._cm3_T0, data = Percentile_analysis)
summary(model_TWMV_dlesion_volume)

#hypothesis: Group 0 has a higher chance of lying within a typical range than group 1 (HbSS group). Unpaired T-test
# Function to perform unpaired t-test comparing means by severe_genotype
t_test_by_severe_genotype <- function(df, volume_col) {
  t_test <- t.test(df[[volume_col]] ~ df$severe_genotype, na.rm = TRUE)
  return(t_test)
}

# Perform unpaired t-tests for TCV, TDGMV, TWMV by severe_genotype
t_test_tcvg <- t_test_by_severe_genotype(Percentile_analysis, "TCV_percentile")
t_test_tdgmvg <- t_test_by_severe_genotype(Percentile_analysis, "TDGMV_percentile")
t_test_twmvg <- t_test_by_severe_genotype(Percentile_analysis, "TWMV_percentile")

# Print the t-test results
print("Unpaired T-test for TCV by severe_genotype:")
print(t_test_tcvg)

print("Unpaired T-test for TDGMV by severe_genotype:")
print(t_test_tdgmvg)

print("Unpaired T-test for TWMV by severe_genotype:")
print(t_test_twmvg)

#other hypothesis: Group 0 is more likely to fall within the typical range (01-0.9) than group 1 (HbSS)
# Function to check proportion within 0.1 - 0.9 percentile range
prop_0_9_percentile <- function(df, volume_col) {
  mean(df[[volume_col]] >= 0.1 & df[[volume_col]] <= 0.9, na.rm = TRUE)
}

# Proportions within 0.1 - 0.9 percentiles for TCV, TDGMV, TWMV
prop_tcvg_0_9 <- prop_0_9_percentile(Percentile_analysis, "TCV_percentile")
prop_tdgmvg_0_9 <- prop_0_9_percentile(Percentile_analysis, "TDGMV_percentile")
prop_twmvg_0_9 <- prop_0_9_percentile(Percentile_analysis, "TWMV_percentile")

# Create a summary of the proportions
prop_summary <- data.frame(
  Structure = c("TCV", "TDGMV", "TWMV"),
  Proportion_0_9_Percentile = c(prop_tcvg_0_9, prop_tdgmvg_0_9, prop_twmvg_0_9)
)

# Print the proportion summary
print("Proportion within 0.1 to 0.9 percentiles by severe_genotype:")
print(prop_summary)

# Chi-square test for association between severe_genotype and being within 0.1 - 0.9 percentiles
# Creating binary categories for the 0.1-0.9 range
Percentile_analysis$within_0_9 <- as.numeric(Percentile_analysis$TCV_percentile >= 0.1 & Percentile_analysis$TCV_percentile <= 0.9)

chisq_tcvg <- chisq.test(Percentile_analysis$within_0_9, Percentile_analysis$severe_genotype)
print("Chi-square test for TCV:")
print(chisq_tcvg)

chisq_tdgmvg <- chisq.test(Percentile_analysis$within_0_9, Percentile_analysis$severe_genotype)
print("Chi-square test for TDGMV:")
print(chisq_tdgmvg)

chisq_twmvg <- chisq.test(Percentile_analysis$within_0_9, Percentile_analysis$severe_genotype)
print("Chi-square test for TWMV:")
print(chisq_twmvg)

#data is probably way to imbalanced. 75% of TCV, as well as 75% of TGMV and 69 of TWMV lies within normal ranges. I don't expect to find an effect here.

