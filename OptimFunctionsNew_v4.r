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
 OpenWorkspace $env(MODEL_DIR)/System/Modelo_AMM_26_04_2017_test.mdl

#Load the rules
 LoadRules $env(MODEL_DIR)/System/Rules_AMM_26_04_2017_test.rls

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
 InvokeDMI MP_Input
 InvokeDMI MP_RiversData

# run the simulation
 StartController

#Print result
 set v [GetSlot Analisis.Confiabilidad]
 puts $v

#Print Outputs
  Output SupplyDemand

# Close the opened model and exit RiverWare
 CloseWorkspace
",sep="")

#to run the following line you need to include in PATH: C:\\Users\\L03054557\\AppData\\Local\\Programs\\CADSWES\\RiverWare 7.0.5
#get a temporary directory
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
                           "Future.ID",
                           "write.xlsx2",
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
                          Domains=Domains,
                          data.type.int=TRUE,
                          cluster=cl,
                          print.level=0)
  stopCluster(cl)
} else { optim.portfolio<-list(par=rep(1,nrow(Projects_Chars)),value=83083)}
 return(optim.portfolio)
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
 library(snow)

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
for (i in 2:11)
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

#

dynamic.optimizer<-function(dir.input,dir.output,z)
{
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
             as.integer(0.0), #x10
             as.integer(1.0), #x11
             as.integer(1.0), #x12
             as.integer(1.0)) #x13

  Domains<<-matrix(c(x.ini.0,x.fin.0),ncol=2)
  portfolio1<-iteration.optim(dir.model,Projects_Chars,Futures.Table,Demand.Scenarios.Table,Climate.Scenarios.Table,Domains,i,2016,2026)
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
