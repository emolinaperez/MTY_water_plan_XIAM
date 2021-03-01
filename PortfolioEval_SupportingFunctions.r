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
 set env(MODEL_DIR) {C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware}

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
                             Desalt.Scenarios.Table,
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
#Input Desalt Scenario in Riverware
   Desalt.Scenario.Name<-as.character(Futures.Table[Futures.Table$Future.ID==Future.ID,"DesaltScenario"])
   Desalt.Scenario<-subset(Desalt.Scenarios.Table,Desalt.Scenarios.Table$DesaltScenario==Desalt.Scenario.Name)
   desalt.factor<-as.numeric(Desalt.Scenario$desalt.factor)
   Projects_Chars$Total.Investment.Millions[Projects_Chars$Project=="Desalacion.Matamoros"]<-Projects_Chars$Total.Investment.Millions[Projects_Chars$Project=="Desalacion.Matamoros"]*(1+desalt.factor)
#Update Projects_Chars
   Projects_Chars<<-Projects_Chars

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
                             Desalt.Scenarios.Table,
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
   Future.ID<<- Future.ID
#  Future.ID<-601
#Input Demand Scenario in Riverware
     Demand.Scenario.Name<-as.character(Futures.Table[Futures.Table$Future.ID==Future.ID,"DemandScenario"])
     Demand.Scenario<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$Scenario==Demand.Scenario.Name)
#Input Climate Scenario in Riverware
     Climate.Scenario.Name<-as.character(Futures.Table[Futures.Table$Future.ID==Future.ID,"ClimateScenario"])
     Climate.Scenario<-subset(Climate.Scenarios.Table,Climate.Scenarios.Table$ClimateScenario==Climate.Scenario.Name)
#Input GW Scenario in Riverware
    GW.Scenario.Name<-as.character(Futures.Table[Futures.Table$Future.ID==Future.ID,"GWScenario"])
    GW.Scenario<-subset(GW.Scenarios.Table,GW.Scenarios.Table$GWScenario==GW.Scenario.Name)
#Input Desalt Scenario in Riverware
   Desalt.Scenario.Name<-as.character(Futures.Table[Futures.Table$Future.ID==Future.ID,"DesaltScenario"])
   Desalt.Scenario<-subset(Desalt.Scenarios.Table,Desalt.Scenarios.Table$DesaltScenario==Desalt.Scenario.Name)
   desalt.factor<-as.numeric(Desalt.Scenario$desalt.factor)
   Projects_Chars$Total.Investment.Millions[Projects_Chars$Project=="Desalacion.Matamoros"]<-Projects_Chars$Total.Investment.Millions[Projects_Chars$Project=="Desalacion.Matamoros"]*(1+desalt.factor)
#Update Projects_Chars
   Projects_Chars<<-Projects_Chars

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
Sys.sleep(10)
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
}
