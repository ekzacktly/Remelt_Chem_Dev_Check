source(file = "NCM_Data.R")
source(file = "Remelt_Chem_Data.R")

NCM_Data <- Pull_NCM_Data()

Chem_Data <- Pull_Chem_Data(as.vector(NCM_Data$lot))

Final_Data <- merge(NCM_Data, Chem_Data,by.x = "lot", by.y = 'Ingot_ID')
Final_Data_Filtered <- Final_Data[Final_Data[,"DateCreated"]<Final_Data[,"Most_Recent_Chem"],]