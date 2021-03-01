portfolio.reliability<-function(x,All.Output=FALSE)
{
# "x" is a vector of integer values that represents a selection of project
#x<-c(1, #x1
#     1, #x2
#     1, #x3
#     1, #x4
#     1, #x5
#     1, #x6
#     1, #x7
#     1, #x8
#     1, #x9
#     1, #x10
#     1, #x11
#     1, #x12
#     1, #x13
#     1) #x14

RCL.Script<-paste("
#Set environment variables
 set env(MODEL_DIR) C:/Users/L03054557/Edmundo-ITESM/Proyectos/ProjectoAguaMty/Phase2MTY/ModeloRiverware
 SetEnv MODEL_DIR $env(MODEL_DIR)

#Load the model
 OpenWorkspace $env(MODEL_DIR)/System/Modelo_AMM_30_05_2017.mdl

#Load the rules
 LoadRules $env(MODEL_DIR)/System/Rules_AMM_30_05_2017.rls

#Set run dates
 SetRunInfo #RunInfo !InitDate {January, ",ini.yr,"}
 SetRunInfo #RunInfo !EndDate {December, ",end.yr,"}

#Set initial conditions
#surface reservoirs
 SetSlot {La Boca.Storage} {January,",ini.yr,"} ",LaBoca.Storage.Ini,"
 SetSlot {La Boca.Pool Elevation} {January,",ini.yr,"} ",LaBoca.PoolElevation.Ini,"
 SetSlot {El Cuchillo.Storage} {January,",ini.yr,"} ",ElCuchillo.Storage.Ini,"
 SetSlot {El Cuchillo.Pool Elevation} {January,",ini.yr,"} ",ElCuchillo.PoolElevation.Ini,"
 SetSlot {Cerro Prieto.Storage} {January,",ini.yr,"} ",CerroPrieto.Storage.Ini,"
 SetSlot {Cerro Prieto.Pool Elevation} {January,",ini.yr,"} ",CerroPrieto.PoolElevation.Ini,"
 SetSlot {Marte R Gomez.Storage} {January,",ini.yr,"} ",MarteRGomez.Storage.Ini,"
 SetSlot {Marte R Gomez.Pool Elevation} {January,",ini.yr,"} ",MarteRGomez.PoolElevation.Ini,"
 SetSlot {Las Blancas.Storage} {January,",ini.yr,"} ",LasBlancas.Storage.Ini,"
 SetSlot {Las Blancas.Pool Elevation} {January,",ini.yr,"} ",LasBlancas.PoolElevation.Ini,"
 SetSlot {Vicente Guerrero.Storage} {January,",ini.yr,"} ",VicenteGuerrero.Storage.Ini,"
 SetSlot {Vicente Guerrero.Pool Elevation} {January,",ini.yr,"} ",VicenteGuerrero.PoolElevation.Ini,"
#groundwater reservoirs
 SetSlot {Campo Mina.Storage} {January,",ini.yr,"} ",CampoMina.Storage.Ini,"
 SetSlot {Pozos Area Metropolitana.Storage} {January,",ini.yr,"} ",PozosAreaMetropolitana.Storage.Ini,"
 SetSlot {Campo Buenos Aires.Storage} {January,",ini.yr,"} ",CampoBuenosAires.Storage.Ini,"
 SetSlot {Sistema Santiago Huajuco.Storage} {January,",ini.yr,"} ",SistemaSantiagoHuajuco.Storage.Ini,"
#others
 SetSlot {Cerro Prieto.Diversion Capacity} 3.62
 SetSlot {La Boca.Diversion Capacity}  0.92
 SetSlot {El Cuchillo.Diversion Capacity} 4.78

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
 "set x13 ",x[13],"\n",
 "set x14 ",x[14],"

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
 SetSlot ProjectsTable.x14 $x14

#run Input DMIs
 InvokeDMI ParametersDMI
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
 #dir<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\System"
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
if (All.Output==FALSE) {
 Reliability.Annual.Mean<-as.numeric(output[14])/100
 return(Reliability.Annual.Mean)
 } else {return(output)}
}


portfolio.eval<-function(x) {
# "x" is a vector of integer values that represents a selection of projects
#Estimate Portfolio Reliability
 Reliability.Annual.Mean<-mean(c(historic.reliability,portfolio.reliability(x)))
# Reliability.Annual.Mean<-portfolio.reliability(x)
#Estimate Portfolio Cost
 cost.vector<-Projects_Chars$Investment.Millions
 Portfolio.Cost<-matrix(x,nrow=1,ncol=length(unique(Projects_Chars$ID_Project)))%*%matrix(cost.vector,nrow=length(unique(Projects_Chars$ID_Project)),ncol=1)
if (is.na(Reliability.Annual.Mean)==TRUE)
{
  #write(x,paste(dir.model,"genoud\\portfolio_error.txt",sep=""),sep = "\n")
  return(999999999)
} else if (Reliability.Annual.Mean>=0.965)
{ return(as.numeric(Portfolio.Cost))
          } else  { return(999999999) }

}

iteration.optim<-function(dir.model,Projects_Chars,Domains,historic.reliability,ini.yr,end.yr)
{
#Make simulation years global parameters
#  ini.yr<<-2039
#  end.yr<<-2050
  ini.yr<<-ini.yr
  end.yr<<-end.yr
#Estimate number of months of simulation
  n.months<<-(end.yr-ini.yr+1)*12-1
#
 historic.reliability<<-historic.reliability

#Estimate the relibility reference measures
 Do.Nothing.Reliability<-mean(c(historic.reliability,portfolio.reliability(rep(0,nrow(Projects_Chars)))))
 Do.Previous.Reliability<-mean(c(historic.reliability,portfolio.reliability(Domains[,1])))
 Do.All.Reliability<-mean(c(historic.reliability,portfolio.reliability(rep(1,nrow(Projects_Chars)))))

if (sum(Domains[,1])==0 & Do.Nothing.Reliability>=0.965) #the algo can choose to do nothing only if it has done nothing in the previous period
{

 optim.portfolio<-list(par=rep(0,nrow(Projects_Chars)),value=0)

} else if (Do.Previous.Reliability>=0.965) #if you meet the reliability constraint with the projects in place, then do nothing
{

 optim.portfolio<-list(par=Domains[,1],value=portfolio.eval(Domains[,1]))

} else if (Do.All.Reliability>0.965) #only optimize if there is a combination of projects that can help you meet the reliability constraint
{
#Run optmization using multiple cores
    nCore<-8
    cl <- makeSOCKcluster(names = rep('localhost',nCore))
    global.elements<-list( "portfolio.eval",
                           "portfolio.reliability",
                           "dir.model",
                           "Projects_Chars",
                           "n.months",
                           "ini.yr",
                           "end.yr",
                           "Future.ID",
                           "genoud",
                           "LaBoca.Storage.Ini",
                           "LaBoca.PoolElevation.Ini",
                           "ElCuchillo.Storage.Ini",
                           "ElCuchillo.PoolElevation.Ini",
                           "CerroPrieto.Storage.Ini",
                           "CerroPrieto.PoolElevation.Ini",
                           "MarteRGomez.Storage.Ini",
                           "MarteRGomez.PoolElevation.Ini",
                           "LasBlancas.Storage.Ini",
                           "LasBlancas.PoolElevation.Ini",
                           "VicenteGuerrero.Storage.Ini",
                           "VicenteGuerrero.PoolElevation.Ini",
                           "CampoMina.Storage.Ini",
                           "PozosAreaMetropolitana.Storage.Ini",
                           "CampoBuenosAires.Storage.Ini",
                           "SistemaSantiagoHuajuco.Storage.Ini",
                           "historic.reliability")

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
                                            1.0, #x13
                                            1.0), #x14
                          pop.size=3000,
                          Domains=Domains,
                          data.type.int=TRUE,
                          cluster=cl,
                          print.level=0)
  stopCluster(cl)
} else { optim.portfolio<-list(par=rep(1,nrow(Projects_Chars)),value=86283)}
 return(optim.portfolio)
}


dynamic.optimizer<-function(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,Projects_Chars,Future.ID)
{
#Make parameters global for all the functions within iteration.optim
   dir.model<<-dir.model
   Projects_Chars<<-Projects_Chars
   Future.ID<<-Future.ID
   #Future.ID<-12
#Input Demand Scenario in Riverware
     Demand.Scenario.Name<-as.character(Futures.Table[Future.ID,"DemandScenario"])
     Demand.Scenario<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$Scenario==Demand.Scenario.Name)
#Input Climate Scenario in Riverware
     Climate.Scenario.Name<-as.character(Futures.Table[Future.ID,"ClimateScenario"])
     Climate.Scenario<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$Scenario==Climate.Scenario.Name)

#Create inputs for constant parameters
  Parameters<-read.csv(paste(dir.model,"Input\\ParametersTable.csv",sep=""))
#Write files
 write(Parameters$CerroPrieto.EvaporationRate,paste(dir.model,"Input\\CerroPrieto.EvaporationRate.txt",sep=""),sep = "\n")
 write(Parameters$Riego.FractionalReturnFlow,paste(dir.model,"Input\\Riego.FractionalReturnFlow.txt",sep=""),sep = "\n")
 write(Parameters$CerroPrieto.Release,paste(dir.model,"Input\\CerroPrieto.Release.txt",sep=""),sep = "\n")
 write(Parameters$LaBoca.Release,paste(dir.model,"Input\\LaBoca.Release.txt",sep=""),sep = "\n")
 write(Parameters$LaBoca.Evaporation,paste(dir.model,"Input\\LaBoca.Evaporation.txt",sep=""),sep = "\n")
 write(Parameters$PozosAreaMetropolitana.Percolation,paste(dir.model,"Input\\PozosAreaMetropolitana.Percolation.txt",sep=""),sep = "\n")
 write(Parameters$AreaMetropolitanadeMonterrey.FractionalReturnFlow,paste(dir.model,"Input\\AreaMetropolitanadeMonterrey.FractionalReturnFlow.txt",sep=""),sep = "\n")
 write(Parameters$AreaMetropolitanadeMonterrey.AvailableSupplementalWater,paste(dir.model,"Input\\AreaMetropolitanadeMonterrey.AvailableSupplementalWater.txt",sep=""),sep = "\n")
 write(Parameters$DR031.FractionalReturnFlow,paste(dir.model,"Input\\DR031.FractionalReturnFlow.txt",sep=""),sep = "\n")
 write(Parameters$DR031.Diversion,paste(dir.model,"Input\\DR031.Diversion.txt",sep=""),sep = "\n")
 write(Parameters$ElCuchillo.EvaporationRate,paste(dir.model,"Input\\ElCuchillo.EvaporationRate.txt",sep=""),sep = "\n")
 write(Parameters$AcueductoRegionalChinaAldama.FractionalReturnFlow,paste(dir.model,"Input\\AcueductoRegionalChinaAldama.FractionalReturnFlow.txt",sep=""),sep = "\n")
 write(Parameters$AcueductoRegionalChinaAldama.Diversion,paste(dir.model,"Input\\AcueductoRegionalChinaAldama.Diversion.txt",sep=""),sep = "\n")
 write(Parameters$DR026.Diversion,paste(dir.model,"Input\\DR026.Diversion.txt",sep=""),sep = "\n")
 write(Parameters$DR026.FractionalReturnFlow,paste(dir.model,"Input\\DR026.FractionalReturnFlow.txt",sep=""),sep = "\n")

#Write demand scenario in Riverware input file
  write(Demand.Scenario$Demand.cms,paste(dir.model,"Input\\demandtable.txt",sep=""),sep = "\n")

#Write climate scenario in Riverware input file
  write(Climate.Scenario$Vicente.Guerrero.Inflow,paste(dir.model,"Input\\VicenteGuerreroInflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$La.Boca.Inflow,paste(dir.model,"Input\\LaBocaInflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$Rio.San.Juan.1.Inflow,paste(dir.model,"Input\\RioSanJuan1Inflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$Rio.Panuco.MTY.VI.Inflow,paste(dir.model,"Input\\RioPanucoMTYVIInflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$Rio.Pablillo_Camacho.Inflow,paste(dir.model,"Input\\RioPablillo_CamachoInflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$La.Libertad.Inflow,paste(dir.model,"Input\\LaLibertad_Inflow.txt",sep=""),sep = "\n")
  write(Climate.Scenario$Pesqueria.Inflow,paste(dir.model,"Input\\Pesqueria_Inflow.txt",sep=""),sep = "\n")


#first step
#Set initial condition
  LaBoca.Storage.Ini<<-39.4
  LaBoca.PoolElevation.Ini<<-448.52
  ElCuchillo.Storage.Ini<<-1123
  ElCuchillo.PoolElevation.Ini<<-162.35
  CerroPrieto.Storage.Ini<<-300
  CerroPrieto.PoolElevation.Ini<<-282.52
  MarteRGomez.Storage.Ini<<-781
  MarteRGomez.PoolElevation.Ini<<-76.30
  LasBlancas.Storage.Ini<<-83
  LasBlancas.PoolElevation.Ini<<-89.86
  VicenteGuerrero.Storage.Ini<<-820
  VicenteGuerrero.PoolElevation.Ini<<-129.09
  CampoMina.Storage.Ini<<-90
  PozosAreaMetropolitana.Storage.Ini<<-3.0
  CampoBuenosAires.Storage.Ini<<-300
  SistemaSantiagoHuajuco.Storage.Ini<<-250

#Domains
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
             as.integer(1.0), #x13
             as.integer(1.0)) #x14

  Domains<<-matrix(c(x.ini.0,x.fin.0),ncol=2)
  historic.reliability<-NULL
  portfolio1<-iteration.optim(dir.model,Projects_Chars,Domains,historic.reliability,2015,2026)
  step1.options<-portfolio1$par
  step1.cost<-portfolio1$value
  step1.values<-portfolio.reliability(step1.options,All.Output=TRUE)
  step1.reliability<-as.numeric(step1.values[14])/100
  historic.reliability<-step1.reliability

#Set initial conditions for next step
  LaBoca.Storage.Ini<<-as.numeric(step1.values[15])
  LaBoca.PoolElevation.Ini<<-as.numeric(step1.values[16])
  ElCuchillo.Storage.Ini<<-as.numeric(step1.values[17])
  ElCuchillo.PoolElevation.Ini<<-as.numeric(step1.values[18])
  CerroPrieto.Storage.Ini<<-as.numeric(step1.values[19])
  CerroPrieto.PoolElevation.Ini<<-as.numeric(step1.values[20])
  MarteRGomez.Storage.Ini<<-as.numeric(step1.values[21])
  MarteRGomez.PoolElevation.Ini<<-as.numeric(step1.values[22])
  LasBlancas.Storage.Ini<<-83
  LasBlancas.PoolElevation.Ini<<-89.86
  VicenteGuerrero.Storage.Ini<<-as.numeric(step1.values[25])
  VicenteGuerrero.PoolElevation.Ini<<-as.numeric(step1.values[26])
  CampoMina.Storage.Ini<<- as.numeric(step1.values[27])
  PozosAreaMetropolitana.Storage.Ini<<-as.numeric(step1.values[28])
  CampoBuenosAires.Storage.Ini<<-as.numeric(step1.values[29])
  SistemaSantiagoHuajuco.Storage.Ini<<-as.numeric(step1.values[30])

#Set domains for second step
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
            as.integer(1.0), #x13
            as.integer(1.0)) #x14

  Domains<<-matrix(c(step1.options,x.fin.1),ncol=2)

#Solve for second step
  portfolio2<-iteration.optim(dir.model,Projects_Chars,Domains,historic.reliability,2027,2038)
  step2.options<-portfolio2$par
  step2.cost<-portfolio2$value
  step2.values<-portfolio.reliability(step2.options,All.Output=TRUE)
  step2.reliability<-as.numeric(step2.values[14])/100
  historic.reliability<-mean(c(step1.reliability,step2.reliability))

#Set initial conditions for next step
  LaBoca.Storage.Ini<<-as.numeric(step2.values[15])
  LaBoca.PoolElevation.Ini<<-as.numeric(step2.values[16])
  ElCuchillo.Storage.Ini<<-as.numeric(step2.values[17])
  ElCuchillo.PoolElevation.Ini<<-as.numeric(step2.values[18])
  CerroPrieto.Storage.Ini<<-as.numeric(step2.values[19])
  CerroPrieto.PoolElevation.Ini<<-as.numeric(step2.values[20])
  MarteRGomez.Storage.Ini<<-as.numeric(step2.values[21])
  MarteRGomez.PoolElevation.Ini<<-as.numeric(step2.values[22])
  LasBlancas.Storage.Ini<<-83 #Note: las blancas does not have any effect in the system, this value is meaningless just there for legacy
  LasBlancas.PoolElevation.Ini<<-89.86
  VicenteGuerrero.Storage.Ini<<-as.numeric(step2.values[25])
  VicenteGuerrero.PoolElevation.Ini<<-as.numeric(step2.values[26])
  CampoMina.Storage.Ini<<- as.numeric(step2.values[27])
  PozosAreaMetropolitana.Storage.Ini<<-as.numeric(step2.values[28])
  CampoBuenosAires.Storage.Ini<<-as.numeric(step2.values[29])
  SistemaSantiagoHuajuco.Storage.Ini<<-as.numeric(step2.values[30])

#Set Domains for third step
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
            as.integer(1.0), #x13
            as.integer(1.0)) #x14

  Domains<<-matrix(c(step2.options,x.fin.2),ncol=2)
#
#Solve for third step
  portfolio3<-iteration.optim(dir.model,Projects_Chars,Domains,historic.reliability,2039,2050)
  step3.options<-portfolio3$par
  step3.cost<-portfolio3$value
  step3.values<-portfolio.reliability(step3.options,All.Output=TRUE)
  step3.reliability<-as.numeric(step3.values[14])/100

#Rbind final solution
  portfolio<-list(c(step1.options,step1.cost,step1.reliability),
                  c(step2.options,step2.cost,step2.reliability),
                  c(step3.options,step3.cost,step3.reliability))
  portfolio<-as.data.frame(do.call("rbind",portfolio))
  colnames(portfolio)<-c(Projects_Chars$ID_Project,"Cost","Reliability")
  portfolio$Periodo<-c("P1","P2","P3")
  portfolio$Future.ID<-Future.ID
#write result
  write.csv(portfolio,paste(dir.output,"DynamicOptimalPortfolios\\future_",Future.ID,".csv",sep=""),row.names=FALSE)
#return final value
 return(portfolio)
}

#
#Set up directories
 dir.model<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
 dir.output<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
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


for (i in 1:nrow(Futures.Table))
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,Projects_Chars,i)
 }

#Put all files into a single table
 filenames <- list.files(paste(dir.output,"DynamicOptimalPortfolios\\backup\\",sep=""), pattern="*.csv", full.names=FALSE)
 OptimalPortfolios<-lapply(filenames, function (x) {read.csv(paste(dir.output,"DynamicOptimalPortfolios\\backup\\",x,sep=""))})
 OptimalPortfolios<-do.call("rbind",OptimalPortfolios)
#write result
  write.csv(OptimalPortfolios,paste(dir.output,"OptimalPortfolios_1000.csv",sep=""),row.names=FALSE)

#
 filenames <- list.files(paste(dir.output,"DynamicOptimalPortfolios\\",sep=""), pattern="*.csv", full.names=FALSE)
 OptimalPortfolios<-lapply(filenames, function (x) {read.csv(paste(dir.output,"DynamicOptimalPortfolios\\",x,sep=""))})
 OptimalPortfolios<-do.call("rbind",OptimalPortfolios)
#write result
  write.csv(OptimalPortfolios,paste(dir.output,"OptimalPortfolios_3000.csv",sep=""),row.names=FALSE)




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
