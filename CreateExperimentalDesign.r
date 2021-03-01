#
# This script creates the futures table
#
 dir.scenarios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\Scenarios\\"

#First read the indivudal scenario data bases
 DemandScenarios<-read.csv(paste(dir.scenarios,"DemandScenarios.csv",sep=""))
 ClimateScenarios<-read.csv(paste(dir.scenarios,"ClimateScenarios.csv",sep=""))
 GWScenarios<-read.csv(paste(dir.scenarios,"GWScenarios.csv",sep=""))

#Extract scenario tags
  DemandScenario<-as.character(unique(DemandScenarios$Scenario))
  ClimateScenario<-as.character(unique(ClimateScenarios$ClimateScenario))
  GWScenario<-as.character(unique(GWScenarios$ClimateScenario))

#Create the unique Table
  Futures.Table<-expand.grid(ClimateScenario = ClimateScenario,
                             DemandScenario = DemandScenario)
  Futures.Table$GWScenario<-Futures.Table$ClimateScenario
  Futures.Table$Future.ID<-c(1:nrow(Futures.Table))

#write Futures Table
  dir.exp<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  write.csv(Futures.Table,paste(dir.exp,"FuturesTable.csv",sep=""),row.names=FALSE)
