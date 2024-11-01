#here, we prepare a key table for upload in castor, participation in other studies
library(dplyr)
short_key_table <- read.csv("Z:/castor_proof_files/brick_score_key_26_4_2024.csv")
subset_key_table <- short_key_table[,1:10]
print(subset_key_table)

write.csv(subset_key_table, "Z:/castor_proof_files/brick_subset_key_table102024.csv", row.names = FALSE)


