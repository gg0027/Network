

PilotExp_raw <- read.csv("~/Desktop/exp_data/PilotExp_raw.csv", stringsAsFactors=FALSE)
Ath_TF_list <- read.delim("~/Desktop/analysis_data/Ath_TF_list")
PilotTF <- PilotExp_raw %>% filter(X %in% Ath_TF_list$Gene_ID)

write.csv(PilotTF, file="Pilot_TF.csv")