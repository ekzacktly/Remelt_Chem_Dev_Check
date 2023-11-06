Pull_NCM_Data <- function()
{

  #Check that RODBC is installed
  library(RODBC)

  #Define Connection String
  Connection_String <- paste('DRIVER=ODBC Driver 17 for SQL Server',
                             'SERVER=EGISRVDTBHA001',
                             'DATABASE=EQS_Live_WinLaunch',
                             'Trusted_Connection=Yes',
                             sep = ';')

  #Define the Query
  Query <- paste(
    'Select LEFT(lot,8) As lot, DateCreated As NCM_Creation_Date',
    'FROM QCNcmHdr NCM',
    'INNER JOIN QCNcmCode NCode on NCM.QCNcmCodeID=NCode.QCNcmCodeID',
    'LEFT JOIN QCElement ECode on NCM.QCElementID=Ecode.QCElementID',
    'RIGHT JOIN QCNcmDet Lot on NCM.QCNcmHdrID=Lot.QCNcmHdrID',
    'Where NCM.NcmNum IS NOT NULL',
    'AND NCode.NcmCode = \'601\'',
    'AND (NcmRelease IS NULL OR NcmRelease = \'false\')',
    'Order by DateCreated desc',
    sep = " "
  )

  #Connect to DB
  Winlaunch_Live_Connect <- odbcDriverConnect(Connection_String)
  #Pull Data
  Remelt_Chem_NCMs <- sqlQuery(Winlaunch_Live_Connect, Query)
  #Close Connection
  odbcClose(Winlaunch_Live_Connect)

  #Return the Data
  return(Remelt_Chem_NCMs)
}