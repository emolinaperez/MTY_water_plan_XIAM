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
#     1) #x13

RCL.Script<-paste("
#Set environment variables
 set env(MODEL_DIR) C:/Users/L03054557/Edmundo-ITESM/Proyectos/ProjectoAguaMty/Phase2MTY/ModeloRiverware
 SetEnv MODEL_DIR $env(MODEL_DIR)

#Load the model
 OpenWorkspace $env(MODEL_DIR)/System/Modelo_AMM_21_07_2017.mdl

#Load the rules
 LoadRules $env(MODEL_DIR)/System/Rules_AMM_21_07_2017.rls

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
 InvokeDMI ParametersDMI
 InvokeDMI DemandScenarioDMI
 InvokeDMI ClimateScenarioDMI

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
                   1.0) #x13
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
} else { optim.portfolio<-list(par=rep(1,nrow(Projects_Chars)),value=68536)}
 return(optim.portfolio)
}


dynamic.optimizer<-function(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,Projects_Chars,Future.ID)
{
#Make parameters global for all the functions within iteration.optim
   dir.model<<-dir.model
   Projects_Chars<<-Projects_Chars
   Future.ID<<-Future.ID
#   Future.ID<-40
#Input Demand Scenario in Riverware
     Demand.Scenario.Name<-as.character(Futures.Table[Future.ID,"DemandScenario"])
     Demand.Scenario<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$Scenario==Demand.Scenario.Name)
#Input Climate Scenario in Riverware
     Climate.Scenario.Name<-as.character(Futures.Table[Future.ID,"ClimateScenario"])
     Climate.Scenario<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario==Climate.Scenario.Name)

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
             as.integer(1.0)) #x13

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
            as.integer(1.0)) #x13

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
            as.integer(1.0)) #x13

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
  Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_13_06_2017.csv",sep=""))
  Projects_Chars$ID_Project<-as.character(Projects_Chars$ID_Project)

#Load Futures Table
 Futures.Table<-read.csv(paste(dir.exp,"FuturesTable.csv",sep=""))
#Load Demand Scenarios Table
 Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios.csv",sep=""))
#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios.csv",sep=""))

#40 has a problem
for (i in 41:nrow(Futures.Table))
   {
     i<-40
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
  write.csv(OptimalPortfolios,paste(dir.output,"OptimalPortfolios.csv",sep=""),row.names=FALSE)




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


# characterize climates

#Load Climate Scenarios Table
#  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios.csv",sep=""))
#  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenariosAll.csv",sep=""))
   Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenariosSample.csv",sep=""))
#Aggregate at yearly level

  Climate.Scenarios.Table<-data.table(Climate.Scenarios.Table)
  Climate.Scenarios.Table[,Date:=NULL]
#  Climate.Scenarios.Table$Date<-NULL
#Create flow for current supply
  Climate.Scenarios.Table[,CurrentSources.Inflow:=Pesqueria.Inflow+La.Boca.Inflow+Rio.San.Juan.1.Inflow+Rio.Pablillo_Camacho.Inflow]
#Create flow for future supply
  Climate.Scenarios.Table[,FutureSources.Inflow:=Rio.Panuco.MTY.VI.Inflow+La.Libertad.Inflow+Vicente.Guerrero.Inflow]
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
 Climate.Chars.Full<-data.table(read.csv(paste(dir.output,"ClimateCharsEnsemble50k.csv",sep="")))
 test<-rbind(Climate.Chars.Full,Climate.Chars.Sample)
#Print file
  write.csv(test,paste(dir.output,"ClimateChars.csv",sep=""),row.names=FALSE)
  #write.csv(Climate.Chars,paste(dir.output,"ClimateChars.csv",sep=""),row.names=FALSE)
#  write.csv(Climate.Chars,paste(dir.output,"ClimateCharsEnsemble50k.csv",sep=""),row.names=FALSE)


#Create multiple sequences of climate series

 dir.scenarios<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\Scenarios\\"
 #in cloud
# dir.scenarios<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\ProjectoAguaMty\\Inputs\\"
# dir.output<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\ProjectoAguaMty\\Inputs\\"

#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios.csv",sep=""))
  Climate.Scenarios.Table$ClimateScenario<-as.character(Climate.Scenarios.Table$ClimateScenario)
  Historic<-data.table(subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario=="Historic.Synthetic"))
  Historic$Date<-NULL
#Scenarios per River
  VicenteGuerrero<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Vicente.Guerrero.Inflow")]
  La.Boca<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","La.Boca.Inflow")]
  Rio.San.Juan.1<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Rio.San.Juan.1.Inflow")]
  Rio.Panuco.MTY.VI<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Rio.Panuco.MTY.VI.Inflow")]
  Rio.Pablillo_Camacho<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Rio.Pablillo_Camacho.Inflow")]
  La.Libertad<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","La.Libertad.Inflow")]
  Pesqueria<-Climate.Scenarios.Table[,c("ClimateScenario","Year","Month","Pesqueria.Inflow")]
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
  sample.size<-100
#  sample.size<-200000
# sample.size<-50000
# lhs.sample<-randomLHS(sample.size,7)
 #lhs.sample<-improvedLHS(sample.size, 7, dup=2)
# lhs.sample<-improvedLHS(sample.size, 7, dup=5)
 lhs.sample<-improvedLHS(sample.size, 7, dup=10)
  Combinations<-data.frame(apply(lhs.sample,c(1,2),function(x) {
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
#
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
