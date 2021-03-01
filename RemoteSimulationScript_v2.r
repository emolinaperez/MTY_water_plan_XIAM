#This script runs the Master Plan RiverWare Model in batch mode invoking a system command
mty.riverware.model<-function(Run.ID,dir.model,dir.riverware.input,Demand.Scenario,Policy) {
#Write demand scenario in Riverware input file
 write.xlsx2(Demand.Scenario, file=paste(dir.riverware.input,"demandtable.xlsx",sep=""),row.names=FALSE)
#Write demand scenario in Riverware input file
 write.xlsx2(Policy, file=paste(dir.riverware.input,"projects.xlsx",sep=""),row.names=FALSE)
#The following command runs remotely the Riverware Model

 system("cmd.exe", input = "cd  C:\\Users\\L03054557\\AppData\\Local\\Programs\\CADSWES\\RiverWare 7.0.5 \
                           riverware --batch C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\System\\batch_run_protocol.txt --log C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\System\\log.txt")

#wait for output to be printed
  Sys.sleep(5)

#After this command, the output files have been saved in the output folder
#Collect outputs from folder
 SupplyDemand<-read.csv(paste(dir.model,"Output\\supplydemand.csv",sep=""))
 ReservoirsData<-read.csv(paste(dir.model,"Output\\reservoirs.csv",sep=""))
 GroundwaterData<-read.csv(paste(dir.model,"Output\\groundwater.csv",sep=""))

#extract year and months
 SupplyDemand$Year<-as.numeric(substr(as.character(SupplyDemand$Timestep),7,10))-2014
 SupplyDemand$Month<-as.numeric(substr(as.character(SupplyDemand$Timestep),1,2))
 ReservoirsData$Year<-as.numeric(substr(as.character(ReservoirsData$Timestep),7,10))-2014
 ReservoirsData$Month<-as.numeric(substr(as.character(ReservoirsData$Timestep),1,2))
 GroundwaterData$Year<-as.numeric(substr(as.character(GroundwaterData$Timestep),7,10))-2014
 GroundwaterData$Month<-as.numeric(substr(as.character(GroundwaterData$Timestep),1,2))

#Post-process outputs
 SupplyDemand<-dcast(SupplyDemand, Year+Month ~ Object.Slot, value.var="Slot.Value")
 ReservoirsData<-dcast(ReservoirsData, Year+Month ~ Object.Slot, value.var="Slot.Value")
 GroundwaterData<-dcast(GroundwaterData, Year+Month ~ Object.Slot, value.var="Slot.Value")

#Add run ids
  SupplyDemand$Run.ID<-Run.ID
  GroundwaterData$Run.ID<-Run.ID
  ReservoirsData$Run.ID<-Run.ID

#write aggregated run outputs
 write.csv(SupplyDemand,paste(dir.exp.out.supplydemand,"out_",Run.ID,".csv",sep=""),row.names=FALSE)
 write.csv(ReservoirsData,paste(dir.exp.out.surface,"out_",Run.ID,".csv",sep=""),row.names=FALSE)
 write.csv(GroundwaterData,paste(dir.exp.out.gw,"out_",Run.ID,".csv",sep=""),row.names=FALSE)
#eliminate output files
 do.call(file.remove,list(paste(paste(dir.model,"Output\\",sep=""),list.files(paste(dir.model,"Output\\",sep=""), pattern="*.csv", full.names=FALSE),sep="")))

#end process printing Run.ID
return((Run.ID))
 }

#Load required libraries
 library(rJava)
 library(xlsx)
 library(data.table)

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
 dim(Exp.design)

#Run experimental design
for (i in 1:nrow(Exp.design))
{
  Run.ID<-11
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
#Add future ids with cost data
  Exp.design<-read.csv(paste(dir.exp,"ExpDesign.csv",sep=""))[,c("Run.ID","Future.ID","Policy")]
  Policies<-read.csv(paste(dir.scenarios,"PolicyScenarios.csv",sep=""))[,c("Policy","Cost")]
  Exp.design<-merge(Exp.design,Policies,by="Policy")
  SupplyDemand<-merge(SupplyDemand,Exp.design,by="Run.ID")
#load optimal portfolios
  OptimalPortfolios<-read.csv(paste(dir.output,"OptimalPortfolios.csv",sep=""))[,c("Best.Cost","Best.Reliability","Future.ID")]
#merge with SupplyDemand
  SupplyDemand<-merge(SupplyDemand,OptimalPortfolios,by="Future.ID")
  SupplyDemand[,Cost.Regret:=ifelse(Cost-Best.Cost<0,0,Cost-Best.Cost)]
  SupplyDemand[,Reliability.Regret:=ifelse(Best.Reliability-Reliability<0,0,Best.Reliability-Reliability)]
#Delete duplicated rows
  SupplyDemand[,Policy:=NULL]
  SupplyDemand[,Future.ID:=NULL]

#print results
  write.csv(SupplyDemand,paste(dir.output,"AgregatedSupplyDemand.csv",sep=""),row.names=FALSE)

#Surface Storage
 SStorage<- SStorage[ , lapply(.SD,mean), by = list(Run.ID,Resource.ID) ,.SDcols=subset(names(SStorage),!(names(SStorage)%in%c("Run.ID","Resource.ID")))]
 write.csv(SStorage,paste(dir.output,"AgregatedSStorage.csv",sep=""),row.names=FALSE)


#Groundwater storage
 GWStorage<-GWStorage[ , lapply(.SD,mean), by = list(Run.ID,Resource.ID) ,.SDcols=subset(names(GWStorage),!(names(GWStorage)%in%c("Run.ID","Resource.ID")))]
 write.csv(GWStorage,paste(dir.output,"AgregatedGWStorage.csv",sep=""),row.names=FALSE)
