portfolio.reliability<-function(x)
{
# "x" is a vector of integer values that represents a selection of projects
#Input portfolio of projects in Riverware
 projects<-data.frame(x1=x[1],
                      x2=x[2],
                      x3=x[3],
                      x4=x[4],
                      x5=x[5],
                      x6=x[6],
                      x7=x[7],
                      x8=x[8],
                      x9=x[9],
                      x10=x[10],
                      x11=x[11],
                      x12=x[12],
                      x13=x[13])
 write.xlsx2(projects, file=paste(dir.model,"Input\\projects.xlsx",sep=""),row.names=FALSE)

#Input Demand Scenario in Riverware
  Demand.Scenario.Name<-as.character(Futures.Table[Future.ID,"DemandScenario"])
  Demand.Scenario<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$Scenario==Demand.Scenario.Name)
#Write demand scenario in Riverware input file
  write.xlsx2(Demand.Scenario, file=paste(dir.model,"Input\\demandtable.xlsx",sep=""),row.names=FALSE)
#
#Input Climate Scenario in Riverware
 Climate.Scenario.Name<-as.character(Futures.Table[Future.ID,"ClimateScenario"])
 Climate.Scenario<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$Scenario==Climate.Scenario.Name)
#Write climate scenario in Riverware input file
 write.xlsx2(Climate.Scenario, file=paste(dir.model,"Input\\RiversData.xlsx",sep=""),row.names=FALSE)

#Estimate the effect of the portfolio selected
#Run remotely the Riverware Model
 system("cmd.exe", input = "cd  C:\\Users\\L03054557\\AppData\\Local\\Programs\\CADSWES\\RiverWare 7.0.5 \
                          riverware --batch C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\System\\batch_run_protocol_optim.txt --log C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\System\\log3.txt")

 test<-system("cmd.exe", input = "cd  C:\\Users\\L03054557\\AppData\\Local\\Programs\\CADSWES\\RiverWare 7.0.5 \
                          riverware --batch C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\System\\batch_run_protocol_optim.txt --log console",
                          intern=TRUE)


#wait for files to be printed in output directory
  Sys.sleep(10)

#After this command, the output files have been saved in the output folder
#Read output files
 SupplyDemand<-read.csv(paste(dir.model,"Output\\supplydemand.csv",sep=""))
 SupplyDemand$Year<-as.numeric(substr(as.character(SupplyDemand$Timestep),7,10))-2014
 SupplyDemand$Month<-as.numeric(substr(as.character(SupplyDemand$Timestep),1,2))

#Post-process outputs
 SupplyDemand<-dcast(SupplyDemand, Year+Month ~ Object.Slot, value.var="Slot.Value")

#Estimate reliability of portfolio
 Monthly.Reliability.Threshold<-0.95
 SupplyDemand$Reliability<-as.numeric(ifelse(SupplyDemand[,"Analisis.Oferta Monterrey"]>=SupplyDemand[,"Analisis.Demanda Monterrey"]*Monthly.Reliability.Threshold,1,0))

#Estimate Portfolio Reliability
 Reliability.Annual.Mean<-mean(aggregate(SupplyDemand[,c("Reliability")],by=list(Year=SupplyDemand$Year),mean)[,2])

#Eliminate output files
  do.call(file.remove,list(paste(paste(dir.model,"Output\\",sep=""),list.files(paste(dir.model,"Output\\",sep=""), pattern="*.csv", full.names=FALSE),sep="")))
#Elimianate projects file
  file.remove(file=paste(dir.model,"Input\\projects.xlsx",sep=""))
 return(Reliability.Annual.Mean)
}

portfolio.eval<-function(x) {
# "x" is a vector of integer values that represents a selection of projects
#Estimate Portfolio Reliability
 Reliability.Annual.Mean<-portfolio.reliability(x)
#Estimate Portfolio Cost
 cost.vector<-Projects_Chars$Investment.Millions
 Portfolio.Cost<-matrix(x,nrow=1,ncol=length(unique(Projects_Chars$ID_Project)))%*%matrix(cost.vector,nrow=length(unique(Projects_Chars$ID_Project)),ncol=1)

if (Reliability.Annual.Mean>=0.92)
{
  return(as.numeric(Portfolio.Cost))

} else { 999999999}

}

iteration.optim<-function(dir.model,Projects_Chars,Futures.Table,Demand.Scenarios.Table,Climate.Scenarios.Table,Domains,Future.ID)
{
#Make parameters global for all the functions within iteration.optim
 dir.model<<-dir.model
 Projects_Chars<<-Projects_Chars
 Futures.Table<<-Futures.Table
 Demand.Scenarios.Table<<-Demand.Scenarios.Table
 Climate.Scenarios.Table<<-Climate.Scenarios.Table
 Domains<<-Domains
 Future.ID<<-Future.ID
if (portfolio.reliability(rep(1,nrow(Projects_Chars)))>0.92)
{
#optimize
  optim.portfolio<-genoud(portfolio.eval,
                          nvars=length(unique(Projects_Chars$ID_Project)),
                          starting.values=c(0, #x1
                                            0, #x2
                                            0, #x3
                                            1.0, #x4
                                            0, #x5
                                            0, #x6
                                            1.0, #x7
                                            1.0, #x8
                                            0, #x9
                                            1.0, #x10
                                            1.0, #x11
                                            1.0, #x12
                                            1.0), #x13
                          pop.size=20,
                          Domains=Domains,
                          data.type.int=TRUE)

} else { optim.portfolio<-list(par=rep(1,nrow(Projects_Chars)),value=83083)}
}


#Set up directories
 dir.model<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
 dir.exp<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.scenarios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\Scenarios\\"

#Load libraries
 library(reshape2)
 library(data.table)
 library(rgenoud)
 library(rJava)
 library(xlsx)

#Read projects characteristics table
  Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_13_04_2017.csv",sep=""))
  Projects_Chars$ID_Project<-as.character(Projects_Chars$ID_Project)

#Define Optimization Domains
  x.ini.0<-rep(0,length(unique(Projects_Chars$ID_Project)))
  x.fin.0<-c(as.integer(1.0), #x1
             as.integer(1.0), #x2
             as.integer(1.0), #x3
             as.integer(1.0), #x4
             as.integer(1.0), #x5
             as.integer(1.0), #x6
             as.integer(1.0), #x7
             as.integer(1.0), #x8
             as.integer(1.0), #x9
             as.integer(1.0), #x10
             as.integer(1.0), #x11
             as.integer(1.0), #x12
             as.integer(1.0)) #x13

  Domains<-matrix(c(x.ini.0,x.fin.0),ncol=2)
#Load Futures Table
 Futures.Table<-read.csv(paste(dir.exp,"FuturesTable.csv",sep=""))
#Load Demand Scenarios Table
 Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios.csv",sep=""))
#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios.csv",sep=""))

#Run iteration
#one trial run
for (i in 1:11)
{
 portfolio<-iteration.optim(dir.model,Projects_Chars,Futures.Table,Demand.Scenarios.Table,Climate.Scenarios.Table,Domains,i)
 options<-portfolio$par
 cost<-portfolio$value
 reliability<-portfolio.reliability(options)
 portfolio<-list(c(options,cost,reliability))
 portfolio<-as.data.frame(do.call("rbind",portfolio))
 colnames(portfolio)<-c(Projects_Chars$ID_Project,"Cost","Reliability")
 portfolio$Future.ID<-Future.ID
 dir.output<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 write.csv(portfolio,paste(dir.output,"OptimalPorfolios\\future_",Future.ID,".csv",sep=""),row.names=FALSE)
}

#portfolio.all<-apply(Futures.Table,1,function(x){
#             portfolio<-iteration.optim(dir.model,Projects_Chars,Futures.Table,Demand.Scenarios.Table,Domains,as.numeric(x["Future.ID"]));
#             options<-portfolio$par;
#             cost<-portfolio$value;
#             reliability<-portfolio.reliability(options);
#             portfolio<-list(c(options,cost,reliability));
#             portfolio<-as.data.frame(do.call("rbind",portfolio));
#             colnames(portfolio)<-c(Projects_Chars$ID_Project,"Cost","Reliability");
#             portfolio$Future.ID<-Future.ID
#             return(portfolio)
#            })


portfolio.all<-rbindlist(portfolio.all)
colnames(portfolio.all)<-c("Panuco", #x1
                            "VicenteGuerrero", #x2
                            "Desalination", #x3
                            "Cuchillo", #x4
                            "Sist.Jaumave-El.Brinco", #x5
                            "Pozos.Ballesteros.Buenos.Aires", #x6
                            "Pozo.En.el.Obispado", #x7
                            "Campo.de.Pozos.El.Pajonal", #x8
                            "Subalveo.LaUnion", #x9
                            "Subalveo.RioConchos", #x10
                            "Subalveo.RioPilonChapotal", #x11
                            "TunelSanFranciscoII", #x12
                            "Pozos.MTYI.Contry", #x13
                            "Best.Cost","Best.Reliability","Future.ID")

#change layout of table
 #test<-melt(portfolio.all, id.vars=c("Best.Cost","Best.Reliability","Future.ID"),measure.vars=c("Panuco","VicenteGuerrero","Desalination"),  variable.name="Project.Names")

#Print optimal portfolios table
 dir.output<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 write.csv(portfolio.all,paste(dir.output,"OptimalPortfolios.csv",sep=""),row.names=FALSE)

 x<-c(                   1, #x1
                         1, #x2
                         1, #x3
                         0, #x4
                         1, #x5
                         0, #x6
                         1, #x7
                         1, #x8
                         1, #x9
                         0, #x10
                         0, #x11
                         0, #x12
                         0) #x13
#
portfolio.reliability(x)
cost.vector<-Projects_Chars$Investment.Millions
Portfolio.Cost<-matrix(x,nrow=1,ncol=length(unique(Projects_Chars$ID_Project)))%*%matrix(cost.vector,nrow=length(unique(Projects_Chars$ID_Project)),ncol=1)
