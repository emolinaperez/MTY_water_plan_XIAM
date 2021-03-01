#load demand tarriffs scenarios
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"

#
 Demand.factors<-read.csv(paste(dir.scenarios,"WaterTariffsSchemes.csv",sep=""))

#load Demand scenarios

 Demand.Scenarios<-read.csv(paste(dir.scenarios,"DemandScenarios_27_12_2017.csv",sep=""))
 Demand.Scenarios$WaterTarrifs<-"Current"
#Demand Scenarios for permanent scheme
  Demand.Scenarios.Scheme2<-Demand.Scenarios
  Demand.Scenarios.Scheme2$factor<-rep(Demand.factors$Factors.Tariffs.Scheme2,length(unique(Demand.Scenarios.Scheme2$Scenario)))
  Demand.Scenarios.Scheme2$Demand.cms<-Demand.Scenarios.Scheme2$Demand.cms*Demand.Scenarios.Scheme2$factor
  Demand.Scenarios.Scheme2$WaterTarrifs<-"Scheme2"
  Demand.Scenarios.Scheme2$factor<-NULL
 #write demand scenarios
  #write.csv(Demand.Scenarios,paste(dir.scenarios,"DemandScenarios_27_12_2017_PermanentScheme.csv",sep=""),row.names=FALSE)

#Demand Scenarios for seasonal scheme
 Demand.Scenarios.Scheme1<-Demand.Scenarios
 Demand.Scenarios.Scheme1$factor<-rep(Demand.factors$Factors.Tariffs.Scheme1,length(unique(Demand.Scenarios.Scheme1$Scenario)))
 Demand.Scenarios.Scheme1$Demand.cms<-Demand.Scenarios.Scheme1$Demand.cms*Demand.Scenarios.Scheme1$factor
 Demand.Scenarios.Scheme1$WaterTarrifs<-"Scheme1"
 Demand.Scenarios.Scheme1$factor<-NULL

#Rbind all scenarios
 #Demand.Scenarios<-rbind(Demand.Scenarios,Demand.Scenarios.Scheme2,Demand.Scenarios.Scheme1)
 Demand.Scenarios<-rbind(Demand.Scenarios,Demand.Scenarios.Scheme2)

#write demand scenarios
 write.csv(Demand.Scenarios,paste(dir.scenarios,"DemandScenarios_16_01_2018.csv",sep=""),row.names=FALSE)
