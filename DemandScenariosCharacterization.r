
######################################################################################################################################################################################################################
## Characterize Demand Scenarios
#####################################################################################################################################################################################################################
 library(data.table)
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"

#Load Climate Scenarios Table
  Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios_16_01_2018.csv",sep=""))
#Aggregate at yearly level
  Demand.Scenarios.Table<-data.table(Demand.Scenarios.Table)
#Create Period bins
  Demand.Scenarios.Table[,Period:=ifelse(Year+2014<2027,"P1",ifelse(Year+2014<2039,"P2","P3"))]
#Demand mean
  Demand.mean<-Demand.Scenarios.Table[ , lapply(.SD,mean), by = list(WaterTarrifs,Scenario,Period) ,.SDcols="Demand.cms"]
  names(Demand.mean)<-c("WaterTarrifs","DemandScenario","Period","Demand.cms")
  write.csv(Demand.mean,paste(dir.output,"DemandCharsPeriods_16_01_2018.csv",sep=""),row.names=FALSE)
