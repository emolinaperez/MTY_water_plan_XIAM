portfolio.reliability<-function(x,All.Output=FALSE)
{
# "x" is a vector of integer values that represents a selection of project
#x<-c(0, #x1
#     1, #x2
#     0, #x3
#     0, #x4
#     1, #x5
#     0, #x6
#     1, #x7
#     1, #x8
#     1, #x9
#     1, #x10
#     1, #x11
#     1, #x12
#     1, #x13
#     1, #x14
#     1) #x15

RCL.Script<-paste("
#Set environment variables
#In PC
# set env(MODEL_DIR) {C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware}
#In Cloud
 set env(MODEL_DIR) {C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ModeloRiverware}
 SetEnv MODEL_DIR $env(MODEL_DIR)

#Load the model
 OpenWorkspace $env(MODEL_DIR)/System/Modelo_AMM_26_12_2017.mdl

#Load the rules
 LoadRules $env(MODEL_DIR)/System/Rules_AMM_26_12_2017.rls

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
 SetSlot {Presa La Libertad.Storage} {January,",ini.yr,"} ",PresaLaLibertad.Storage.Ini,"
 SetSlot {Presa La Libertad.Pool Elevation} {January,",ini.yr,"} ",PresaLaLibertad.PoolElevation.Ini,"
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
 "set x14 ",x[14],"\n",
 "set x15 ",x[15],"

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
 SetSlot ProjectsTable.x15 $x15

#run Input DMIs
 InvokeDMI ParametersDMI
 InvokeDMI DemandScenarioDMI
 InvokeDMI ClimateScenarioDMI
 InvokeDMI GWScenarioDMI

# run the simulation
 StartController

#Print result
 set v [GetSlot Analisis.Confiabilidad]
 puts $v

 set v1 [GetSlot {La Boca.Storage} {December,",end.yr,"}]
 puts $v1

 set v2 [GetSlot {La Boca.Pool Elevation} {December,",end.yr,"}]
 puts $v2

 set v3 [GetSlot {El Cuchillo.Storage} {December,",end.yr,"}]
 puts $v3

 set v4 [GetSlot {El Cuchillo.Pool Elevation} {December,",end.yr,"}]
 puts $v4

 set v5 [GetSlot {Cerro Prieto.Storage} {December,",end.yr,"}]
 puts $v5

 set v6 [GetSlot {Cerro Prieto.Pool Elevation} {December,",end.yr,"}]
 puts $v6

 set v7 [GetSlot {Marte R Gomez.Storage} {December,",end.yr,"}]
 puts $v7

 set v8 [GetSlot {Marte R Gomez.Pool Elevation} {December,",end.yr,"}]
 puts $v8

 set v9 [GetSlot {Las Blancas.Storage} {December,",end.yr,"}]
 puts $v9

 set v10 [GetSlot {Las Blancas.Pool Elevation} {December,",end.yr,"}]
 puts $v10

 set v11 [GetSlot {Vicente Guerrero.Storage} {December,",end.yr,"}]
 puts $v11

 set v12 [GetSlot {Vicente Guerrero.Pool Elevation} {December,",end.yr,"}]
 puts $v12

 set v13 [GetSlot {Campo Mina.Storage} {December,",end.yr,"}]
 puts $v13

 set v14 [GetSlot {Pozos Area Metropolitana.Storage} {December,",end.yr,"}]
 puts $v14

 set v15 [GetSlot {Campo Buenos Aires.Storage} {December,",end.yr,"}]
 puts $v15

 set v16 [GetSlot {Sistema Santiago Huajuco.Storage} {December,",end.yr,"}]
 puts $v16

 set v17 [GetSlot {Presa La Libertad.Storage} {December,",end.yr,"}]
 puts $v17

 set v17 [GetSlot {Presa La Libertad.Pool Elevation} {December,",end.yr,"}]
 puts $v17


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

#Subset output to only the numeric values of interest
 output<-output[!(1:length(output)%in%c(grep("REQINFO",output),grep("WARNING",output)))]

#Portfolio Reliability
if (All.Output==FALSE) {
 Reliability.Annual.Mean<-as.numeric(output[1])/100
 return(Reliability.Annual.Mean)
 } else {return(output)}
}


portfolio.eval<-function(x) {
# "x" is a vector of integer values that represents a selection of projects
#Estimate Portfolio Reliability
 Reliability.Annual.Mean<-mean(c(historic.reliability,portfolio.reliability(x)))
# Reliability.Annual.Mean<-portfolio.reliability(x)
#Estimate Portfolio Cost
 cost.vector<-Projects_Chars$Total.Investment.Millions
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
#  ini.yr<<-2015
#  end.yr<<-2026
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
    nCore<-12
    #nCore<-40
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
                           "PresaLaLibertad.Storage.Ini",
                           "PresaLaLibertad.PoolElevation.Ini",
                           "historic.reliability")

   clusterExport(cl,global.elements,envir=environment())
#Define initial search values
  starting.prop<-c(0, #x1
                   0, #x2
                   0, #x3
                   1.0, #x4
                   0, #x5
                   1.0, #x6
                   1.0, #x7
                   0, #x8
                   1.0, #x9
                   1.0, #x10
                   1.0, #x11
                   1.0, #x12
                   1.0, #x13
                   1.0, #x14
                   1.0) #x15
  if (sum(Domains[,1])==0) {starting.vals<-starting.prop} else {starting.vals<-Domains[,1]}
#optimize
  optim.portfolio<-genoud(portfolio.eval,
                          nvars=length(unique(Projects_Chars$ID_Project)),
                          starting.values=starting.vals,
                          pop.size=1000,
                          Domains=Domains,
                          data.type.int=TRUE,
                          cluster=cl,
                          print.level=0)
  stopCluster(cl)
} else { optim.portfolio<-list(par=rep(1,nrow(Projects_Chars)),value=72336)}
 return(optim.portfolio)
}


dynamic.optimizer<-function(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,Future.ID)
{
#Make parameters global for all the functions within iteration.optim
   dir.model<<-dir.model
   Projects_Chars<<-Projects_Chars
   Future.ID<<-Future.ID
#  Future.ID<<-88
#Input Demand Scenario in Riverware
     Demand.Scenario.Name<-as.character(Futures.Table[Futures.Table$Future.ID==Future.ID,"DemandScenario"])
     Demand.Scenario<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$Scenario==Demand.Scenario.Name)
#Input Climate Scenario in Riverware
     Climate.Scenario.Name<-as.character(Futures.Table[Futures.Table$Future.ID==Future.ID,"ClimateScenario"])
     Climate.Scenario<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario==Climate.Scenario.Name)
#Input GW Scenario in Riverware
    GW.Scenario.Name<-as.character(Futures.Table[Futures.Table$Future.ID==Future.ID,"GWScenario"])
    GW.Scenario<-subset(GW.Scenarios.Table,GW.Scenarios.Table$GWScenario==GW.Scenario.Name)

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

#Write gw scenario in Riverware input file
  write(GW.Scenario$gw.factor,paste(dir.model,"Input\\gwfactor.txt",sep=""),sep = "\n")

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
  PresaLaLibertad.Storage.Ini<<-200
  PresaLaLibertad.PoolElevation.Ini<<-278.51
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
             as.integer(1.0), #x14
             as.integer(1.0)) #x15

  Domains<<-matrix(c(x.ini.0,x.fin.0),ncol=2)
  historic.reliability<-NULL
  portfolio1<-iteration.optim(dir.model,Projects_Chars,Domains,historic.reliability,2015,2026)
  step1.options<-portfolio1$par
  step1.cost<-portfolio1$value
  step1.values<-portfolio.reliability(step1.options,All.Output=TRUE)
  step1.reliability<-as.numeric(step1.values[1])/100
  historic.reliability<-step1.reliability

#Set initial conditions for next step
  LaBoca.Storage.Ini<<-as.numeric(step1.values[2])
  LaBoca.PoolElevation.Ini<<-as.numeric(step1.values[3])
  ElCuchillo.Storage.Ini<<-as.numeric(step1.values[4])
  ElCuchillo.PoolElevation.Ini<<-as.numeric(step1.values[5])
  CerroPrieto.Storage.Ini<<-as.numeric(step1.values[6])
  CerroPrieto.PoolElevation.Ini<<-as.numeric(step1.values[7])
  MarteRGomez.Storage.Ini<<-as.numeric(step1.values[8])
  MarteRGomez.PoolElevation.Ini<<-as.numeric(step1.values[9])
  LasBlancas.Storage.Ini<<-83
  LasBlancas.PoolElevation.Ini<<-89.86
  VicenteGuerrero.Storage.Ini<<-as.numeric(step1.values[12])
  VicenteGuerrero.PoolElevation.Ini<<-as.numeric(step1.values[13])
  CampoMina.Storage.Ini<<- as.numeric(step1.values[14])
  PozosAreaMetropolitana.Storage.Ini<<-as.numeric(step1.values[15])
  CampoBuenosAires.Storage.Ini<<-as.numeric(step1.values[16])
  SistemaSantiagoHuajuco.Storage.Ini<<-as.numeric(step1.values[17])
  PresaLaLibertad.Storage.Ini<<-as.numeric(step1.values[18])
  PresaLaLibertad.PoolElevation.Ini<<-as.numeric(step1.values[19])

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
            as.integer(1.0), #x14
            as.integer(1.0)) #x15

  Domains<<-matrix(c(step1.options,x.fin.1),ncol=2)

#Solve for second step
  portfolio2<-iteration.optim(dir.model,Projects_Chars,Domains,historic.reliability,2027,2038)
  step2.options<-portfolio2$par
  step2.cost<-portfolio2$value
  step2.values<-portfolio.reliability(step2.options,All.Output=TRUE)
  step2.reliability<-as.numeric(step2.values[1])/100
  historic.reliability<-mean(c(step1.reliability,step2.reliability))

#Set initial conditions for next step
  LaBoca.Storage.Ini<<-as.numeric(step2.values[2])
  LaBoca.PoolElevation.Ini<<-as.numeric(step2.values[3])
  ElCuchillo.Storage.Ini<<-as.numeric(step2.values[4])
  ElCuchillo.PoolElevation.Ini<<-as.numeric(step2.values[5])
  CerroPrieto.Storage.Ini<<-as.numeric(step2.values[6])
  CerroPrieto.PoolElevation.Ini<<-as.numeric(step2.values[7])
  MarteRGomez.Storage.Ini<<-as.numeric(step2.values[8])
  MarteRGomez.PoolElevation.Ini<<-as.numeric(step2.values[9])
  LasBlancas.Storage.Ini<<-83 #Note: las blancas does not have any effect in the system, this value is meaningless just there for legacy
  LasBlancas.PoolElevation.Ini<<-89.86
  VicenteGuerrero.Storage.Ini<<-as.numeric(step2.values[12])
  VicenteGuerrero.PoolElevation.Ini<<-as.numeric(step2.values[13])
  CampoMina.Storage.Ini<<- as.numeric(step2.values[14])
  PozosAreaMetropolitana.Storage.Ini<<-as.numeric(step2.values[15])
  CampoBuenosAires.Storage.Ini<<-as.numeric(step2.values[16])
  SistemaSantiagoHuajuco.Storage.Ini<<-as.numeric(step2.values[17])
  PresaLaLibertad.Storage.Ini<<-as.numeric(step2.values[18])
  PresaLaLibertad.PoolElevation.Ini<<-as.numeric(step2.values[19])

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
            as.integer(1.0), #x14
            as.integer(1.0)) #x15

  Domains<<-matrix(c(step2.options,x.fin.2),ncol=2)
#
#Solve for third step
  portfolio3<-iteration.optim(dir.model,Projects_Chars,Domains,historic.reliability,2039,2050)
  step3.options<-portfolio3$par
  step3.cost<-portfolio3$value
  step3.values<-portfolio.reliability(step3.options,All.Output=TRUE)
  step3.reliability<-as.numeric(step3.values[1])/100

#Rbind final solution
  portfolio<-list(c(step1.options,step1.cost,step1.reliability),
                  c(step2.options,step2.cost,step2.reliability),
                  c(step3.options,step3.cost,step3.reliability))
  portfolio<-as.data.frame(do.call("rbind",portfolio))
  colnames(portfolio)<-c(Projects_Chars$ID_Project,"Cost","Reliability")
  portfolio$Periodo<-c("P1","P2","P3")
  portfolio$Future.ID<-Future.ID
#write result
  write.csv(portfolio,paste(dir.output,"future_",Future.ID,".csv",sep=""),row.names=FALSE)
#return final value
 return(portfolio)
}

#
#Set up directories
#
 dir.model<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\"
 dir.exp<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"

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

#Read projects characteristics table
  Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_26_12_2017.csv",sep=""))
  Projects_Chars$ID_Project<-as.character(Projects_Chars$ID_Project)

#Load Futures Table
 Futures.Table<-read.csv(paste(dir.exp,"FuturesTable_27_12_2017.csv",sep=""))
#For testing
 Futures.Table<-subset(Futures.Table,Futures.Table$Block=="Block1")

#Subset climate
 Futures.Table<-subset(Futures.Table,Futures.Table$ClimateScenario%in%c("Wet.20","Wet.20.alt2","Wet.20.alt3",
                                                        "Wet.15","Wet.15.alt2","Wet.15.alt3",
                                                        "Wet.10","Wet.10.alt2","Wet.10.alt3",
                                                        "Wet.5","Wet.5.alt2","Wet.5.alt3",
                                                        "Historic.Synthetic",
                                                        "Dry.20","Dry.20.alt1","Dry.20.alt2",
                                                        "Dry.15","Dry.15.alt1","Dry.15.alt2",
                                                        "Dry.10","Dry.10.alt1","Dry.10.alt2",
                                                        "Dry.5","Dry5.alt1","Dry5.alt2"
                                                           ))
# Subset Demand
#Subset climate
 Futures.Table<-subset(Futures.Table,Futures.Table$DemandScenario%in%c("Q10","Q30","Q50","Q70","Q90"))

#Load Demand Scenarios Table
 Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios_27_12_2017.csv",sep=""))
#Load Climate Scenarios Table
 Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios_27_12_2017.csv",sep=""))
#Load Grounwater Scenarios Table
 GW.Scenarios.Table<-read.csv(paste(dir.scenarios,"GWScenarios_27_12_2017.csv",sep=""))


#subset the already completed runs
  completed<-c(382,383,384,385,386,387,398,403,404,492,511,512,513,520)
Futures.Table<-subset(Futures.Table,!(Futures.Table$Future.ID%in%completed))


#

#in cloud
for (i in unique(Futures.Table$Future.ID)[2:10])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#1#
for (i in unique(Futures.Table$Future.ID)[2:7])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#2#
for (i in unique(Futures.Table$Future.ID)[8:14])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#3
for (i in unique(Futures.Table$Future.ID)[15:21])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#4
for (i in unique(Futures.Table$Future.ID)[22:28])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#5
for (i in unique(Futures.Table$Future.ID)[29:35])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#6
for (i in unique(Futures.Table$Future.ID)[36:42])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#7
for (i in unique(Futures.Table$Future.ID)[43:49])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#8
for (i in unique(Futures.Table$Future.ID)[50:56])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#9
for (i in unique(Futures.Table$Future.ID)[57:63])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }

#10
for (i in unique(Futures.Table$Future.ID)[64:71])
   {
   dynamic.optimizer(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,i)
 }


#
 dir.portfolios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\Experiment_26_12_2017\\"
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
  dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  write.csv(OptimalPortfolios,paste(dir.output,"OptimalPortfolios_26_12_2017.csv",sep=""),row.names=FALSE)
