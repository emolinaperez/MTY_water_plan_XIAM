#
#Set up directories
#
# dir.model<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
# dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\"
# dir.exp<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
# dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"

#in cloud
 dir.model<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ModeloRiverware\\"
 dir.output<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\"
 dir.exp<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ExperimentsDataTables\\"
 dir.scenarios<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\Scenarios\\"

#Load libraries
 library(reshape2)
 library(data.table)
 library(rgenoud)
 library(snow)

#Source all supporting functions
  source(paste(dir.model,"OptimEngine_SupportingFunctions.r",sep=""))

#Read projects characteristics table
  Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_26_12_2017.csv",sep=""))
  Projects_Chars$ID_Project<-as.character(Projects_Chars$ID_Project)

#Load Futures Table
# tariff.scheme<-"Current"
 tariff.scheme<-"Scheme2"
 Futures.Table<-read.csv(paste(dir.exp,"FuturesTable_04_03_2018.csv",sep="")) #UPDATE

#Subset to the tarrifs scheme we are running
 Futures.Table<-subset(Futures.Table,Futures.Table$WaterTarrifs==tariff.scheme)

#Load Demand Scenarios Table
 #Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios_27_12_2017_PermanentScheme.csv",sep=""))
 #Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios_27_12_2017.csv",sep=""))
  Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios_16_01_2018.csv",sep=""))
  Demand.Scenarios.Table<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$WaterTarrifs==tariff.scheme)

#Load Climate Scenarios Table
 Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios_27_12_2017.csv",sep=""))
#Load Groundwater Scenarios Table
 GW.Scenarios.Table<-read.csv(paste(dir.scenarios,"GWScenarios_04_03_2018.csv",sep="")) #UPDATE
#Load Desalt Scenarios Table
  Desalt.Scenarios.Table<-read.csv(paste(dir.scenarios,"DesaltScenarios_04_03_2018.csv",sep="")) #UPDATE


#Split the experiment into #n number of computers
  sequence.of.runs<-1:length(Futures.Table$Future.ID)
  Total.machines<-20
  runs.per.machine<-length(sequence.of.runs)/Total.machines
  runs<-split(sequence.of.runs, ceiling(sequence.of.runs/runs.per.machine))

#in cloud
#machine<-1
#machine<-2
#machine<-3
#machine<-4
#machine<-5
#machine<-6
#machine<-7
#machine<-8
#machine<-9
#machine<-10
#machine<-11
#machine<-12
#machine<-13
#machine<-14
#machine<-15
#machine<-16
#machine<-17
#machine<-18
#machine<-19
machine<-20
 first<-as.numeric(min(runs[[machine]]))
 final<-as.numeric(max(runs[[machine]]))
#print for view
  length(sequence.of.runs)
  first
  final

#x1<-c(380,381,382,383,384,385,386,387,388,676)
#x2<-c(676,677,678,679,680,709,710,711,712,970,971,972,1003,1004,1035,1036,1068,1069,1101,1134)
x3<-c(1069,1101,1134)

for (i in unique(Futures.Table$Future.ID)[first:final])
#for (i in x3)
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Desalt.Scenarios.Table,Projects_Chars,i)
 }


#
 dir.portfolios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\Experiment_06_03_2018_Step_1\\"
# dir.portfolios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\Experiment_09_01_2018_Step_1\\"
 #dir.portfolios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\CloudExperiment\\"
 #dir.portfolios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\TestExperiment\\"
 filenames <- list.files(dir.portfolios, pattern="*.csv", full.names=FALSE)
 OptimalPortfolios<-lapply(filenames, function (x) {read.csv(paste(dir.portfolios,x,sep=""))})
 OptimalPortfolios<-do.call("rbind",OptimalPortfolios)

#Change names
 colnames(OptimalPortfolios)<-c("Panuco",
                                "VicenteGuerrero",
                                "Desalination",
                                "Cuchillo",
                                "Pozos.Ballesteros.Buenos.Aires",
                                "Pozo.En.el.Obispado",
                                "Campo.de.Pozos.El.Pajonal",
                                "Subalveo.LaUnion",
                                "Subalveo.RioConchos",
                                "Subalveo.RioPilonChapotal",
                                "TunelSanFranciscoII",
                                "Pozos.MTYI.Contry",
                                "Presa.LaLibertad",
                                "Reduccion.ANC",
                                "Inyeccion.Inducida",
                                "Best.Cost",
                                "Best.Reliability",
                                "Period",
                                "Future.ID")
#
#write result
  dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  write.csv(OptimalPortfolios,paste(dir.output,"OptimalPortfolios_06_03_2018.csv",sep=""),row.names=FALSE)
