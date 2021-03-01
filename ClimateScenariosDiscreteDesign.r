#######################
## Create Climate Scenarios
############

library(data.table)
dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"
#in cloud
# dir.scenarios<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\ProjectoAguaMty\\Inputs\\"
# dir.output<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\ProjectoAguaMty\\Inputs\\"

#Load Climate Scenarios Table
 Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios_Test.csv",sep="")) #This is the original set by Alejandra
#remove historic
 Climate.Scenarios.Table<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario!="Historic")
#remove date column
  Climate.Scenarios.Table$Date<-NULL
#change climate ids
#  Climate.Scenarios.Table$ClimateScenario<-as.numeric(Climate.Scenarios.Table$ClimateScenario)
#

#Create period column
  Climate.Scenarios.Table$Period<-ifelse(Climate.Scenarios.Table$Year+2014<2027,"P1",ifelse(Climate.Scenarios.Table$Year+2014<2039,"P2","P3"))

#  unique(Climate.Scenarios.Table$Year[Climate.Scenarios.Table$Period=="P1"])
#  unique(Climate.Scenarios.Table$Year[Climate.Scenarios.Table$Period=="P2"])
#  unique(Climate.Scenarios.Table$Year[Climate.Scenarios.Table$Period=="P3"])

#Create alternative 1
  alt.1<-Climate.Scenarios.Table
  alt.1[alt.1$Period=="P3","Year"]<-alt.1[alt.1$Period=="P3","Year"]-12
  alt.1[alt.1$Period=="P2","Year"]<-alt.1[alt.1$Period=="P2","Year"]+12
  alt.1$ClimateScenario<-paste(alt.1$ClimateScenario,".alt1",sep="")

#
#Create alternative 2
  alt.2<-Climate.Scenarios.Table
  alt.2[alt.2$Period=="P2","Year"]<-alt.2[alt.2$Period=="P2","Year"]-12
  alt.2[alt.2$Period=="P1","Year"]<-alt.2[alt.2$Period=="P1","Year"]+12
  alt.2$ClimateScenario<-paste(alt.2$ClimateScenario,".alt2",sep="")
#
#Create alternative 3
  alt.3<-Climate.Scenarios.Table
  alt.3[alt.3$Period=="P2","Year"]<-alt.3[alt.3$Period=="P2","Year"]-12
  alt.3[alt.3$Period=="P3","Year"]<-alt.3[alt.3$Period=="P3","Year"]-12
  alt.3[alt.3$Period=="P1","Year"]<-alt.3[alt.3$Period=="P1","Year"]+24
  alt.3$ClimateScenario<-paste(alt.3$ClimateScenario,".alt3",sep="")
#
#Create alternative 4
  alt.4<-Climate.Scenarios.Table
  alt.4[alt.4$Period=="P3","Year"]<-alt.4[alt.4$Period=="P3","Year"]-24
  alt.4[alt.4$Period=="P1","Year"]<-alt.4[alt.4$Period=="P1","Year"]+24
  alt.4$ClimateScenario<-paste(alt.4$ClimateScenario,".alt4",sep="")

#Create alternative 5
  alt.5<-Climate.Scenarios.Table
  alt.5[alt.5$Period=="P3","Year"]<-alt.5[alt.5$Period=="P3","Year"]-24
  alt.5[alt.5$Period=="P1","Year"]<-alt.5[alt.5$Period=="P1","Year"]+12
  alt.5[alt.5$Period=="P2","Year"]<-alt.5[alt.5$Period=="P2","Year"]+12
  alt.5$ClimateScenario<-paste(alt.5$ClimateScenario,".alt5",sep="")

#rbind all
 Climate.Scenarios.Table<-rbind(Climate.Scenarios.Table,alt.1,alt.2,alt.3,alt.4,alt.5)
 Climate.Scenarios.Table$Period<-NULL
# unique(Climate.Scenarios.Table$ClimateScenario)
# unique(Climate.Scenarios.Table$Year)

#WriteClimateEnsemble
 write.csv(Climate.Scenarios.Table,paste(dir.scenarios,"ClimateScenarios_27_12_2017.csv",sep=""),row.names=FALSE)


#

######################################################################################################################################################################################################################
## Characterize climate sampples
#####################################################################################################################################################################################################################
 library(data.table)
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"

#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios_27_12_2017.csv",sep=""))
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
# Climate.Chars[,Ensemble.Type:="LHS"]
# Climate.Chars[,ClimateScenario:=paste(ClimateScenario,"-lhs",sep="")]
# Climate.Chars.Sample<-data.table(Climate.Chars)
#rbind
# Climate.Chars.Full<-data.table(read.csv(paste(dir.output,"old/","ClimateCharsEnsemble50k.csv",sep="")))
# test<-rbind(Climate.Chars.Full,Climate.Chars.Sample)
#Print file
#  write.csv(test,paste(dir.output,"ClimateChars.csv",sep=""),row.names=FALSE)
  write.csv(Climate.Chars.Periods,paste(dir.output,"ClimateCharsPeriods_27_12_2017.csv",sep=""),row.names=FALSE)
