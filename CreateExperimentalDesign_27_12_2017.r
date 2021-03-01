#
# This script creates the futures table
#
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"

#The firt part of the experiment looks only at demand and supply

#First read the indivudal scenario data bases
  DemandScenarios<-read.csv(paste(dir.scenarios,"DemandScenarios_27_12_2017.csv",sep=""))
  ClimateScenarios<-read.csv(paste(dir.scenarios,"ClimateScenarios_27_12_2017.csv",sep=""))

#Extract scenario tags
  DemandScenario<-as.character(unique(DemandScenarios$Scenario))
  ClimateScenario<-as.character(unique(ClimateScenarios$ClimateScenario))
#Create the unique Table
  Futures.Table<-expand.grid(ClimateScenario = ClimateScenario,
                             DemandScenario = DemandScenario)
  Futures.Table$GWScenario<-"Historic.Synthetic"
  Futures.Table$DesaltScenario<-"Historic.Synthetic"
  Futures.Table$Block<-"Block1"

#In the second part we add ground water uncertainty and desalt cost uncertainty
#Create grondwater and desalt scenarios
  library(lhs)
  set.seed(5000)
  sample.size<-nrow(Futures.Table)
  lhs.sample<-randomLHS(sample.size, 2)
  gw.scenarios<-qunif(lhs.sample[,1],-0.3,0.3)
  desalt.scenarios<-qunif(lhs.sample[,2],-0.3,0.0)
#write the scenarios tables
#Grounwater
 GW.Ensamble<-data.frame(GWScenario=c(as.character(c(1:length(gw.scenarios))),"Historic.Synthetic"),
                         gw.factor=c(gw.scenarios,0.0)
                         )
 write.csv(GW.Ensamble,paste(dir.scenarios,"GWScenarios_27_12_2017.csv",sep=""),row.names=FALSE)
#Desalinization
 Desalt.Ensamble<-data.frame(DesaltScenario=c(as.character(c(1:length(desalt.scenarios))),"Historic.Synthetic"),
                             desalt.factor=c(desalt.scenarios,0.0)
                        )

 write.csv(Desalt.Ensamble,paste(dir.scenarios,"DesaltScenarios_27_12_2017.csv",sep=""),row.names=FALSE)
##
#Now create second part of the futures tables
  Futures.Table.2<-Futures.Table
  Futures.Table.2$GWScenario<-as.character(c(1:length(gw.scenarios)))
  Futures.Table.2$DesaltScenario<-as.character(c(1:length(desalt.scenarios)))
  Futures.Table.2$Block<-"Block2"
#Rbind the two parts toghether
  Futures.Table<-rbind(Futures.Table,Futures.Table.2)
  Futures.Table$WaterTarrifs<-"Current"

# Add section with tarrifss
#permanente scheme
  Futures.Table.Tarrifs<-subset(Futures.Table,Futures.Table$Block=="Block1")
  Futures.Table.Tarrifs$WaterTarrifs<-"Scheme2"
  Futures.Table.Tarrifs$Block<-"Block3"

#Rbind the two parts toghether
  Futures.Table<-rbind(Futures.Table,Futures.Table.Tarrifs)

#Create Futures ID
  Futures.Table$Future.ID<-c(1:nrow(Futures.Table))

#write Futures Table
  dir.exp<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  write.csv(Futures.Table,paste(dir.exp,"FuturesTable_16_01_2018.csv",sep=""),row.names=FALSE)

######################
#In the following part of the script we characterize all futures
####################

#considerar las condiciones de demanda interperiodos

#needed directories
 dir.exp<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"

#Read futures table
   Futures.Table<-read.csv(paste(dir.exp,"FuturesTable_16_01_2018.csv",sep=""))

#Create table with futures characteristics
#Create future chars table
   Futures.Chars<-data.frame(Future.ID=rep(1:length(Futures.Table$Future.ID),each=3),Period=rep(c("P1","P2","P3"),length(Futures.Table$Future.ID)))


#Merge futures table with Future.Chars
  dim(Futures.Chars)
  dim(Futures.Table)
  Futures.Chars<-merge(Futures.Chars,Futures.Table,by="Future.ID")
  dim(Futures.Chars)

#Now load groundwater scenarios
  GW.Scenarios.Table<-read.csv(paste(dir.scenarios,"GWScenarios_27_12_2017.csv",sep=""))
#merge
 dim(Futures.Chars)
 dim(GW.Scenarios.Table)
  Futures.Chars<-merge(Futures.Chars,GW.Scenarios.Table,by="GWScenario")
 dim(Futures.Chars)

#Now load desalt scenarios
  Desalt.Scenarios.Table<-read.csv(paste(dir.scenarios,"DesaltScenarios_27_12_2017.csv",sep=""))
#Merge
  dim(Futures.Chars)
  dim(Desalt.Scenarios.Table)
   Futures.Chars<-merge(Futures.Chars,Desalt.Scenarios.Table,by="DesaltScenario")
  dim(Futures.Chars)

#Now load demand scenarios
#Load Demand Scenarios Chars
  DemandCharsPeriods<-read.csv(paste(dir.exp,"DemandCharsPeriods_16_01_2018.csv",sep=""))
#
 dim(Futures.Chars)
 dim(DemandCharsPeriods)
 Futures.Chars<-Reduce(function(...) { merge(..., all=TRUE) }, list(Futures.Chars,DemandCharsPeriods))
 dim(Futures.Chars)

#Load Climate Scenarios Chars
  ClimateCharsPeriods<-read.csv(paste(dir.exp,"ClimateCharsPeriods_27_12_2017.csv",sep=""))
  Rivers<-c("Vicente.Guerrero.Inflow","La.Boca.Inflow",
         "Rio.San.Juan.1.Inflow","Rio.Panuco.MTY.VI.Inflow",
         "Rio.Pablillo_Camacho.Inflow","La.Libertad.Inflow","Pesqueria.Inflow")
  #var.type<-".MonthsBelowHist"
  var.type<-".mean"
  vars<-paste(Rivers,var.type,sep="")
#subset to target variables
    ClimateCharsPeriods<-ClimateCharsPeriods[,c("ClimateScenario","Period",vars)]
#subet to historic levels
    ClimateCharsPeriodsH<-ClimateCharsPeriods[ClimateCharsPeriods$ClimateScenario=="Historic.Synthetic",c("Period",vars)]
    colnames(ClimateCharsPeriodsH)<-c("Period",paste(vars,".Hlevel",sep=""))
#Estimate means accross periods
   ClimateCharsPeriodsH<-data.frame(t(sapply(ClimateCharsPeriodsH[,paste(vars,".Hlevel",sep="")],mean)))
#merge
  dim(ClimateCharsPeriods)
  ClimateCharsPeriods<-merge(ClimateCharsPeriods,ClimateCharsPeriodsH)
  dim(ClimateCharsPeriods)

#Now estimate percent differences for each column
 for (i in 1:length(vars))
 {
  ClimateCharsPeriods[,paste(vars[i],".HDiff",sep="")]<-(ClimateCharsPeriods[,vars[i]]-ClimateCharsPeriods[,paste(vars[i],".Hlevel",sep="")])/ClimateCharsPeriods[,paste(vars[i],".Hlevel",sep="")]
 }

#understanding the variation
 summary(ClimateCharsPeriods[ClimateCharsPeriods$Period=="P1",paste(vars,".HDiff",sep="")])

#Create mean accross sources groups
 ClimateCharsPeriods$CurrentSources.HDiff<-rowMeans(ClimateCharsPeriods[,paste(c("Pesqueria.Inflow","La.Boca.Inflow","Rio.San.Juan.1.Inflow","Rio.Pablillo_Camacho.Inflow"),var.type,".HDiff",sep="")])*100
 ClimateCharsPeriods$FutureSources.HDiff<-rowMeans(ClimateCharsPeriods[,paste(c("Rio.Panuco.MTY.VI.Inflow","La.Libertad.Inflow","Vicente.Guerrero.Inflow"),var.type,".HDiff",sep="")])*100
 ClimateCharsPeriods$AllSources.HDiff<-rowMeans(ClimateCharsPeriods[,c("CurrentSources.HDiff","FutureSources.HDiff")])*100
 ClimateCharsPeriods<-ClimateCharsPeriods[,c("ClimateScenario","Period","CurrentSources.HDiff","FutureSources.HDiff","AllSources.HDiff")]

#merge
 dim(Futures.Chars)
 dim(ClimateCharsPeriods)
 Futures.Chars<-Reduce(function(...) { merge(..., all=TRUE) }, list(Futures.Chars,ClimateCharsPeriods))
 dim(Futures.Chars)


# add for every period sub groups of uncertainty conditions
#Create function
Levels.Period<-function(var,Data)
{
#  Data<-Futures.Chars
#  var<-"Demand.cms"
#Subset table
 Pivot<-Data[,c("Future.ID","Period",var)]
#Estimate quantiles
  levels<-c(0.25,0.75)
  p1.levels<-quantile(Futures.Chars[Futures.Chars$Period=="P1",var],probs=levels)
  p2.levels<-quantile(Futures.Chars[Futures.Chars$Period=="P2",var],probs=levels)
  p3.levels<-quantile(Futures.Chars[Futures.Chars$Period=="P3",var],probs=levels)
#Create levels table
  levels<-data.frame(Period=c("P1","P2","P3"),
                     L1=c(round(p1.levels[1],1),round(p2.levels[1],1),round(p3.levels[1],1)),
                     L2=c(round(p1.levels[2],1),round(p2.levels[2],1),round(p3.levels[2],1)))
#Merge with Pivot
 Pivot<-merge(Pivot,levels,by="Period")
#Estimate Levels
Pivot$var.levels<-ifelse(Pivot[,var]<=Pivot[,"L1"],paste("<=",Pivot[,"L1"],sep=""),
                               ifelse(Pivot[,var]<=Pivot[,"L2"],paste("(",Pivot[,"L1"],",",Pivot[,"L2"],"]",sep=""),paste(">",Pivot[,"L2"],sep=""))
                        )

 Pivot<-Pivot[,c("Future.ID","Period","var.levels")]
 colnames(Pivot)<-c("Future.ID","Period",paste(var,".Levels",sep=""))
 return(Pivot)
}
#Create Levels
 Demand.Levels<-Levels.Period("Demand.cms",Futures.Chars)
 Climate.Levels1<-Levels.Period("AllSources.HDiff",Futures.Chars)
 Climate.Levels2<-Levels.Period("CurrentSources.HDiff",Futures.Chars)
 Climate.Levels3<-Levels.Period("FutureSources.HDiff",Futures.Chars)
 GW.Levels<-Levels.Period("gw.factor",Futures.Chars)
#
 dim(Futures.Chars)
 Futures.Chars<-Reduce(function(...) { merge(..., all=TRUE) }, list(Futures.Chars,Demand.Levels,Climate.Levels1,Climate.Levels2,Climate.Levels3,GW.Levels))
 dim(Futures.Chars)
#write demand chars
  write.csv(Futures.Chars,paste(dir.exp,"FuturesChars_16_01_2018.csv",sep=""),row.names=FALSE)

#the compa
