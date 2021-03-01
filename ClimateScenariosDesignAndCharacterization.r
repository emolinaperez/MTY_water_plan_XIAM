######################################################################################################################################################################################################################
##Create multiple sequences of climate series
#####################################################################################################################################################################################################################
 library(data.table)
 dir.scenarios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\Scenarios\\"
 #in cloud
# dir.scenarios<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\ProjectoAguaMty\\Inputs\\"
# dir.output<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\ProjectoAguaMty\\Inputs\\"

#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios_Test.csv",sep=""))
  Climate.Scenarios.Table$ClimateScenario<-as.character(Climate.Scenarios.Table$ClimateScenario)
  Historic<-data.table(subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario=="Historic.Synthetic"))
#  Historic$Date<-NULL
#Scenarios per River
  VicenteGuerrero<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Vicente.Guerrero.Inflow")]
  La.Boca<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","La.Boca.Inflow")]
  Rio.San.Juan.1<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Rio.San.Juan.1.Inflow")]
  Rio.Panuco.MTY.VI<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Rio.Panuco.MTY.VI.Inflow")]
  Rio.Pablillo_Camacho<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Rio.Pablillo_Camacho.Inflow")]
  La.Libertad<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","La.Libertad.Inflow")]
  Pesqueria<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Pesqueria.Inflow")]

#look at correlations
#  cor(Climate.Scenarios.Table[,c("Vicente.Guerrero.Inflow","La.Boca.Inflow","Rio.San.Juan.1.Inflow","Rio.Panuco.MTY.VI.Inflow","Rio.Pablillo_Camacho.Inflow","La.Libertad.Inflow","Pesqueria.Inflow")])
#  test<-ccf(VicenteGuerrero$Vicente.Guerrero.Inflow,Pesqueria$Pesqueria.Inflow)
#          La.Boca$La.Boca.Inflow)
#    Climate.Scenarios.Table[,c("Vicente.Guerrero.Inflow","La.Boca.Inflow","Rio.San.Juan.1.Inflow","Rio.Panuco.MTY.VI.Inflow","Rio.Pablillo_Camacho.Inflow","La.Libertad.Inflow","Pesqueria.Inflow")])
#    VicenteGuerrero$Vicente.Guerrero.Inflow,
#      La.Boca$La.Boca.Inflow,
#      Rio.San.Juan.1$Rio.San.Juan.1.Inflow,
#      Rio.Panuco.MTY.VI$Rio.Panuco.MTY.VI.Inflow,
#      Rio.Pablillo_Camacho$Rio.Pablillo_Camacho.Inflow,
#      La.Libertad$La.Libertad.Inflow,
#      Pesqueria$Pesqueria.Inflow
#    )

#
#not very significant correlations
#the times series do not look very correlated


#
 Scenarios<-as.character(unique(Climate.Scenarios.Table$ClimateScenario))
#
#Combinations<- expand.grid(c(1:length(Scenarios)),
#                           c(1:length(Scenarios)),
#                           c(1:length(Scenarios)),
#                           c(1:length(Scenarios)))

#Combinations<- expand.grid(c(1:length(Scenarios)),
#                           c(1:length(Scenarios)),
#                           c(1:length(Scenarios)),
#                           c(1:length(Scenarios)),
#                           c(1:length(Scenarios)),
#                           c(1:length(Scenarios)),
#                           c(1:length(Scenarios)))
#
# Create a sample
 library(lhs)
 set.seed(5000)
  sample.size<-50
# sample.size<-200000
# sample.size<-50000
# lhs.sample<-randomLHS(sample.size,7)
 #lhs.sample<-improvedLHS(sample.size, 7, dup=2)
# lhs.sample<-improvedLHS(sample.size, 7, dup=5)
# lhs.sample<-improvedLHS(sample.size, 7, dup=10)
 lhs.sample<-improvedLHS(sample.size, 9, dup=10)
 lhs.sample.rivers<-lhs.sample[,1:7]
 lhs.sample.others<-lhs.sample[,8:9]


#Create sample for groundwater and Desalination
 gw.scenarios<-qunif(lhs.sample.others[,1],-0.2,0.2)
 desalt.scenarios<-qunif(lhs.sample.others[,2],-0.3,0.0)

#Create combinations of rivers conditions
 Combinations<-data.frame(apply(lhs.sample.rivers,c(1,2),function(x) {
                                                   ifelse(x<0.1,1,
                                                      ifelse(x<0.2,2,
                                                        ifelse(x<0.3,3,
                                                          ifelse(x<0.4,4,
                                                            ifelse(x<0.5,5,
                                                              ifelse(x<0.6,6,
                                                                ifelse(x<0.7,7,
                                                                  ifelse(x<0.8,8,
                                                                    ifelse(x<0.9,9,10)))))))))
                                                   })
                            )

Combinations$ClimateScenario<-as.character(row.names(Combinations))

Create.Table<-function(x){
Climates<-data.table(data.frame(ClimateScenario=as.numeric(x[8]),
                       Year=Climate.Scenarios.Table$Year[Climate.Scenarios.Table$ClimateScenario==Scenarios[1]],
                       Month=Climate.Scenarios.Table$Month[Climate.Scenarios.Table$ClimateScenario==Scenarios[1]],
                       Vicente.Guerrero.Inflow=VicenteGuerrero$Vicente.Guerrero.Inflow[VicenteGuerrero$ClimateScenario==Scenarios[as.numeric(x[5])]],
                       La.Boca.Inflow=La.Boca$La.Boca.Inflow[La.Boca$ClimateScenario==Scenarios[as.numeric(x[1])]],
                       Rio.San.Juan.1.Inflow=Rio.San.Juan.1$Rio.San.Juan.1.Inflow[Rio.San.Juan.1$ClimateScenario==Scenarios[as.numeric(x[2])]],
                       Rio.Panuco.MTY.VI.Inflow=Rio.Panuco.MTY.VI$Rio.Panuco.MTY.VI.Inflow[Rio.Panuco.MTY.VI$ClimateScenario==Scenarios[as.numeric(x[6])]],
                       Rio.Pablillo_Camacho.Inflow=Rio.Pablillo_Camacho$Rio.Pablillo_Camacho.Inflow[Rio.Pablillo_Camacho$ClimateScenario==Scenarios[as.numeric(x[3])]],
                       La.Libertad.Inflow=La.Libertad$La.Libertad.Inflow[La.Libertad$ClimateScenario==Scenarios[as.numeric(x[7])]],
                       Pesqueria.Inflow=Pesqueria$Pesqueria.Inflow[Pesqueria$ClimateScenario==Scenarios[as.numeric(x[4])]]))
return(Climates)
}

#
# library(snow,lib="C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\TechChange-RDM\\Rlibraries")
#nCore<-7
#cl <- makeSOCKcluster(names = rep('localhost',nCore))
#global.elements<-list("Combinations","data.table","Create.Table","Climate.Scenarios.Table","Scenarios","VicenteGuerrero",
#"La.Boca",
#"Rio.San.Juan.1",
#"Rio.Panuco.MTY.VI",
#"Rio.Pablillo_Camacho",
#"La.Libertad",
#"Pesqueria"
#)
#clusterExport(cl,global.elements,envir=environment())
#Run simulations
#test<-parApply(cl,Combinations,1,Create.Table)
#stopCluster(cl)

#Climate.Scenarios.Table<-rbindlist(test,use.names=TRUE)
#Climate.Scenarios.Table<-rbindlist(list(Climate.Scenarios.Table,Historic),use.names=TRUE)
#rm(test)

#
test<-apply(Combinations,1,Create.Table)
ClimateAll<-rbindlist(test,use.names=TRUE)
ClimateAll<-rbindlist(list(ClimateAll,Historic),use.names=TRUE)
#Print file
# write.csv(Climate.Scenarios.Table,paste(dir.scenarios,"ClimateScenariosAll50k.csv",sep=""),row.names=FALSE)
write.csv(ClimateAll,paste(dir.scenarios,"ClimateScenariosSample.csv",sep=""),row.names=FALSE)

######################################################################################################################################################################################################################
## Specify climate sample
#####################################################################################################################################################################################################################

#Expand.climate.scenarios sample
 Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"old/","ClimateScenariosAll50k.csv",sep=""))
#subset to the climates that we want

#subset to climates we want
 target.group<-c(39,21148,12457,9715,8763,9643,8260)
 ExtraSet<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario%in%target.group)

#load sample
 Climate.Ensamble<-read.csv(paste(dir.scenarios,"ClimateScenariosSample.csv",sep=""))

#rbind both datasets
 ExtraSet$ClimateScenario<-as.numeric(as.character(ExtraSet$ClimateScenario))
 ExtraSet$ClimateScenario<-ExtraSet$ClimateScenario+100
 ExtraSet$ClimateScenario<-as.character(ExtraSet$ClimateScenario)
#remove columns we do not want
 ExtraSet$CurrentSources.Inflow<-NULL
 ExtraSet$FutureSources.Inflow<-NULL
 ExtraSet$Season<-NULL
 ExtraSet$Period<-NULL

 Climate.Ensamble$ClimateScenario<-as.character(Climate.Ensamble$ClimateScenario)
 Climate.Ensamble<-rbind(Climate.Ensamble,ExtraSet)

#WriteClimateEnsemble
 write.csv(Climate.Ensamble,paste(dir.scenarios,"ClimateScenarios.csv",sep=""),row.names=FALSE)

#define grounwater Ensemble
 GW.Ensamble<-data.frame(ClimateScenario=c(as.character(1:length(gw.scenarios)),"Historic.Synthetic",as.character(target.group+100)),
                         gw.factor=c(gw.scenarios,0.0,runif(length(target.group),-0.2,0.2)))

 write.csv(GW.Ensamble,paste(dir.scenarios,"GWScenarios.csv",sep=""),row.names=FALSE)

#Define desalt cost scenarios
  DesaltCost<-c(desalt.scenarios,runif(length(target.group),-0.3,0.0),0.0)


######################################################################################################################################################################################################################
## Characterize climate sampples
#####################################################################################################################################################################################################################
 library(data.table)
 dir.scenarios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\Scenarios\\"
 dir.output<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"

#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios.csv",sep=""))
#  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenariosAll.csv",sep=""))
#   Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenariosSample.csv",sep=""))


#Aggregate at yearly level

  Climate.Scenarios.Table<-data.table(Climate.Scenarios.Table)
#  Climate.Scenarios.Table[,Date:=NULL]
#  Climate.Scenarios.Table$Date<-NULL
#Create flow for current supply
  Climate.Scenarios.Table[,CurrentSources.Inflow:=Pesqueria.Inflow+La.Boca.Inflow+Rio.San.Juan.1.Inflow+Rio.Pablillo_Camacho.Inflow]
#Create flow for future supply
  Climate.Scenarios.Table[,FutureSources.Inflow:=Rio.Panuco.MTY.VI.Inflow+La.Libertad.Inflow+Vicente.Guerrero.Inflow]
#Create flow for future supply
  Climate.Scenarios.Table[,AllSources.Inflow:=CurrentSources.Inflow+FutureSources.Inflow]

#Create seasonal bins
  Climate.Scenarios.Table[,Season:=ifelse(Month%in%c(4:9)==TRUE,"Summer","Winter")]
#Create Period bins
  Climate.Scenarios.Table[,Period:=ifelse(Year+2014<2027,"P1",ifelse(Year+2014<2039,"P2","P3"))]

#Define metrics
 Rivers<-subset(names(Climate.Scenarios.Table),!(names(Climate.Scenarios.Table)%in%c("ClimateScenario","Year","Month","Season","Period")))

#First estimate historical means
 #Historic<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario=="Historic")
 Historic<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario=="Historic.Synthetic")
 Historic<-Historic[ , lapply(.SD,mean), by = list(ClimateScenario,Month) ,.SDcols=Rivers]
 Historic[,ClimateScenario:=NULL]
 names(Historic)<-c("Month",paste(Rivers,".historic",sep=""))

#Begin climate summary table
#Estimate mean
 Climate.mean<-Climate.Scenarios.Table[ , lapply(.SD,mean), by = list(ClimateScenario) ,.SDcols=Rivers]
 names(Climate.mean)<-c("ClimateScenario",paste(Rivers,".mean",sep=""))

#
#Estimate summer mean
 Climate.Summer<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$Season=="Summer")
 Climate.Summer<-Climate.Summer[ , lapply(.SD,mean), by = list(ClimateScenario) ,.SDcols=Rivers]
 names(Climate.Summer)<-c("ClimateScenario",paste(Rivers,".summer.mean",sep=""))

#Estimate winter mean
 Climate.Winter<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$Season=="Winter")
 Climate.Winter<-Climate.Winter[ , lapply(.SD,mean), by = list(ClimateScenario) ,.SDcols=Rivers]
 names(Climate.Winter)<-c("ClimateScenario",paste(Rivers,".winter.mean",sep=""))

#Estimate median
 Climate.median<-Climate.Scenarios.Table[ , lapply(.SD,median), by = list(ClimateScenario) ,.SDcols=Rivers]
 names(Climate.median)<-c("ClimateScenario",paste(Rivers,".median",sep=""))

#Estimate variance
 Climate.sd<-Climate.Scenarios.Table[ , lapply(.SD,sd), by = list(ClimateScenario) ,.SDcols=Rivers]
 names(Climate.sd)<-c("ClimateScenario",paste(Rivers,".sd",sep=""))

#Number of months below historical
 Climate.Months<-data.table(Climate.Scenarios.Table)
 Climate.Months<-merge(Climate.Months,Historic,all.x=TRUE)
 for (i in 1:length(Rivers))
 {
  Climate.Months[,Rivers[i]:=ifelse(get(Rivers[i])<get(paste(Rivers[i],".historic",sep="")),1,0)]
 }
 Climate.Months<-Climate.Months[,subset(names(Climate.Months),!(names(Climate.Months)%in%paste(Rivers,".historic",sep=""))),with=FALSE]
#Percent of time below historical
  Climate.MonthsP<-Climate.Months[ , lapply(.SD,mean), by = list(ClimateScenario) ,.SDcols=Rivers]
  names(Climate.MonthsP)<-c("ClimateScenario",paste(Rivers,".MonthsBelowHist",sep=""))
#Maximum Consecutive months below historical mean
Rep.below.historic<-function(x)
{
 Rep.sqs<-rle(x)
 Rep.sqs<-data.frame(Length=Rep.sqs$lengths,Value=Rep.sqs$values)
 Rep.sqs<-subset(Rep.sqs,Rep.sqs$Value==1)
 max(Rep.sqs$Length)
}
 Climate.MonthsC<-Climate.Months[ , lapply(.SD,Rep.below.historic), by = list(ClimateScenario) ,.SDcols=Rivers]
 names(Climate.MonthsC)<-c("ClimateScenario",paste(Rivers,".ConsecutiveMonthsBelowHist",sep=""))

#
Climate.Chars<-Reduce(function(...) { merge(..., all=TRUE) }, list(Climate.mean,
                                                                   Climate.Summer,
                                                                   Climate.Winter,
                                                                   Climate.median,
                                                                   Climate.sd,
                                                                   Climate.MonthsP,
                                                                   Climate.MonthsC))
Climate.Chars[,Period:="All"]
#
#Now we do the same, but for individual periods

#Begin climate summary table
#Estimate mean
 Climate.mean<-Climate.Scenarios.Table[ , lapply(.SD,mean), by = list(ClimateScenario,Period) ,.SDcols=Rivers]
 names(Climate.mean)<-c("ClimateScenario","Period",paste(Rivers,".mean",sep=""))

#Estimate summer mean
 Climate.Summer<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$Season=="Summer")
 Climate.Summer<-Climate.Summer[ , lapply(.SD,mean), by = list(ClimateScenario,Period) ,.SDcols=Rivers]
 names(Climate.Summer)<-c("ClimateScenario","Period",paste(Rivers,".summer.mean",sep=""))

#Estimate winter mean
 Climate.Winter<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$Season=="Winter")
 Climate.Winter<-Climate.Winter[ , lapply(.SD,mean), by = list(ClimateScenario,Period) ,.SDcols=Rivers]
 names(Climate.Winter)<-c("ClimateScenario","Period",paste(Rivers,".winter.mean",sep=""))

#Estimate median
 Climate.median<-Climate.Scenarios.Table[ , lapply(.SD,median), by = list(ClimateScenario,Period) ,.SDcols=Rivers]
 names(Climate.median)<-c("ClimateScenario","Period",paste(Rivers,".median",sep=""))

#Estimate variance
 Climate.sd<-Climate.Scenarios.Table[ , lapply(.SD,sd), by = list(ClimateScenario,Period) ,.SDcols=Rivers]
 names(Climate.sd)<-c("ClimateScenario","Period",paste(Rivers,".sd",sep=""))

#Percent of time below historical
  Climate.MonthsP<-Climate.Months[ , lapply(.SD,mean), by = list(ClimateScenario,Period) ,.SDcols=Rivers]
  names(Climate.MonthsP)<-c("ClimateScenario","Period",paste(Rivers,".MonthsBelowHist",sep=""))
#Maximum Consecutive months below historical mean
Rep.below.historic<-function(x)
{
 Rep.sqs<-rle(x)
 Rep.sqs<-data.frame(Length=Rep.sqs$lengths,Value=Rep.sqs$values)
 Rep.sqs<-subset(Rep.sqs,Rep.sqs$Value==1)
 max(Rep.sqs$Length)
}
 Climate.MonthsC<-Climate.Months[ , lapply(.SD,Rep.below.historic), by = list(ClimateScenario,Period) ,.SDcols=Rivers]
 names(Climate.MonthsC)<-c("ClimateScenario","Period",paste(Rivers,".ConsecutiveMonthsBelowHist",sep=""))

#
Climate.Chars.Periods<-Reduce(function(...) { merge(..., all=TRUE) }, list(Climate.mean,
                                                                   Climate.Summer,
                                                                   Climate.Winter,
                                                                   Climate.median,
                                                                   Climate.sd,
                                                                   Climate.MonthsP,
                                                                   Climate.MonthsC))
#
#Put together both data sets
 dim(Climate.Chars)
 dim(Climate.Chars.Periods)
 Climate.Chars<-rbindlist(list(Climate.Chars,Climate.Chars.Periods),use.names=TRUE)
 dim(Climate.Chars)
#
# Climate.Chars[,Ensemble.Type:="FullFactorial"]
 Climate.Chars[,Ensemble.Type:="LHS"]
 Climate.Chars[,ClimateScenario:=paste(ClimateScenario,"-lhs",sep="")]
 Climate.Chars.Sample<-data.table(Climate.Chars)
#rbind
 Climate.Chars.Full<-data.table(read.csv(paste(dir.output,"old/","ClimateCharsEnsemble50k.csv",sep="")))
 test<-rbind(Climate.Chars.Full,Climate.Chars.Sample)
#Print file
  write.csv(test,paste(dir.output,"ClimateChars.csv",sep=""),row.names=FALSE)
  write.csv(Climate.Chars.Periods,paste(dir.output,"ClimateCharsPeriods.csv",sep=""),row.names=FALSE)
  #write.csv(Climate.Chars,paste(dir.output,"ClimateChars.csv",sep=""),row.names=FALSE)
#  write.csv(Climate.Chars,paste(dir.output,"ClimateCharsEnsemble50k.csv",sep=""),row.names=FALSE)





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
