#This script runs the Master Plan RiverWare Model in batch mode invoking a system command
mty.riverware.model<-function(Run.ID,dir.model,dir.riverware.input,Demand.Scenario,Policy) {
#Write demand scenario in Riverware input file
 write.xlsx2(Demand.Scenario, file=paste(dir.riverware.input,"demandtable.xlsx",sep=""),row.names=FALSE)
#Write demand scenario in Riverware input file
 write.xlsx2(Policy, file=paste(dir.riverware.input,"projects.xlsx",sep=""),row.names=FALSE)
#The following command runs remotely the Riverware Model

 system("cmd.exe", input = "cd  C:\\Users\\L03054557\\AppData\\Local\\Programs\\CADSWES\\RiverWare 7.0.5 \
                           riverware --batch C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\System\\batch_run_protocol.txt")

#wait for output to be printed
  Sys.sleep(10)

#After this command, the output files have been saved in the output folder
#Collect outputs from folder
 SupplyDemand<-read.xlsx2(paste(dir.model,"Output\\supplydemand.xlsx",sep=""), sheetName = "Sheet1")
 ReservoirsData<-read.xlsx2(paste(dir.model,"Output\\reservoirs.xlsx",sep=""), sheetName = "Sheet1")
 GroundwaterData<-read.xlsx2(paste(dir.model,"Output\\groundwater.xlsx",sep=""), sheetName = "Sheet1")

#Post-process outputs
#Change all classes to numeric
 SupplyDemand<-data.frame(sapply(SupplyDemand,function(x){as.numeric(as.character(x))}))
 ReservoirsData<-data.frame(sapply(ReservoirsData,function(x){as.numeric(as.character(x))}))
 GroundwaterData<-data.frame(sapply(GroundwaterData,function(x){as.numeric(as.character(x))}))

#Create time vectors
 months<-rep(1:12,36)[2:432]
 years<-rep(1:36,each=12)[2:432]

#Add time columns
 SupplyDemand$Year<-years
 SupplyDemand$Month<-months
 ReservoirsData$Year<-years
 ReservoirsData$Month<-months
 GroundwaterData$Year<-years
 GroundwaterData$Month<-months
#Add run ids
  SupplyDemand$Run.ID<-Run.ID
  GroundwaterData$Run.ID<-Run.ID
  ReservoirsData$Run.ID<-Run.ID

#write aggregated run outputs
 write.csv(SupplyDemand,paste(dir.exp.out.supplydemand,"out_",Run.ID,".csv",sep=""),row.names=FALSE)
 write.csv(ReservoirsData,paste(dir.exp.out.surface,"out_",Run.ID,".csv",sep=""),row.names=FALSE)
 write.csv(GroundwaterData,paste(dir.exp.out.gw,"out_",Run.ID,".csv",sep=""),row.names=FALSE)
#
return((Run.ID))
 }

#Load required libraries
 library(rJava)
 library(xlsx)

#Load all required directories
 dir.model<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
 dir.exp<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.scenarios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\Scenarios\\"
 dir.riverware.input<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\Input\\"
 dir.exp.out.supplydemand<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\SupplyDemand\\"
 dir.exp.out.surface<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\SurfaceStorage\\"
 dir.exp.out.gw<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\GroundwaterStorage\\"


#Clean output folders
   do.call(file.remove,list(paste(dir.exp.out.supplydemand,list.files(dir.exp.out.supplydemand, pattern="*.csv", full.names=FALSE),sep="")))
   do.call(file.remove,list(paste(dir.exp.out.surface,list.files(dir.exp.out.surface, pattern="*.csv", full.names=FALSE),sep="")))
   do.call(file.remove,list(paste(dir.exp.out.gw,list.files(dir.exp.out.gw, pattern="*.csv", full.names=FALSE),sep="")))

#Load expermental design
  Exp.design<-read.csv(paste(dir.exp,"ExpDesign.csv",sep=""))

#Run experimental design
for (i in 1:nrow(Exp.design))
{
  Run.ID<-i
##Load Demand Scenario Table from Exp Design
  Demand.Scenario.Name<-as.character(Exp.design[Run.ID,"DemandScenario"])
  Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios.csv",sep=""))
  Demand.Scenario<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$Scenario==Demand.Scenario.Name)

#Load Policy Tables from Experimental Design
   Policy.Name<-as.character(Exp.design[Run.ID,"Policy"])
   Policies.Table<-read.csv(paste(dir.scenarios,"PolicyScenarios.csv",sep=""))
   Policy<-subset(Policies.Table,Policies.Table$Policy==Policy.Name)
#Run the model
 mty.riverware.model(Run.ID,dir.model,dir.riverware.input,Demand.Scenario,Policy)
}

#Process experiments results

#Process SupplyDemand
  library(data.table)
  dir.raw.output.supplydemand<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\SupplyDemand\\"
  dir.output<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  filenames <- data.frame(filenames=list.files(dir.raw.output.supplydemand, pattern="*.csv", full.names=FALSE))
  SupplyDemand<-apply(filenames,1,function(x) {read.csv(paste(dir.raw.output.supplydemand,x,sep=""))})
  SupplyDemand<-rbindlist(SupplyDemand)

#Estimate Reliability
  Monthly.Reliability.Threshold<-0.95
  SupplyDemand[,Reliability:=ifelse(Analisis.Oferta.Monterrey>=Monthly.Reliability.Threshold*Analisis.Demanda.Monterrey,1,0)]
#Aggregate at yearly level
  SupplyDemand<-SupplyDemand [, j=list(Supply.Monterrey = mean(Analisis.Oferta.Monterrey),
                                       Demand.Monterrey = mean(Analisis.Demanda.Monterrey),
                                       Reliability = mean(Reliability)),
                                       by= list (Run.ID,Year)]
 #write database
  write.csv(SupplyDemand,paste(dir.output,"SupplyDemand.csv",sep=""),row.names=FALSE)

#Process SurfaceStorage
  dir.raw.output.surfacestorage<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\SurfaceStorage\\"
  filenames <- data.frame(filenames=list.files(dir.raw.output.surfacestorage, pattern="*.csv", full.names=FALSE))
  SStorage<-apply(filenames,1,function(x) {read.csv(paste(dir.raw.output.surfacestorage,x,sep=""))})
  SStorage<-rbindlist(SStorage)
#Estimate Reliability of Sustainable Supply
 #El cuchillo
  SStorage[,El.Cuchillo.Reliability:=ifelse(El.Cuchillo.Diversion>=4.78,1,0)]
 #La Boca
  SStorage[,La.Boca.Reliability:=ifelse(La.Boca.Diversion>=0.81,1,0)]
 #Cerro Prieto
  SStorage[,Cerro.Prieto.Reliability:=ifelse(Cerro.Prieto.Diversion>=3.626,1,0)]
#Aggregate at yearly level
  SStorage<- SStorage[ , lapply(.SD,mean), by = list(Run.ID,Year) ,.SDcols=subset(names(SStorage),!(names(SStorage)%in%c("Run.ID","Year")))]
#write database
  SStorage[,Resource.ID:="Surface.Storage"]
  write.csv(SStorage,paste(dir.output,"SStorage.csv",sep=""),row.names=FALSE)

#Process Groundwater
  dir.raw.output.gwstorage<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\GroundwaterStorage\\"
  filenames <- data.frame(filenames=list.files(dir.raw.output.gwstorage, pattern="*.csv", full.names=FALSE))
  GWStorage<-apply(filenames,1,function(x) {read.csv(paste(dir.raw.output.gwstorage,x,sep=""))})
  GWStorage<-rbindlist(GWStorage)
#Aggregate at yearly level
  GWStorage<- GWStorage[ , lapply(.SD,mean), by = list(Run.ID,Year) ,.SDcols=subset(names(GWStorage),!(names(GWStorage)%in%c("Run.ID","Year")))]
#write database
  GWStorage[,Resource.ID:="Groundwater.Storage"]
  write.csv(GWStorage,paste(dir.output,"GWStorage.csv",sep=""),row.names=FALSE)

#Now aggregate results at run levels

#Supply Demand
  SupplyDemand<-SupplyDemand [, j=list(Supply.Monterrey = mean(Supply.Monterrey),
                                       Demand.Monterrey = mean(Demand.Monterrey),
                                       Reliability = mean(Reliability)),
                                       by= list (Run.ID)]

  write.csv(SupplyDemand,paste(dir.output,"AgregatedSupplyDemand.csv",sep=""),row.names=FALSE)

#Surface Storage
 SStorage<- SStorage[ , lapply(.SD,mean), by = list(Run.ID,Resource.ID) ,.SDcols=subset(names(SStorage),!(names(SStorage)%in%c("Run.ID","Resource.ID")))]
 write.csv(SStorage,paste(dir.output,"AgregatedSStorage.csv",sep=""),row.names=FALSE)


#Groundwater storage
 GWStorage<-GWStorage[ , lapply(.SD,mean), by = list(Run.ID,Resource.ID) ,.SDcols=subset(names(GWStorage),!(names(GWStorage)%in%c("Run.ID","Resource.ID")))]
 write.csv(GWStorage,paste(dir.output,"AgregatedGWStorage.csv",sep=""),row.names=FALSE)
