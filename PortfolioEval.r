portfolio.reliability<-function(x,ini.yr,end.yr,All.Output=FALSE)
{
#  ini.yr<<-ini.yr
#  end.yr<<-end.yr
#Estimate number of months of simulation
 n.months<-(end.yr-ini.yr+1)*12-1

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
 set env(MODEL_DIR) {C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware}
#In Cloud
# set env(MODEL_DIR) {C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ModeloRiverware}
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

#
vulnerability.eval.P1<-function(dir.model,
                             dir.output,
                             Demand.Scenarios.Table,
                             Climate.Scenarios.Table,
                             GW.Scenarios.Table,
                             Projects_Chars,
                             step1.options,
                             Future.ID)
{
#Make parameters global for all the functions within iteration.optim
#
#step1.options<-rep(0,15)
#step2.options<-rep(0,15)
#step3.options<-rep(0,15)
   dir.model<<-dir.model
   Projects_Chars<<-Projects_Chars
   Future.ID<<-Future.ID
#  Future.ID<-88
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
#Evaluate options in step1
  step1.values<-portfolio.reliability(step1.options,2015,2026,All.Output=TRUE)
  Sys.sleep(4)
  step1.reliability<-as.numeric(step1.values[1])/100
  cost.vector<-Projects_Chars$Total.Investment.Millions
  step1.cost<-as.numeric(
                matrix(step1.options,nrow=1,ncol=length(unique(Projects_Chars$ID_Project)))%*%matrix(cost.vector,nrow=length(unique(Projects_Chars$ID_Project)),ncol=1)
               )

#Rbind final solution
  portfolio<-data.frame(Cost=step1.cost,
                        Reliability=step1.reliability)
  portfolio$Future.ID<-Future.ID
#return final value
   return(portfolio)
}


###

vulnerability.eval<-function(dir.model,
                             dir.output,
                             Demand.Scenarios.Table,
                             Climate.Scenarios.Table,
                             GW.Scenarios.Table,
                             Projects_Chars,
                             step1.options,
                             step2.options,
                             step3.options,
                             Future.ID)
{
#Make parameters global for all the functions within iteration.optim
#
#step1.options<-rep(0,15)
#step2.options<-rep(0,15)
#step3.options<-rep(0,15)
   dir.model<<-dir.model
   Projects_Chars<<-Projects_Chars
   Future.ID<<-Future.ID
#  Future.ID<-88
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
#Evaluate options in step1
  step1.values<-portfolio.reliability(step1.options,2015,2026,All.Output=TRUE)
  step1.reliability<-as.numeric(step1.values[1])/100
  cost.vector<-Projects_Chars$Total.Investment.Millions
  step1.cost<-as.numeric(
                matrix(step1.options,nrow=1,ncol=length(unique(Projects_Chars$ID_Project)))%*%matrix(cost.vector,nrow=length(unique(Projects_Chars$ID_Project)),ncol=1)
               )



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

#Solve for second step
  step2.values<-portfolio.reliability(step2.options,2027,2038,All.Output=TRUE)
  step2.reliability<-as.numeric(step2.values[1])/100
  cost.vector<-Projects_Chars$Total.Investment.Millions
  step2.cost<-as.numeric(
                matrix(step2.options,nrow=1,ncol=length(unique(Projects_Chars$ID_Project)))%*%matrix(cost.vector,nrow=length(unique(Projects_Chars$ID_Project)),ncol=1)
               )




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
#
#Solve for third step
  step3.values<-portfolio.reliability(step3.options,2039,2050,All.Output=TRUE)
  step3.reliability<-as.numeric(step3.values[1])/100
  cost.vector<-Projects_Chars$Total.Investment.Millions
  step3.cost<-as.numeric(
                matrix(step3.options,nrow=1,ncol=length(unique(Projects_Chars$ID_Project)))%*%matrix(cost.vector,nrow=length(unique(Projects_Chars$ID_Project)),ncol=1)
               )


#Rbind final solution
  portfolio<-list(c(step1.cost,step1.reliability),
                  c(step2.cost,step2.reliability),
                  c(step3.cost,step3.reliability))
  portfolio<-as.data.frame(do.call("rbind",portfolio))
  colnames(portfolio)<-c("Cost","Reliability")
  portfolio$Period<-c("P1","P2","P3")
  portfolio$Future.ID<-Future.ID

#write result
    write.csv(portfolio,paste(dir.output,"future_",Future.ID,".csv",sep=""),row.names=FALSE)
  #return final value
   return(portfolio)

#return final value
 return(portfolio)
}

 #Set up directories
 #
  dir.model<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
  dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\NoAction\\"
  dir.exp<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"

 #in cloud
#  dir.model<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ModeloRiverware\\"
#  dir.output<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\NoAction\\"
#  dir.exp<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ExperimentsDataTables\\"
#  dir.scenarios<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\Scenarios\\"

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
                                                         "Dry.20","Dry20.alt1","Dry20.alt2",
                                                         "Dry.15","Dry15.alt1","Dry15.alt2",
                                                         "Dry.10","Dry10.alt1","Dry10.alt2",
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


#Evaluate vulnerability of portfolio accross all futures
for (i in unique(Futures.Table$Future.ID))
   {
     vulnerability.eval(dir.model,
                        dir.output,
                        Demand.Scenarios.Table,
                        Climate.Scenarios.Table,
                        GW.Scenarios.Table,
                        Projects_Chars,
                        rep(0,15),
                        rep(0,15),
                        rep(0,15),
                        i)

    }

# Put together results
 filenames <- list.files(dir.output, pattern="*.csv", full.names=FALSE)
 VulnerabilityAnalysis<-lapply(filenames, function (x) {read.csv(paste(dir.output,x,sep=""))})
 VulnerabilityAnalysis<-do.call("rbind",VulnerabilityAnalysis)
#write result
#  dir.output<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
#  write.csv(OptimalPortfolios,paste(dir.output,"OptimalPortfolios.csv",sep=""),row.names=FALSE)

  dir.chars<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
#read future Chars
  Futures.Chars<-read.csv(paste(dir.exp,"FuturesChars.csv",sep=""))
  Futures.Chars<-Futures.Chars[,c("Period","Future.ID","gw.factor", "CurrentSources.HDiff","FutureSources.HDiff","AllSources.HDiff","Demand.cms")]
#merge with vulerability analaysis
  dim(VulnerabilityAnalysis)
  dim(Futures.Chars)
   Futures.Chars$Period<-as.character(Futures.Chars$Period)
   VulnerabilityAnalysis$Period<-as.character(VulnerabilityAnalysis$Periodo)
   VulnerabilityAnalysis$Periodo<-NULL
   VulnerabilityAnalysis<-Reduce(function(...) { merge(..., all=TRUE) }, list(VulnerabilityAnalysis,Futures.Chars))
   dim(VulnerabilityAnalysis)
#write demand chars
  write.csv(VulnerabilityAnalysis,paste(dir.chars,"VulnerabilityAnalysis.csv",sep=""),row.names=FALSE)


#Below you create Future Chars

#Create future chars table
  Futures.Chars<-data.frame(Future.ID=rep(1:696,each=3),Period=rep(c("P1","P2","P3"),696))

#Read futures table
   Futures.Table<-read.csv(paste(dir.exp,"FuturesTable.csv",sep=""))

#Merge futures table with Future.Chars
  dim(Futures.Chars)
  dim(Futures.Table)
  Futures.Chars<-merge(Futures.Chars,Futures.Table,by="Future.ID")
  dim(Futures.Chars)

#Now load groundwater scenarios
  GW.Scenarios.Table<-read.csv(paste(dir.scenarios,"GWScenarios.csv",sep=""))
#merge
 dim(Futures.Chars)
 dim(GW.Scenarios.Table)
  Futures.Chars<-merge(Futures.Chars,GW.Scenarios.Table,by="ClimateScenario")
 dim(Futures.Chars)

#Load Climate Scenarios Chars
  ClimateCharsPeriods<-read.csv(paste(dir.chars,"ClimateCharsPeriods.csv",sep=""))
  Rivers<-c("Vicente.Guerrero.Inflow","La.Boca.Inflow",
         "Rio.San.Juan.1.Inflow","Rio.Panuco.MTY.VI.Inflow",
         "Rio.Pablillo_Camacho.Inflow","La.Libertad.Inflow","Pesqueria.Inflow")
  #var.type<-".MonthsBelowHist"
  var.type<-".mean"
  vars<-paste(Rivers,var.type,sep="")
#subset to target variables
    ClimateCharsPeriods<-ClimateCharsPeriods[,c("ClimateScenario","Period",vars)]
#subet to historic levels
    ClimateCharsPeriodsH<-ClimateCharsPeriods[ClimateCharsPeriods$ClimateScenario=="Historic.Synthetic",c("Period",vars)]
    colnames(ClimateCharsPeriodsH)<-c("Period",paste(vars,".Hlevel",sep=""))
  ClimateCharsPeriods[,colnames(ClimateCharsPeriodsH)[2]]<-mean(ClimateCharsPeriodsH[,colnames(ClimateCharsPeriodsH)[2]])
  ClimateCharsPeriods[,colnames(ClimateCharsPeriodsH)[3]]<-mean(ClimateCharsPeriodsH[,colnames(ClimateCharsPeriodsH)[3]])
  ClimateCharsPeriods[,colnames(ClimateCharsPeriodsH)[4]]<-mean(ClimateCharsPeriodsH[,colnames(ClimateCharsPeriodsH)[4]])
  ClimateCharsPeriods[,colnames(ClimateCharsPeriodsH)[5]]<-mean(ClimateCharsPeriodsH[,colnames(ClimateCharsPeriodsH)[5]])
  ClimateCharsPeriods[,colnames(ClimateCharsPeriodsH)[6]]<-mean(ClimateCharsPeriodsH[,colnames(ClimateCharsPeriodsH)[6]])
  ClimateCharsPeriods[,colnames(ClimateCharsPeriodsH)[7]]<-mean(ClimateCharsPeriodsH[,colnames(ClimateCharsPeriodsH)[7]])
  ClimateCharsPeriods[,colnames(ClimateCharsPeriodsH)[8]]<-mean(ClimateCharsPeriodsH[,colnames(ClimateCharsPeriodsH)[8]])


#  dim(ClimateCharsPeriods)
#  ClimateCharsPeriods<-merge(ClimateCharsPeriods,ClimateCharsPeriodsH,by="Period")
#  dim(ClimateCharsPeriods)

#Now estimate percent differences for each column
 for (i in 1:length(vars))
 {
  ClimateCharsPeriods[,paste(vars[i],".HDiff",sep="")]<-(ClimateCharsPeriods[,vars[i]]-ClimateCharsPeriods[,paste(vars[i],".Hlevel",sep="")])/ClimateCharsPeriods[,paste(vars[i],".Hlevel",sep="")]
 }

#understanding the variation
 summary(ClimateCharsPeriods[ClimateCharsPeriods$Period=="P1",paste(vars,".HDiff",sep="")])

#Create mean accross sources groups
 ClimateCharsPeriods$CurrentSources.HDiff<-rowMeans(ClimateCharsPeriods[,paste(c("Pesqueria.Inflow","La.Boca.Inflow","Rio.San.Juan.1.Inflow","Rio.Pablillo_Camacho.Inflow"),var.type,".HDiff",sep="")])*100
 ClimateCharsPeriods$FutureSources.HDiff<-rowMeans(ClimateCharsPeriods[,paste(c("Rio.Panuco.MTY.VI.Inflow","La.Libertad.Inflow","Vicente.Guerrero.Inflow"),var.type,".HDiff",sep="")])*100
 ClimateCharsPeriods$AllSources.HDiff<-rowMeans(ClimateCharsPeriods[,c("CurrentSources.HDiff","FutureSources.HDiff")])
 ClimateCharsPeriods<-ClimateCharsPeriods[,c("ClimateScenario","Period","CurrentSources.HDiff","FutureSources.HDiff","AllSources.HDiff")]

#merge
 dim(Futures.Chars)
 dim(ClimateCharsPeriods)
 Futures.Chars<-Reduce(function(...) { merge(..., all=TRUE) }, list(Futures.Chars,ClimateCharsPeriods))
 dim(Futures.Chars)

#Load Demand Scenarios Chars
  DemandCharsPeriods<-read.csv(paste(dir.chars,"DemandCharsPeriods.csv",sep=""))
#
 dim(Futures.Chars)
 dim(DemandCharsPeriods)
 Futures.Chars<-Reduce(function(...) { merge(..., all=TRUE) }, list(Futures.Chars,DemandCharsPeriods))
 dim(Futures.Chars)

# add for every period sub groups of uncertainty conditions
#Create function
Levels.Period<-function(var,Data)
{
#  Data<-Futures.Chars
#  var<-"Demand.cms"
#Subset table
 Pivot<-Data[,c("Future.ID","Period",var)]
#Estimate quantiles
  levels<-c(0.25,0.75)
  p1.levels<-quantile(Futures.Chars[Futures.Chars$Period=="P1",var],probs=levels)
  p2.levels<-quantile(Futures.Chars[Futures.Chars$Period=="P2",var],probs=levels)
  p3.levels<-quantile(Futures.Chars[Futures.Chars$Period=="P3",var],probs=levels)
#Create levels table
  levels<-data.frame(Period=c("P1","P2","P3"),
                     L1=c(round(p1.levels[1],1),round(p2.levels[1],1),round(p3.levels[1],1)),
                     L2=c(round(p1.levels[2],1),round(p2.levels[2],1),round(p3.levels[2],1)))
#Merge with Pivot
 Pivot<-merge(Pivot,levels,by="Period")
#Estimate Levels
Pivot$var.levels<-ifelse(Pivot[,var]<=Pivot[,"L1"],paste("<=",Pivot[,"L1"],sep=""),
                               ifelse(Pivot[,var]<=Pivot[,"L2"],paste("(",Pivot[,"L1"],",",Pivot[,"L2"],"]",sep=""),paste(">",Pivot[,"L2"],sep=""))
                        )

 Pivot<-Pivot[,c("Future.ID","Period","var.levels")]
 colnames(Pivot)<-c("Future.ID","Period",paste(var,".Levels",sep=""))
 return(Pivot)
}
#Create Levels
 Demand.Levels<-Levels.Period("Demand.cms",Futures.Chars)
 Climate.Levels1<-Levels.Period("AllSources.HDiff",Futures.Chars)
 #merge
 Climate.Levels2<-Levels.Period("CurrentSources.HDiff",Futures.Chars)
 Climate.Levels3<-Levels.Period("FutureSources.HDiff",Futures.Chars)
 GW.Levels<-Levels.Period("gw.factor",Futures.Chars)
#
 dim(Futures.Chars)
 Futures.Chars<-Reduce(function(...) { merge(..., all=TRUE) }, list(Futures.Chars,Demand.Levels,Climate.Levels1,Climate.Levels2,Climate.Levels3,GW.Levels))
 dim(Futures.Chars)
#write demand chars
  write.csv(Futures.Chars,paste(dir.chars,"FuturesChars.csv",sep=""),row.names=FALSE)


#using clasification algos to understand the database
  dir.data<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\P1\\"

#read future Chars
  Portfolios<-read.csv(paste(dir.data,"OptimalPortfolios_26_12_2017.csv",sep=""))
  all.names<-colnames(Portfolios)[1:15]
#let's try to understand patterns in the portfolios
#First let´s look at the most commonly used projects
  P1<-subset(Portfolios[,c(all.names,"Future.ID")],Portfolios$Period=='P1')
  probs<-sapply(P1[,all.names],mean)
  P1.Probs<-data.frame(Name = names(probs),
                       Probs = as.numeric(probs))
  P1.Probs<-P1.Probs[order(-P1.Probs$Probs),]
#From this table, we only want projects above the threshold
  P1.Probs<-subset(P1.Probs,P1.Probs$Probs>=0.20)

#Second, let's look how well correlated they are
  P1.Cors<-cor(P1[,as.character(P1.Probs$Name)])
  P1.Cors<-apply(P1.Cors,c(1,2),function(x){ifelse(x>=0.20,1,0)})
  P1.options<-data.frame(unique(P1.Cors),row.names=NULL)
  P1.options<-apply(P1.options,1,function(x){names(subset(x,x>0))})
#Finally, choose one
  P1.selection<-P1.options[[1]]
#Transform selection into binary vector for evaluation
   step1.options<-ifelse(all.names%in%P1.selection==TRUE,1,0)

#before continuing, test
#   test.ID<-163
#   vulnerability.eval.P1(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,as.numeric(Portfolios[Portfolios$Future.ID==test.ID & Portfolios$Period=="P1",1:15]),test.ID)
#   as.numeric(Portfolios[Portfolios$Future.ID==test.ID & Portfolios$Period=="P1",1:17])
#  test shows method is ok !

for (j in 7:length(P1.options))
{

#Finally, choose one
  P1.selection<-P1.options[[j]]
#Transform selection into binary vector for evaluation
   step1.options<-ifelse(all.names%in%P1.selection==TRUE,1,0)

#once we choose an option for Step 1, then we have to evaluate its reliability

  Vulnerability.P1<-vulnerability.eval.P1(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,step1.options,unique(Futures.Table$Future.ID)[1])
  for (i in unique(Futures.Table$Future.ID)[2:length(unique(Futures.Table$Future.ID))])
  {
    pivot<-vulnerability.eval.P1(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,step1.options,i)
    Vulnerability.P1<-rbind(Vulnerability.P1,pivot)
  }

#Save results
 Vulnerability.P1<-Vulnerability.P1
 Vulnerability.P1<-merge(Vulnerability.P1,Portfolios[Portfolios$Period=="P1",c("Best.Cost","Best.Reliability","Future.ID")],by="Future.ID")
 Vulnerability.P1$Cost.Regret<-Vulnerability.P1$Cost-Vulnerability.P1$Best.Cost #if positive, I spent more than I should have, if negative, I spent less that the best option, then no regret
 Vulnerability.P1$Cost.Regret<-ifelse(Vulnerability.P1$Cost.Regret>=0,Vulnerability.P1$Cost.Regret,0)
 Vulnerability.P1$Reliability.Regret<-Vulnerability.P1$Best.Reliability-Vulnerability.P1$Reliability# if positive, I could have done better, if negative, I did better than the best option, then no regret
 Vulnerability.P1$Reliability.Regret<-ifelse(Vulnerability.P1$Reliability.Regret>=0,Vulnerability.P1$Reliability.Regret,0)
 Vulnerability.P1$Options<-j
#write results
  write.csv(Vulnerability.P1,paste(dir.output,"Vulnerability.P1_",j,".csv",sep=""),row.names=FALSE)

}

#Collect files for post-processing
 filenames <- list.files(dir.output, pattern="*.csv", full.names=FALSE)
 Vulnerability.P1<-lapply(filenames, function (x) {read.csv(paste(dir.output,x,sep=""))})
 Vulnerability.P1<-do.call("rbind",Vulnerability.P1)

#Aggregate results at option level
 Vulnerability.P1<-aggregate(Vulnerability.P1[,c("Cost","Reliability","Cost.Regret","Reliability.Regret")],list(Options=Vulnerability.P1$Options),mean)

#Plot tradeoff curve
 library(ggplot2)
 Vulnerability.P1$Options<-as.character(Vulnerability.P1$Options)
 ggplot(Vulnerability.P1, aes(Cost.Regret,Reliability.Regret,group=Options))+ geom_point(aes(colour=Options))+geom_text(aes(label=Options))

#Using the tradeoff curve we wee that options 4 and 7 are dominated strategies
#We choose to do more projects in the first step, so we go with Portfolio 5

#Transform selection into binary file
 step1.options<-ifelse(all.names%in%P1.options[[5]]==TRUE,1,0)
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names

#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_options.csv",sep=""),row.names=FALSE)


#To carry on with the analysis is now necessary to re-run de optimization experiment using OptimFunctionsStep2.r


#Now, for the second step
#using clasification algos to understand the database
  dir.data<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\P1\\"

  Portfolios<-read.csv(paste(dir.data,"OptimalPortfolios_26_12_2017_Step2.csv",sep=""))
  all.names<-colnames(Portfolios)[1:15]

  P1.selection<-as.numeric(unique(Portfolios[Portfolios$Period=='P1',1:15]))
  P1.selection<-all.names[which(P1.selection==1)]

#subset to period 2
  P2<-subset(Portfolios[,c(subset(all.names,!(all.names%in%P1.selection)),"Future.ID")],Portfolios$Period=='P2')
#create column for portfolio type
  P2$Type<-apply(P2[,1:7], 1, paste, collapse=",")

#read future Chars
  Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_27_12_2017.csv",sep=""))
#merge future chars
  dim(P2)
  P2<-merge(P2,Futures.Chars[Futures.Chars$Period=='P1',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
  dim(P2)

#Now what happens if we apply clasiffication
 library(C50)
 P2.tree<-C5.0(P2[,c('CurrentSources.HDiff','Demand.cms')],
                  as.factor(as.character(P2[,'Type'])),
                  trials=100,costs=NULL)
 P2.tree
 summary(P2.tree)
 plot(P2.tree)

#it performs well and from here I could just develop a technique for trimming the tree

library(RWeka)
#more trees
 P2.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms , data = P2 )



# what about rule classifiers





#remove do nothing and do all options
  P2<-subset(P2,!(P2$Type%in%c("1,1,1,1,1,1,1","0,0,0,0,0,0,0")))

#estimate probabilities
  probs<-sapply(P2[,subset(all.names,!(all.names%in%P1.selection))],sum)
  P2.Probs<-data.frame(Name = names(probs),
                       Probs = as.numeric(probs))

  P2.Probs$Probs<-P2.Probs$Probs/(nrow(Portfolios)/3)
  P2.Probs<-P2.Probs[order(-P2.Probs$Probs),]
#From this table, we only want projects above the threshold
  P2.Probs<-subset(P2.Probs,P2.Probs$Probs>=0.10)
#Second, let's look how well correlated they are
  P2.Cors<-cor(P2[,as.character(P2.Probs$Name)])
  P2.Cors<-apply(P2.Cors,c(1,2),function(x){ifelse(x>=0.25,1,0)})
  P2.options<-data.frame(unique(P2.Cors),row.names=NULL)
#  P2.options<-apply(P2.options,1,function(x){names(subset(x,x>0))})

#Now let's look at the unique options of P2
  #let's find the patterns
   P2$Type<-apply(P2[,1:7], 1, paste, collapse=",")
   P2$Size<-rowSums(P2[,1:7])
   P2$Count<-1
   test<-aggregate(P2[,c("Count","Size")],by=list(Type=P2$Type),sum)
   test$Size<-test$Size/test$Count
   #test$Count<-test$Count/nrow(P2)
   test<-test[order(-test$Size,-test$Count),]
#here we can choose how to clasify the different portfolios
   test$Class<-ifelse(test$Size>=5,'all',
                             ifelse(test$Size>=3,'four',
                                  ifelse(test$Size>=1,'two','none')))
   test$Class<-as.factor(test$Class)
#now merge clasification  with original table for period
  dim(P2)
  P2<-merge(P2,test[,c('Type','Class')],by='Type')
  dim(P2)

#now let's merge this with future chars
  dir.exp<-"C:\\Users\\L03054557\\Edmundo-ITESM\\Proyectos\\ProjectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
#read future Chars
  Futures.Chars<-read.csv(paste(dir.exp,"FuturesChars.csv",sep=""))
#merge future chars
  dim(P2)
  P2<-merge(P2,Futures.Chars[Futures.Chars$Period=='P1',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
  dim(P2)
#
#load the decision tree library
 library(C50)
  P2.tree<-C5.0(P2[,c('gw.factor','CurrentSources.HDiff','Demand.cms')],
                   as.factor(as.character(P2[,'Class'])),
                   trials=100,costs=NULL)
  P2.tree
  summary(P2.tree)
  plot(P2.tree)
#let's try random forest



#using rule clasiffiers
  P2.Factor<-as.character()
 library(RWeka)
  test<-OneR(Class ~ gw.factor + CurrentSources.HDiff + Demand.cms , data = P2 )

#more trees
  test<-J48(Class ~ gw.factor + CurrentSources.HDiff + Demand.cms , data = P2 )
  graph<-as.character(write_to_dot(test))





#Visualizing data
# ggtree library:   http://www.ggplot2-exts.org/ggtree.html

#create a dummy tree
 #useful tutorial: http://www.phytools.org/eqg/Exercise_3.2/
   library(ape)
   tree <- read.tree(text = "((P1,P2),(P3,P4));")
#   plot(tree, edge.width = 2)

dir.tree <-"C:\\Users\\L03054557\\Documents\\R\\win-library\\3.3\\ggtree\\extdata\\BEAST\\"

decision.tree <- "decision((P1:4.2,P2:4.2):3.1,(P3:4.2,P4:4.2):3.1);" # the number after the two points in the length of the tip
cat(decision.tree, file = paste(dir.tree,"ex.tre",sep=""), sep = "\n")
decision.tree <- read.tree(paste(dir.tree,"ex.tre",sep=""))


 fileBeast <- system.file("extdata/BEAST", "ex.tree", package="ggtree")
 beast <- read.beast(fileBeast)



ggtree(decision.tree, ndigits=2, branch.length = 'none') + geom_tiplab()

  s <- "owls(((Strix_aluco:4.2,Asio_otus:4.2):3.1,Athene_noctua:7.3):6.3,Tyto_alba:13.5);"
  cat(s, file = "ex.tre", sep = "\n")
  tree.owls <- read.tree("ex.tre")




#load library
library(ggplot2)
library(ape)
library(ggtree)

#visualize tree
  ggplot(tree, aes(x, y)) + geom_tree() + theme_tree()

  ggtree(tree) + geom_text2(aes(subset=!isTip, label=node), hjust=-.3) + geom_tiplab()

#understanding a tree
  fileBeast <- system.file("extdata/BEAST", "beast_mcc.tree", package="ggtree")
  fileTest <- system.file("extdata/BEAST", "test.tree", package="ggtree")
  beast <- read.beast(file)
  ggtree(beast, ndigits=2, branch.length = 'none') + geom_text(aes(x=branch, label=length_0.95_HPD), vjust=-.5, color='firebrick')+ geom_tiplab()

  ggtree(beast, ndigits=2, branch.length = 'none') + geom_text(aes(x=branch, label=length_HPD))+ geom_tiplab()


#add projetc names
  P2.names<-subset(all.names,!(all.names%in%P1.selection))
  test.ops<-data.frame(do.call(rbind, strsplit(as.character(test$Type),',') ))
  colnames(test.ops)<-P2.names
#multiply by frequency
#bind both tables
  test<-cbind(test,test.ops)
#multiply by probs
for (i in 1:length(P2.names))
{
  test[,P2.names[i]]<-as.numeric(as.character(test[,P2.names[i]]))*test[,'Count']
}
#subset
 subset(P2.names,!(P2.names%in%c("TunelSanFranciscoII","Panuco","Subalveo.LaUnion")))

  pivot<-subset(test,test$Size%in%c(5,6))
  names(sapply(pivot[,P2.names],sum)[order(-sapply(pivot[,P2.names],sum))])[1:5]
#
  sum(test$Count[test$Size%in%c(5,6)])

choose top X
#we could choose a representative portfolio in the bins 5,6; 4,3;  2,1
# so we would have five branches: 1) do all (5,6), 2) do four c(4,3) , 3) do two (2,1) and 4) do nothing


   tes$Size<-tes$Size

  test<-unique(P2[,subset(all.names,!(all.names%in%P1.selection))])
  test$size<-rowSums(test)
  test<-test[order(-test$size),]
#




#merge both tables





 #look at correlation table aand at frequency table
