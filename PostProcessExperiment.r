######################################################
#Check cerro prieto, el cuchillo y la boca
#After this command, the output files have been saved in the output folder
#Collect outputs from folder
  ReservoirsData<-read.csv(paste(dir.model,"Output\\reservoirs.csv",sep=""))
#extract year and months
  ReservoirsData$Year<-as.numeric(substr(as.character(ReservoirsData$Timestep),7,10))-2014
  ReservoirsData$Month<-as.numeric(substr(as.character(ReservoirsData$Timestep),1,2))
#Post-process outputs
  ReservoirsData<-dcast(ReservoirsData, Year+Month ~ Object.Slot, value.var="Slot.Value")
  ReservoirsData$Cerro.Prieto.Diversion<-ReservoirsData[,"Cerro Prieto.Diversion"]
  ReservoirsData$El.Cuchillo.Diversion<-ReservoirsData[,"El Cuchillo.Diversion"]
  ReservoirsData$La.Boca.Diversion<-ReservoirsData[,"La Boca.Diversion"]
  SStorage<-data.table(ReservoirsData)

#El cuchillo
 SStorage[,El.Cuchillo.Reliability:=ifelse(El.Cuchillo.Diversion>=4.78,1,0)]
#La Boca
 SStorage[,La.Boca.Reliability:=ifelse(La.Boca.Diversion>=0.81,1,0)]
#Cerro Prieto
 SStorage[,Cerro.Prieto.Reliability:=ifelse(Cerro.Prieto.Diversion>=3.62,1,0)]
#
 i.yr<-26
 e.yr<-36

#Cerro Prieto
 mean(subset(SStorage$Cerro.Prieto.Reliability,SStorage$Year%in%c(i.yr:e.yr)))
#La Boca
 mean(subset(SStorage$La.Boca.Reliability,SStorage$Year%in%c(i.yr:e.yr)))
#El cuchillo
 mean(subset(SStorage$El.Cuchillo.Reliability,SStorage$Year%in%c(i.yr:e.yr)))
