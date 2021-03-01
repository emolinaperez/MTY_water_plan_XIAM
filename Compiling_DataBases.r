#specify directories
 dir.exp<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\P1\\"

#experiment blocks

  block1<-"Experiment_05_01_2018"
  block2<-"Experiment_09_01_2018"
  block3<-"Experiment_14_01_2018"


#Read all files
#block1
  filenames <- list.files(paste(dir.exp,block1,"\\",sep=""), pattern="*.csv", full.names=FALSE)
  filenames.data <- filenames[3:length(filenames)]
  RegretAnalysis<-lapply(filenames.data, function (x) {read.csv(paste(dir.exp,block1,"\\",x,sep=""))})
  RegretAnalysis<-do.call("rbind",RegretAnalysis)
#Add period column
  RegretAnalysis$Period<-"P1"
#Read block column
  RegretAnalysis$Block<-"Block1"

#Read options table
  Options.Table<-read.csv(paste(dir.exp,block1,"\\","P1_OptionsTable_05_01_2018_block1.csv",sep=""))
  Options.Table<-Options.Table[,names(Options.Table)[c(1,6:20)]]

# Merge tables
  dim(RegretAnalysis)
  dim(Options.Table)
  RegretAnalysis<-merge(RegretAnalysis,Options.Table,by="Options")
  dim(RegretAnalysis)

#add portfolio column
  RegretAnalysis$Portfolio<-paste(RegretAnalysis$Block,"_Portfolio_",RegretAnalysis$Options,sep="")
  RegretAnalysis$Options<-NULL
  RegretAnalysis_P1<-RegretAnalysis
####

#block 2
  filenames <- list.files(paste(dir.exp,block2,"\\",sep=""), pattern="*.csv", full.names=FALSE)
  filenames.data <- filenames[3:length(filenames)]
  RegretAnalysis<-lapply(filenames.data, function (x) {read.csv(paste(dir.exp,block2,"\\",x,sep=""))})
  RegretAnalysis<-do.call("rbind",RegretAnalysis)
#Add period column
  RegretAnalysis$Period<-"P1"
#Read block column
  RegretAnalysis$Block<-"Block2"

#Read options table
  Options.Table<-read.csv(paste(dir.exp,block2,"\\","P1_OptionsTable_09_01_2018_block2.csv",sep=""))
  Options.Table<-Options.Table[,names(Options.Table)[c(1,6:20)]]

# Merge tables
  dim(RegretAnalysis)
  dim(Options.Table)
  RegretAnalysis<-merge(RegretAnalysis,Options.Table,by="Options")
  dim(RegretAnalysis)

#add portfolio column
  RegretAnalysis$Portfolio<-paste(RegretAnalysis$Block,"_Portfolio_",RegretAnalysis$Options,sep="")
  RegretAnalysis$Options<-NULL
  RegretAnalysis_P2<-RegretAnalysis
####


#block 3
  filenames <- list.files(paste(dir.exp,block3,"\\",sep=""), pattern="*.csv", full.names=FALSE)
  filenames.data <- filenames[3:length(filenames)]
  RegretAnalysis<-lapply(filenames.data, function (x) {read.csv(paste(dir.exp,block3,"\\",x,sep=""))})
  RegretAnalysis<-do.call("rbind",RegretAnalysis)
#Add period column
  RegretAnalysis$Period<-"P1"
#Read block column
  RegretAnalysis$Block<-"Block3"

#Read options table
  Options.Table<-read.csv(paste(dir.exp,block3,"\\","P1_OptionsTable_14_01_2018_block1_tarriffs.csv",sep=""))
  Options.Table<-Options.Table[,names(Options.Table)[c(1,6:20)]]

# Merge tables
  dim(RegretAnalysis)
  dim(Options.Table)
  RegretAnalysis<-merge(RegretAnalysis,Options.Table,by="Options")

#add portfolio column
  RegretAnalysis$Portfolio<-paste(RegretAnalysis$Block,"_Portfolio_",RegretAnalysis$Options,sep="")
  RegretAnalysis$Options<-NULL
  RegretAnalysis_P3<-RegretAnalysis
####

 RegretAnalysis<-rbind(RegretAnalysis_P1,RegretAnalysis_P2,RegretAnalysis_P3)

#write
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 write.csv(RegretAnalysis,paste(dir.output,"Pareto_boundary_regret_analysis.csv",sep=""),row.names=FALSE)
