#Let op: Je kan geen waarden uit Gemstracker exporteren, als er geen consent gegeven is (veld in Gemstracker)
#Laad de benodigde libraries
library(readxl)             # Load the package into your R session
library(writexl)
library(dplyr)
#Importeer excel file van export gemstracker WAISIV
# Replace "data.xlsx" with the actual file name and path if it's located in a different directory
WAISIV_gemstracker <- read_excel("C:/Users/asofk/OneDrive/BRICK-study/BRICK-study/Data/BRICK_Scoreformulier_WAIS-IV_NL_startstop_gemstracker.xlsx")

#show column names of the new df
print(colnames(WAISIV_gemstracker))

#verander de column names van gemstracker naar castor, voor Baseline.

# Change column names
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "gr2o_patient_nr"] <- "Participant Id"
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "DatumWAISIV"] <- "Datum_WAIS_IV"
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "StartWAISIV"] <- "Start_WAIS_IV"
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "StopWAISIV"] <- "Stop_WAIS_IV"
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "WAISIVVolt"] <- "WAIS_IV_voltooid"
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "VolgordeWAISIV"] <- "Volgorde_NPO_5"
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "AfnemerWAISIV"] <- "Afnemer_WAIS_IV"
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "WAISIVOpm"] <- "Opmerkingen_WAIS_IV"
names(WAISIV_gemstracker)[names(WAISIV_gemstracker) == "WAISIVOpmUit"] <- "Uitleg_Opmerkingen_WAIS_IV"

#voeg extra kolom toe om alleen de verplichte BRICK-waarden te exporteren naar castor en niet de hele WAISIV. Als je toch alle velden wil invullen, kan
#je of alle velden een "o" geven, of dit handmatig wijzigen per participant, in de excel die op het einde gegenereerd wordt

WAISIV_gemstracker$BRICK_of_uitgebreid_2 <- 1

#De volgende kolommen die wel in de Castor-export van de WICV staan, voegen we niet toe: Participant status, site abbreviation en participation creation date. 
#Dit zal niet zorgen voor problemen, zolang de participanten al vóór de Gemstracker-import zijn aangemaakt in Castor. We gaan niet via deze weg nieuwe patienten importeren. Dit kan wel, maar dan heb je wel deze kolommen nodig.

#Waarden in de kolommen aanpassen op Castor Format

#1.Te beginnen met de datum:

# Convert the column "Datum_WAIS_IV" to Date format
WAISIV_gemstracker$Datum_WAIS_IV <- as.Date(WAISIV_gemstracker$Datum_WAIS_IV, format = "%Y-%m-%d")

# Change the date format to "02-08-2023" in the same column
WAISIV_gemstracker$Datum_WAIS_IV <- format(WAISIV_gemstracker$Datum_WAIS_IV, "%d-%m-%Y")


#2.Hierbij veranderen we de afnemer meerkeuze kolom naar een kolom met 1 waarde in de Castor dataframe ("Afnemer_WAIS_IV_W")
# Let op! Dit moet aangepast worden als er meer afnemers bij komen, maar dan verandert de 6 in een 7 etc. Goed opletten als de labelsets worden aangepast in Castor en LS!

# Convert "AfnemerWAISIV_SQ000" to "AfnemerWAISIV_SQ006" columns to numeric values
# Convert "AfnemerWAISIV_SQ000" to "AfnemerWAISIV_SQ006" columns to numeric values
for (i in 0:6) {
  column_name <- paste("AfnemerWAISIV_SQ00", i, sep = "")
  WAISIV_gemstracker$Afnemer_WAIS_IV[WAISIV_gemstracker[column_name] == "Y"] <- i
}

#3. Hier veranderen we de waarden in de volgorde_NPO kolom voor in Castor

# Convert "VolgordeWISC_SQ001" to "VolgordeWISC_SQ004" columns to numeric values
for (i in 1:4) {
  col_name <- paste("VolgordeWAISIV_SQ00", i, sep = "")
  WAISIV_gemstracker$Volgorde_NPO_5[WAISIV_gemstracker[[col_name]] == "Y"] <- i
}

#4. Alle waarden onder kolom: Opmerkingen_WAIS_IV en WAIS_IV_voltooid gaan van Y naar 1 en van N naar 0

# Convert "Y" to 1 and "N" to 0 in the "Opmerkingen_WAIS_IV" column
WAISIV_gemstracker$Opmerkingen_WAIS_IV[WAISIV_gemstracker$Opmerkingen_WAIS_IV == "Y"] <- 1
WAISIV_gemstracker$Opmerkingen_WAIS_IV[WAISIV_gemstracker$Opmerkingen_WAIS_IV == "N"] <- 0

WAISIV_gemstracker$WAIS_IV_voltooid[WAISIV_gemstracker$WAIS_IV_voltooid == "Y"] <- 1
WAISIV_gemstracker$WAIS_IV_voltooid[WAISIV_gemstracker$WAIS_IV_voltooid == "N"] <- 0

##Haal het uur en de minuten uit twee afzonderlijke kolommen en zet ze samen in de start kolom.
# Convert numeric columns to characters
WAISIV_gemstracker$StartWAISIV_SQ001 <- as.character(WAISIV_gemstracker$StartWAISIV_SQ001)
WAISIV_gemstracker$StartWAISIV_SQ002 <- as.character(WAISIV_gemstracker$StartWAISIV_SQ002)

# Create Start_WAIS_IV column
WAISIV_gemstracker$Start_WAIS_IV <- paste(WAISIV_gemstracker$StartWAISIV_SQ001, WAISIV_gemstracker$StartWAISIV_SQ002, sep = ":")

# Repeat the same process for Stop columns
WAISIV_gemstracker$StopWAISIV_SQ001 <- as.character(WAISIV_gemstracker$StopWAISIV_SQ001)
WAISIV_gemstracker$StopWAISIV_SQ002 <- as.character(WAISIV_gemstracker$StopWAISIV_SQ002)

# Create Stop_WAIS_IV column
WAISIV_gemstracker$Stop_WAIS_IV <- paste(WAISIV_gemstracker$StopWAISIV_SQ001, WAISIV_gemstracker$StopWAISIV_SQ002, sep = ":")


#Volgorde kolommen aanpassen
WAISIV_gemstracker <- WAISIV_gemstracker %>%
  select("Participant Id", "BRICK_of_uitgebreid_2", "Datum_WAIS_IV", "Start_WAIS_IV", 
         "Stop_WAIS_IV", "Volgorde_NPO_5", "WAIS_IV_voltooid", 
         "Opmerkingen_WAIS_IV", "Uitleg_Opmerkingen_WAIS_IV", everything())


#Elke field name is uniek. In de baseline meting, hebben bijn alle velden in Castor een _1. In FU1 en FU2 zal dit zeker _2 en _3 worden
#behalve participant id en "Volgorde_5", moeten alle kolommen eraan geloven.

# Create a list to hold the new column names
new_column_names <- vector("character", length(names(WAISIV_gemstracker)))

#Delete de kolommen uit de gemstracker export die je niet nodig hebt (dplyr)

# List of columns to be removed
columns_to_remove <- c("respondentid", "organizationid", "gto_id_relation", "forgroup",
                       "consentcode", "resptrackid", "gto_round_order", "gto_round_description", 
                       "gtr_track_name", "gr2t_track_info", "gto_completion_time", "gto_start_time", 
                       "gto_valid_from", "gto_valid_until", "startlanguage", "lastpage", 
                       "gto_id_token", "surveyversion", "AfnemerWAISIV_SQ000", "AfnemerWAISIV_SQ001", 
                       "AfnemerWAISIV_SQ002", "AfnemerWAISIV_SQ003", "AfnemerWAISIV_SQ004", 
                       "AfnemerWAISIV_SQ005", "AfnemerWAISIV_SQ006", 
                       "Sub", "StartWAISIV_SQ001", "StartWAISIV_SQ002", 
                       "StopWAISIV_SQ001", "StopWAISIV_SQ002", 
                       "VolgordeWAISIV_SQ001", "VolgordeWAISIV_SQ002",
                       "VolgordeWAISIV_SQ003", "VolgordeWAISIV_SQ004", "surveyVersie",
                       "scriptVersie", "stamtabelVersie")

# Remove the specified columns
WAISIV_gemstracker <- WAISIV_gemstracker %>%
  select(-one_of(columns_to_remove))


# Iterate through each column name
for (i in seq_along(names(WAISIV_gemstracker))) {
  col_name <- names(WAISIV_gemstracker)[i]
  
  if (col_name != "Participant Id" && col_name != "Volgorde_NPO_5" && col_name != "BRICK_of_uitgebreid_2") {
    new_column_names[i] <- paste(col_name, "_1", sep = "")
  } else {
    new_column_names[i] <- col_name
  }
}

colnames(WAISIV_gemstracker) <- new_column_names


# Print the updated column names
print(names(WAISIV_gemstracker))

#exporteer nieuwe df naar excel file
write_xlsx(WAISIV_gemstracker, path = "WAISIV_gemstracker_poging5.xlsx")

# Export to CSV
write.csv(WAISIV_gemstracker, file = "WAISIV_gemstracker_poging5.csv", row.names = FALSE)


