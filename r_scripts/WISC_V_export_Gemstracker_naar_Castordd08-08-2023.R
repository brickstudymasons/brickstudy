#Laad de benodigde libraries
library(readxl)             # Load the package into your R session
library(writexl)
library(dplyr)
 #Importeer excel file van export gemstracker WISCV
 # Replace "data.xlsx" with the actual file name and path if it's located in a different directory
 WISCV_gemstracker <- read_excel("C:/Users/asofk/OneDrive/BRICK-study/BRICK-study/Data/BRICK_Scoreformulier_WISC-V-NL_startstop_gemstracker.xlsx")
 
 #show column names of the new df
 print(colnames(WISCV_gemstracker))

 #verander de column names van gemstracker naar castor, voor Baseline.

 # Change column names
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "gr2o_patient_nr"] <- "Participant Id"
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "DatumWISCV"] <- "Datum_WISC_V"
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "StartWISCV"] <- "Start_WISC_V"
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "StopWISCV"] <- "Stop_WISC_V"
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "WISCVVolt"] <- "WISC_V_voltooid"
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "VolgordeWISC"] <- "Volgorde_NPO_3"
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "AfnemerWISCV"] <- "Afnemer_WISC_V"
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "WISCVOpm"] <- "Opmerkingen_WISC_V"
 colnames(WISCV_gemstracker)[colnames(WISCV_gemstracker) == "WISCVOpmUit"] <- "Uitleg_Opmerkingen_WISC_V"
 
 
 #voeg extra kolom toe om alleen de verplichte BRICK-waarden te exporteren naar castor en niet de hele WISCV. Als je toch alle velden wil invullen, kan
 #je of alle velden een "o" geven, of dit handmatig wijzigen per participant, in de excel die op het einde gegenereerd wordt

 WISCV_gemstracker$BRICK_of_uitgebreid <- 1
 
 #De volgende kolommen die wel in de Castor-export van de WICV staan, voegen we niet toe: Participant status, site abbreviation en participation creation date. 
 #Dit zal niet zorgen voor problemen, zolang de participanten al vóór de Gemstracker-import zijn aangemaakt in Castor. We gaan niet via deze weg nieuwe patienten importeren. Dit kan wel, maar dan heb je wel deze kolommen nodig.

 #Waarden in de kolommen aanpassen op Castor Format
 
 #1.Te beginnen met de datum:
 
 # Convert the column "Datum_WISC_V" to Date format
 WISCV_gemstracker$Datum_WISC_V <- as.Date(WISCV_gemstracker$Datum_WISC_V, format = "%Y-%m-%d")
 
 # Change the date format to "02-08-2023" in the same column
 WISCV_gemstracker$Datum_WISC_V <- format(WISCV_gemstracker$Datum_WISC_V, "%d-%m-%Y")
 
 
 #2.Hierbij veranderen we de afnemer meerkeuze kolom naar een kolom met 1 waarde in de Castor dataframe ("Afnemer_WISC_V_W")
 # Let op! Dit moet aangepast worden als er meer afnemers bij komen, maar dan verandert de 6 in een 7 etc. Goed opletten als de labelsets worden aangepast in Castor en LS!
 
 # Convert "AfnemerWISCV_SQ000" to "AfnemerWISCV_SQ006" columns to numeric values
 # Convert "AfnemerWISCV_SQ000" to "AfnemerWISCV_SQ006" columns to numeric values
 for (i in 0:6) {
   column_name <- paste("AfnemerWISCV_SQ00", i, sep = "")
   WISCV_gemstracker$Afnemer_WISC_V[WISCV_gemstracker[column_name] == "Y"] <- i
 }
 
 #3. Hier veranderen we de waarden in de volgorde_NPO kolom voor in Castor
 
 # Convert "VolgordeWISC_SQ001" to "VolgordeWISC_SQ004" columns to numeric values
 for (i in 1:4) {
   col_name <- paste("VolgordeWISC_SQ00", i, sep = "")
   WISCV_gemstracker$Volgorde_NPO_3[WISCV_gemstracker[, col_name] == "Y"] <- i
 }
 
 #4. Alle waarden onder kolom: Opmerkingen_WISC_V en WISC_V_voltooid gaan van Y naar 1 en van N naar 0
 
 # Convert "Y" to 1 and "N" to 0 in the "Opmerkingen_WISC_V" column
 WISCV_gemstracker$Opmerkingen_WISC_V[WISCV_gemstracker$Opmerkingen_WISC_V == "Y"] <- 1
 WISCV_gemstracker$Opmerkingen_WISC_V[WISCV_gemstracker$Opmerkingen_WISC_V == "N"] <- 0
 
 WISCV_gemstracker$WISC_V_voltooid[WISCV_gemstracker$WISC_V_voltooid == "Y"] <- 1
 WISCV_gemstracker$WISC_V_voltooid[WISCV_gemstracker$WISC_V_voltooid == "N"] <- 0
 
 ## Nog te testen: Haal het uur en de minuten uit twee afzonderlijke kolommen en zet ze samen in de start kolom.
 # Convert numeric columns to characters
 WISCV_gemstracker$StartWISCV_SQ001 <- as.character(WISCV_gemstracker$StartWISCV_SQ001)
 WISCV_gemstracker$StartWISCV_SQ002 <- as.character(WISCV_gemstracker$StartWISCV_SQ002)
 
 # Create Start_WISC_V column
 WISCV_gemstracker$Start_WISC_V <- paste(WISCV_gemstracker$StartWISCV_SQ001, WISCV_gemstracker$StartWISCV_SQ002, sep = ":")
 
 # Repeat the same process for Stop columns
 WISCV_gemstracker$StopWISCV_SQ001 <- as.character(WISCV_gemstracker$StopWISCV_SQ001)
 WISCV_gemstracker$StopWISCV_SQ002 <- as.character(WISCV_gemstracker$StopWISCV_SQ002)
 
 # Create Stop_WISC_V column
 WISCV_gemstracker$Stop_WISC_V <- paste(WISCV_gemstracker$StopWISCV_SQ001, WISCV_gemstracker$StopWISCV_SQ002, sep = ":")

 #Volgorde kolommen aanpassen
 WISCV_gemstracker <- WISCV_gemstracker %>%
   select("Participant Id", "BRICK_of_uitgebreid", "Datum_WISC_V", "Start_WISC_V", 
          "Stop_WISC_V", "Volgorde_NPO_3", "WISC_V_voltooid", 
          "Opmerkingen_WISC_V", "Uitleg_Opmerkingen_WISC_V", everything())
 
 
 #Elke field name is uniek. In de baseline meting, hebben bijn alle velden in Castor een _1. In FU1 en FU2 zal dit zeker _2 en _3 worden
 #behalve participant id en "Volgorde_NPO_3", moeten alle kolommen eraan geloven.

 # Create a list to hold the new column names
 new_column_names <- vector("character", length(names(WISCV_gemstracker)))
 
 #Delete de kolommen uit de gemstracker export die je niet nodig hebt (dplyr)

 # List of columns to be removed
 columns_to_remove <- c("respondentid", "organizationid", "gto_id_relation", "forgroup", 
                        "consentcode", "resptrackid", "gto_round_order", "gto_round_description", 
                        "gtr_track_name", "gr2t_track_info", "gto_completion_time", "gto_start_time", 
                        "gto_valid_from", "gto_valid_until", "startlanguage", "lastpage", 
                        "gto_id_token", "surveyversion", "AfnemerWISCV_SQ000", "AfnemerWISCV_SQ001", 
                        "AfnemerWISCV_SQ002", "AfnemerWISCV_SQ003", "AfnemerWISCV_SQ004", 
                        "AfnemerWISCV_SQ005", "AfnemerWISCV_SQ006", 
                        "VolgordeWISC_SQ001", "VolgordeWISC_SQ002", "VolgordeWISC_SQ003", 
                        "VolgordeWISC_SQ004", "Sub", "StartWISCV_SQ001", "StartWISCV_SQ002", "StopWISCV_SQ001", "StopWISCV_SQ002")
 
 # Remove the specified columns
 WISCV_gemstracker <- WISCV_gemstracker %>%
   select(-one_of(columns_to_remove))
 
 
 # Iterate through each column name
 for (i in seq_along(names(WISCV_gemstracker))) {
   if (names(WISCV_gemstracker)[i] != "Participant Id" && names(WISCV_gemstracker)[i] != "Volgorde_NPO_3") {
     new_column_names[i] <- paste(names(WISCV_gemstracker)[i], "_1", sep = "")
   } else {
     new_column_names[i] <- names(WISCV_gemstracker)[i]
   }
 }
 
 # Assign the new column names to the dataframe
 names(WISCV_gemstracker) <- new_column_names
 
 
 
 # Print the updated column names
 print(names(WISCV_gemstracker))
 
 #exporteer nieuwe df naar excel file
 write_xlsx(WISCV_gemstracker, path = "WISCV_gemstracker_poging12.xlsx")
 
 # Export to CSV
 write.csv(WISCV_gemstracker, file = "WISCV_gemstracker_poging5.csv", row.names = FALSE)
 
 
 