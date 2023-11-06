Pull_Chem_Data <- function(Lots)
{

  #Check that RODBC is installed
  library(RODBC)

  #Fix Lots to a list that Bcan be used in the SQL query
  Lots_Fixed <- NULL
  for ( i in seq_len(length(Lots)))
  {
    if(i < length(Lots))
    {
      Lots_Fixed <-paste0(Lots_Fixed,'\'',Lots[i],'\',')
    }
    else
    {
      Lots_Fixed <- paste0(Lots_Fixed,'\'',Lots[i],'\'')
    }
  }
  Lots_Fixed <- paste0('(',Lots_Fixed,')')

  #Define Connection String
  Connection_String <- paste('DRIVER=ODBC Driver 17 for SQL Server',
                             'SERVER=ersl2db-srv01.eqsl2.local\\l2_db',
                             'DATABASE=SHARP',
                             'Trusted_Connection=Yes',
                             sep = ';')

  #Define the Query
  Query <- paste(
    'Select LEFT(INGOT_ID,8) As \'Ingot_ID\', SAMPLE_ID, Most_Recent_Chem',
    'From RPT_REM_INGOT',
    'Left Join (',
      'Select REPORT_NO, SAMPLE_ID, Max(RECEPTION_DATE) As \'Most_Recent_Chem\'',
      'From RPT_REM_INGOT_ANALYSIS',
      'Group By REPORT_NO, SAMPLE_ID',
    ') A On A.REPORT_NO = RPT_REM_INGOT.REPORT_NO',
    'Where Most_Recent_Chem Is Not Null AND SAMPLE_ID IN (\'TOP\',\'BOTTOM\')',
    'AND LEFT(INGOT_ID,8) IN',Lots_Fixed,
    'Order By SAMPLE_ID desc, INGOT_ID desc',
    sep = " "
  )

  #Connect to DB
    Remelt_L2_Live_Connect <- odbcDriverConnect(Connection_String)
  #Pull Data
    Remelt_Chem_Data <- sqlQuery(Remelt_L2_Live_Connect, Query)
  #Close Connection
    odbcClose(Remelt_L2_Live_Connect)

  #Return Data
    return(Remelt_Chem_Data)

}
