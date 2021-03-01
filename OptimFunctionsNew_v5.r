portfolio.reliability<-function(x)
{
# "x" is a vector of integer values that represents a selection of projects
#Estimate the effect of the portfolio selected
#Write RCL script to run remotely the Riverware model
RCL.Script<-paste("
#Set environment variables
 set env(MODEL_DIR) C:/Users/L03054557/Edmundo-ITESM/Proyectos/ProjectoAguaMty/Phase2MTY/ModeloRiverware
 SetEnv MODEL_DIR $env(MODEL_DIR)

#Load the model
 OpenWorkspace $env(MODEL_DIR)/System/Modelo_AMM_23_05_2017.mdl

#Load the rules
 LoadRules $env(MODEL_DIR)/System/Rules_AMM_23_05_2017.rls

#Set run dates
 SetRunInfo #RunInfo !InitDate {January, ",ini.yr,"}
 SetRunInfo #RunInfo !EndDate {December, ",end.yr,"}

#Set initial conditions
#surface reservoirs
 SetSlot {La Boca.Storage} {January,",ini.yr,"} 39.4
 SetSlot {La Boca.Pool Elevation} {January,",ini.yr,"} 448.52
 SetSlot {El Cuchillo.Storage} {January,",ini.yr,"} 1123
 SetSlot {El Cuchillo.Pool Elevation} {January,",ini.yr,"} 162.35
 SetSlot {Cerro Prieto.Storage} {January,",ini.yr,"} 300
 SetSlot {Cerro Prieto.Pool Elevation} {January,",ini.yr,"} 282.52
 SetSlot {Marte R Gomez.Storage} {January,",ini.yr,"} 781
 SetSlot {Marte R Gomez.Pool Elevation} {January,",ini.yr,"} 76.30
 SetSlot {Las Blancas.Storage} {January,",ini.yr,"} 83
 SetSlot {Las Blancas.Pool Elevation} {January,",ini.yr,"} 89.86
 SetSlot {Vicente Guerrero.Storage} {January,",ini.yr,"} 820
 SetSlot {Vicente Guerrero.Pool Elevation} {January,",ini.yr,"} 129.09
#groundwater reservoirs
 SetSlot {Campo Mina.Storage} {January,",ini.yr,"} 90
 SetSlot {Pozos Area Metropolitana.Storage} {January,",ini.yr,"} 3.0
 SetSlot {Campo Buenos Aires.Storage} {January,",ini.yr,"} 300
 SetSlot {Sistema Santiago Huajuco.Storage} {January,",ini.yr,"} 250

#Set number of months in simulations
 set mths ",n.months,"\n",
 "SetSlot Analisis.Meses $mths

#input x portfolio into riverware model
  set x1 ",x[1],"\n",
 "set x2 ",x[2],"\n",
 "set x3 ",x[3],"\n",
 "set x4 ",x[4],"\n",
 "set x5 ",x[5],"\n",
 "set x6 ",x[6],"\n",
 "set x7 ",x[7],"\n",
 "set x8 ",x[8],"\n",
 "set x9 ",x[9],"\n",
 "set x10 ",x[10],"\n",
 "set x11 ",x[11],"\n",
 "set x12 ",x[12],"\n",
 "set x13 ",x[13],"

 SetSlot ProjectsTable.x1 $x1
 SetSlot ProjectsTable.x2 $x2
 SetSlot ProjectsTable.x3 $x3
 SetSlot ProjectsTable.x4 $x4
 SetSlot ProjectsTable.x5 $x5
 SetSlot ProjectsTable.x6 $x6
 SetSlot ProjectsTable.x7 $x7
 SetSlot ProjectsTable.x8 $x8
 SetSlot ProjectsTable.x9 $x9
 SetSlot ProjectsTable.x10 $x10
 SetSlot ProjectsTable.x11 $x11
 SetSlot ProjectsTable.x12 $x12
 SetSlot ProjectsTable.x13 $x13

#run Input DMIs
 InvokeDMI DemandScenarioDMI
 InvokeDMI ClimateScenarioDMI

# run the simulation
 StartController

#Print result
 set v [GetSlot Analisis.Confiabilidad]
 puts $v

 set v1 [GetSlot {La Boca.Storage} {January,",end.yr,"}]
 puts $v1

 set v2 [GetSlot {La Boca.Pool Elevation} {January,",end.yr,"}]
 puts $v2

 set v3 [GetSlot {El Cuchillo.Storage} {January,",end.yr,"}]
 puts $v3

 set v4 [GetSlot {El Cuchillo.Pool Elevation} {January,",end.yr,"}]
 puts $v4

 set v5 [GetSlot {Cerro Prieto.Storage} {January,",end.yr,"}]
 puts $v5

 set v6 [GetSlot {Cerro Prieto.Pool Elevation} {January,",end.yr,"}]
 puts $v6

 set v7 [GetSlot {Marte R Gomez.Storage} {January,",end.yr,"}]
 puts $v7

 set v8 [GetSlot {Marte R Gomez.Pool Elevation} {January,",end.yr,"}]
 puts $v8

 set v9 [GetSlot {Las Blancas.Storage} {January,",end.yr,"}]
 puts $v9

 set v10 [GetSlot {Las Blancas.Pool Elevation} {January,",end.yr,"}]
 puts $v10

 set v11 [GetSlot {Vicente Guerrero.Storage} {January,",end.yr,"}]
 puts $v11

 set v12 [GetSlot {Vicente Guerrero.Pool Elevation} {January,",end.yr,"}]
 puts $v12

 set v13 [GetSlot {Campo Mina.Storage} {January,",end.yr,"}]
 puts $v13

 set v14 [GetSlot {Pozos Area Metropolitana.Storage} {January,",end.yr,"}]
 puts $v14

 set v15 [GetSlot {Campo Buenos Aires.Storage} {January,",end.yr,"}]
 puts $v15

 set v16 [GetSlot {Sistema Santiago Huajuco.Storage} {January,",end.yr,"}]
 puts $v16

 GetRunInfo #RunInfo !InitDate
 GetRunInfo #RunInfo !EndDate
# GetRunInfo #RunInfo !Step

# Close the opened model and exit RiverWare
 CloseWorkspace
",sep="")

#to run the following line you need to include in PATH: C:\\Users\\L03054557\\AppData\\Local\\Programs\\CADSWES\\RiverWare 7.0.5
#get a temporary directory
#  dir<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\System"
dir<-tempdir()

#write the RCL script in temporary directory
 writeLines(RCL.Script, paste(dir,"\\","batch_run_protocol_genoud.txt",sep=""))

#Create the system command to run riverware remotely
 command<-paste("riverware --batch ",dir,"\\","batch_run_protocol_genoud.txt --log console",sep="")
#Run the model from R using the system() function
#Note: to run the following line you need to include in PATH: C:\\Users\\L03054557\\AppData\\Local\\Programs\\CADSWES\\RiverWare 7.0.5
 output<-system(command
          ,intern=TRUE
          ,ignore.stdout = FALSE
          ,ignore.stderr = FALSE
          ,wait = TRUE
          ,show.output.on.console = TRUE
          ,minimized = FALSE
          ,invisible = TRUE
          )

#Portfolio Reliability
 Reliability.Annual.Mean<-as.numeric(output[14])/100
 return(Reliability.Annual.Mean)
}

portfolio.eval<-function(x) {
# "x" is a vector of integer values that represents a selection of projects
#Estimate Portfolio Reliability
 Reliability.Annual.Mean<-portfolio.reliability(x)
#Estimate Portfolio Cost
 cost.vector<-Projects_Chars$Investment.Millions
 Portfolio.Cost<-matrix(x,nrow=1,ncol=length(unique(Projects_Chars$ID_Project)))%*%matrix(cost.vector,nrow=length(unique(Projects_Chars$ID_Project)),ncol=1)
if (is.na(Reliability.Annual.Mean)==TRUE)
{
  #write(x,paste(dir.model,"genoud\\portfolio_error.txt",sep=""),sep = "\n")
  return(999999999999)
} else if (Reliability.Annual.Mean>=0.92)
{ return(as.numeric(Portfolio.Cost))
          } else  { return(999999999) }

}

iteration.optim<-function(dir.model,Projects_Chars,Demand.Scenario,Climate.Scenario,Domains,Future.ID,ini.yr,end.yr)
{
#Subset to match initial year and end year
  ini.yr<<-ini.yr
  end.yr<<-end.yr
  run.yrs<-c(ini.yr:end.yr)-2014
  Demand.Scenario<-subset(Demand.Scenario,Demand.Scenario$Year%in%run.yrs)
#Write demand scenario in Riverware input file
  write(Demand.Scenario$Demand.cms,paste(dir.model,"Input\\demandtable.txt",sep=""),sep = "\n")

#Subset to match initial year and end year
  Climate.Scenario<-subset(Climate.Scenario,Climate.Scenario$Year%in%run.yrs)

#Write climate scenario in Riverware input file
  write(Climate.Scenario$Vicente.Guerrero.Inflow,paste(dir.model,"Input\\VicenteGuerreroInflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$La.Boca.Inflow,paste(dir.model,"Input\\LaBocaInflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$Rio.San.Juan.1.Inflow,paste(dir.model,"Input\\RioSanJuan1Inflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$Rio.Panuco.MTY.VI.Inflow,paste(dir.model,"Input\\RioPanucoMTYVIInflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$Rio.Pablillo_Camacho.Inflow,paste(dir.model,"Input\\RioPablillo_CamachoInflow.txt",sep=""),sep = "\n")
#Estimate number of months of simulation
  n.months<<-nrow(Demand.Scenario)-1

if (portfolio.reliability(rep(1,nrow(Projects_Chars)))>0.92)
{
  #Run optmization using multiple cores
    nCore<-8
    cl <- makeSOCKcluster(names = rep('localhost',nCore))
    global.elements<-list( "portfolio.eval",
                           "portfolio.reliability",
                           "dir.model",
                           "Projects_Chars",
                           "Futures.Table",
                           "Demand.Scenarios.Table",
                           "Climate.Scenarios.Table",
                           "n.months",
                           "ini.yr",
                           "end.yr",
                           "Future.ID",
                           "genoud")
   clusterExport(cl,global.elements,envir=environment())
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
                          pop.size=1000,
                          #pop.size=24,
                          Domains=Domains,
                          data.type.int=TRUE,
                          cluster=cl,
                          print.level=0)
                          #print.level=3)
  stopCluster(cl)
} else { optim.portfolio<-list(par=rep(1,nrow(Projects_Chars)),value=83083)}
 return(optim.portfolio)
}

#Run iteration
#one trial run
#for (i in 13:24)
#{
# portfolio<-iteration.optim(dir.model,Projects_Chars,Futures.Table,Demand.Scenarios.Table,Climate.Scenarios.Table,Domains,i)
# options<-portfolio$par
# cost<-portfolio$value
# reliability<-portfolio.reliability(options)
# portfolio<-list(c(options,cost,reliability))
# portfolio<-as.data.frame(do.call("rbind",portfolio))
# colnames(portfolio)<-c(Projects_Chars$ID_Project,"Cost","Reliability")
# portfolio$Future.ID<-Future.ID
# dir.output<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
# write.csv(portfolio,paste(dir.output,"OptimalPorfolios\\future_",Future.ID,".csv",sep=""),row.names=FALSE)
#}

#
#Set up directories
 dir.model<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
 dir.exp<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.scenarios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\Scenarios\\"

#Load libraries
 library(reshape2)
 library(data.table)
 library(rgenoud)
 library(snow)

#Read projects characteristics table
  Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_13_04_2017.csv",sep=""))
  Projects_Chars$ID_Project<-as.character(Projects_Chars$ID_Project)

#Load Futures Table
 Futures.Table<-read.csv(paste(dir.exp,"FuturesTable.csv",sep=""))
#Load Demand Scenarios Table
 Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios.csv",sep=""))
#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios.csv",sep=""))

dynamic.optimizer<-function(dir.input,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,z)
{
#Make parameters global for all the functions within iteration.optim
   dir.model<<-dir.model
   Projects_Chars<<-Projects_Chars
   Futures.Table<<-Futures.Table
   Demand.Scenarios.Table<<-Demand.Scenarios.Table
   Climate.Scenarios.Table<<-Climate.Scenarios.Table
   #Future.ID<<-Future.ID
   Future.ID<<-11
#Input Demand Scenario in Riverware
     Demand.Scenario.Name<-as.character(Futures.Table[Future.ID,"DemandScenario"])
     Demand.Scenario<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$Scenario==Demand.Scenario.Name)
#Input Climate Scenario in Riverware
    Climate.Scenario.Name<-as.character(Futures.Table[Future.ID,"ClimateScenario"])
    Climate.Scenario<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$Scenario==Climate.Scenario.Name)

#first step
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

  Domains<<-matrix(c(x.ini.0,x.fin.0),ncol=2)
  #
 #ini.yr<<-2015
 #end.yr<<-2026
  #
  portfolio1<-iteration.optim(dir.model,Projects_Chars,Demand.Scenario,Climate.Scenario,Domains,Future.ID,2015,2026)
  step1.options<-portfolio1$par
  step1.cost<-portfolio1$value
  step1.reliability<-portfolio.reliability(step1.options,2016,2026)

#second step
 x.fin.1<-c(as.integer(1.0), #x1
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
  Domains<<-matrix(c(step1.options,x.fin.1),ncol=2)
  portfolio2<-iteration.optim(dir.model,Projects_Chars,Futures.Table,Demand.Scenarios.Table,Climate.Scenarios.Table,Domains,i,2016,2026)
  step2.options<-portfolio2$par
  step2.cost<-portfolio2$value
  step2.reliability<-portfolio.reliability(step1.options,2016,2026)

#third step
 x.fin.2<-c(as.integer(1.0), #x1
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

  Domains<<-matrix(c(step2.options,x.fin.2),ncol=2)
  portfolio3<-iteration.optim(dir.model,Projects_Chars,Futures.Table,Demand.Scenarios.Table,Climate.Scenarios.Table,Domains,i,2027,2036)
  step3.options<-portfolio3$par
  step3.cost<-portfolio3$value
  step3.reliability<-portfolio.reliability(step1.options,2037,2050)

#Rbind final solution
  portfolio<-list(c(step1.options,step1.cost,step1.reliability),
                  c(step2.options,step2.cost,step2.reliability),
                  c(step3.options,step3.cost,step3.reliability))
  portfolio<-as.data.frame(do.call("rbind",portfolio))
  colnames(portfolio)<-c(Projects_Chars$ID_Project,"Cost","Reliability")
  portfolio$Periodo<-c("P1","P2","P3")
  portfolio$Future.ID<-Future.ID
#return final value
  dir.output<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  write.csv(portfolio,paste(dir.output,"OptimalPorfolios\\future_",Future.ID,".csv",sep=""),row.names=FALSE)
}
