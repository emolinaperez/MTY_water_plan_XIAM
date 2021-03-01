#============================================================================================================================================================================================
#Section I :  Evaluate Vulnerability of Doing Nothing
#============================================================================================================================================================================================
#Set up directories
# in PC
 dir.model<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\"
 dir.exp<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"

#in cloud
#  dir.model<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ModeloRiverware\\"
#  dir.output<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\"
#  dir.exp<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ExperimentsDataTables\\"
#  dir.scenarios<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\Scenarios\\"



#Load libraries
  library(reshape2)
  library(data.table)
  library(rgenoud)
  library(snow)

#Source suppoting options

  source(paste(dir.model,"PortfolioEval_SupportingFunctions.r",sep=""))

#Read projects characteristics table
   Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_26_12_2017.csv",sep=""))
   Projects_Chars$ID_Project<-as.character(Projects_Chars$ID_Project)

#Load Futures Table
  Futures.Table<-read.csv(paste(dir.exp,"FuturesTable_16_01_2018.csv",sep=""))

#Subset for experiment
#  Futures.Table<-subset(Futures.Table,Futures.Table$Block=="Block1")
#Load Demand Scenarios Table
  Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios_16_01_2018.csv",sep=""))
#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios_27_12_2017.csv",sep=""))
#Load Grounwater Scenarios Table
  GW.Scenarios.Table<-read.csv(paste(dir.scenarios,"GWScenarios_27_12_2017.csv",sep=""))
#Load Desalt Scenarios Table
  Desalt.Scenarios.Table<-read.csv(paste(dir.scenarios,"DesaltScenarios_27_12_2017.csv",sep=""))

#Evaluate vulnerability of portfolio accross all futures

Vulnerability.NoAction<-vulnerability.eval(dir.model,
                                           dir.output,
                                           Demand.Scenarios.Table,
                                           Climate.Scenarios.Table,
                                           GW.Scenarios.Table,
                                           Desalt.Scenarios.Table,
                                           Projects_Chars,
                                           rep(0,15),
                                           rep(0,15),
                                           rep(0,15),
                                           unique(Futures.Table$Future.ID)[1])

for (i in unique(Futures.Table$Future.ID)[2:length(unique(Futures.Table$Future.ID))])
{
  pivot<-vulnerability.eval(dir.model,
                            dir.output,
                            Demand.Scenarios.Table,
                            Climate.Scenarios.Table,
                            GW.Scenarios.Table,
                            Desalt.Scenarios.Table,
                            Projects_Chars,
                            rep(0,15),
                            rep(0,15),
                            rep(0,15),
                            i)
  Vulnerability.NoAction<-rbind(Vulnerability.NoAction,pivot)
}

#read future Chars
  Futures.Chars<-read.csv(paste(dir.exp,"FuturesChars_27_12_2017.csv",sep=""))

#Change to characters
  Vulnerability.NoAction$Period<-as.character(Vulnerability.NoAction$Period)
  Futures.Chars$Period<-as.character(Futures.Chars$Period)

#Merge with Futures Chars
 dim(Vulnerability.NoAction)
    Vulnerability.NoAction<-Reduce(function(...) { merge(...) }, list(  Vulnerability.NoAction,Futures.Chars[,c('Future.ID','Period','Demand.cms','CurrentSources.HDiff')]))
 dim(Vulnerability.NoAction)

#Vulnerability of doing nothing
  write.csv(Vulnerability.NoAction,paste(dir.output,"Vulnerability_NoAction.csv",sep=""),row.names=FALSE)

#============================================================================================================================================================================================
#Section II : Use Optimization results to evaluate vulneraability of P1 projet portfolios
#============================================================================================================================================================================================

#Set up directories
# in PC
 dir.model<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\P1\\"
 dir.exp<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"

#in cloud
#  dir.model<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ModeloRiverware\\"
#  dir.output<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ExperimentsRawOutput\\"
#  dir.exp<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\ExperimentsDataTables\\"
#  dir.scenarios<-"C:\\Users\\Administrator\\Documents\\Edmundo\\Projectos\\Phase2MTY\\Scenarios\\"


#Load libraries
  library(reshape2)
  library(data.table)
  library(rgenoud)
  library(snow)

#Source suppoting options
 source(paste(dir.model,"PortfolioEval_SupportingFunctions.r",sep=""))

#Read projects characteristics table
  Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_26_12_2017.csv",sep=""))
  Projects_Chars$ID_Project<-as.character(Projects_Chars$ID_Project)
#Load futures table
# tariff.scheme<-c("Current","Scheme2")
 Futures.Table<-read.csv(paste(dir.exp,"FuturesTable_04_03_2018.csv",sep="")) #UPDATE
#Subset to the tarrifs scheme we are analyzing
 #Futures.Table<-subset(Futures.Table,Futures.Table$WaterTarrifs==tariff.scheme)
#Load Demand Scenarios Table
 Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios_16_01_2018.csv",sep=""))
# Demand.Scenarios.Table<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$WaterTarrifs==tariff.scheme)
#Load Climate Scenarios Table
   Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios_27_12_2017.csv",sep=""))
#Load Grounwater Scenarios Table
   GW.Scenarios.Table<-read.csv(paste(dir.scenarios,"GWScenarios_04_03_2018.csv",sep=""))
#Load Desalt Scenarios Table
  Desalt.Scenarios.Table<-read.csv(paste(dir.scenarios,"DesaltScenarios_04_03_2018.csv",sep=""))

#Read Portfolios Data Base
  Portfolios<-read.csv(paste(dir.exp,"OptimalPortfolios_06_03_2018.csv",sep=""))
  Portfolios<-subset(Portfolios,Portfolios$Future.ID%in%unique(Futures.Table$Future.ID))

#Select portfolios of tariff scheme


#  Portfolios<-read.csv(paste(dir.exp,"OptimalPortfolios_26_12_2017.csv",sep=""))
#  Portfolios<-read.csv(paste(dir.exp,"OptimalPortfolios_05_01_2018.csv",sep=""))
#  Portfolios<-read.csv(paste(dir.exp,"OptimalPortfolios_09_01_2018.csv",sep=""))
#  Portfolios<-read.csv(paste(dir.exp,"OptimalPortfolios_14_01_2018.csv",sep=""))
  all.names<-colnames(Portfolios)[1:15]

#First let´s look at the most commonly used projects
  P1<-subset(Portfolios[,c(all.names,"Future.ID")],Portfolios$Period=='P1') #note: for RAND´s report we can stick to looking at options in third period, for the papers we could do it foward looking
  probs<-sapply(P1[,all.names],mean)
  P1.Probs<-data.frame(Name = names(probs),
                       Probs = as.numeric(probs))
  P1.Probs<-P1.Probs[order(-P1.Probs$Probs),]
#From this table, we only want projects above the threshold
  P1.Probs<-subset(P1.Probs,P1.Probs$Probs>=0.10)

#Second, let's look how well correlated they are
  P1.Cors<-cor(P1[,as.character(P1.Probs$Name)])
  P1.Cors<-apply(P1.Cors,c(1,2),function(x){ifelse(x>=0.20,1,0)})
  P1.options<-data.frame(unique(P1.Cors),row.names=NULL)
  P1.options<-apply(P1.options,1,function(x){names(subset(x,x>0))})

#before continuing, this test checks whether ot not the functions give same result as in database
#   test.ID<-163
#   vulnerability.eval.P1(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Projects_Chars,as.numeric(Portfolios[Portfolios$Future.ID==test.ID & Portfolios$Period=="P1",1:15]),test.ID)
#   as.numeric(Portfolios[Portfolios$Future.ID==test.ID & Portfolios$Period=="P1",1:17])
#  test shows method is ok !

length(P1.options)

for (j in 1:length(P1.options))
{
j<-9
#Choose one portfolio
  P1.selection<-P1.options[[j]]
#Transform selection into binary vector for evaluation
   step1.options<-ifelse(all.names%in%P1.selection==TRUE,1,0)

#once we choose an option for Step 1, then we have to evaluate its reliability

  Vulnerability.P1<-vulnerability.eval.P1(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Desalt.Scenarios.Table,Projects_Chars,step1.options,unique(Futures.Table$Future.ID)[1])
  for (i in unique(Futures.Table$Future.ID)[2:length(unique(Futures.Table$Future.ID))])
  {
    pivot<-vulnerability.eval.P1(dir.model,dir.output,Demand.Scenarios.Table,Climate.Scenarios.Table,GW.Scenarios.Table,Desalt.Scenarios.Table,Projects_Chars,step1.options,i)
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
 Vulnerability.P1_1<-aggregate(Vulnerability.P1[,c("Cost","Reliability","Cost.Regret","Reliability.Regret")],list(Options=Vulnerability.P1$Options),mean)
 Vulnerability.P1_1$Metric<-"Mean"

#do other metrics

#q25
 Vulnerability.P1_0<-aggregate(Vulnerability.P1[,c("Cost","Reliability","Cost.Regret","Reliability.Regret")],list(Options=Vulnerability.P1$Options),function(x){as.numeric(quantile(x,0.25))})
 Vulnerability.P1_0$Metric<-"Q25"

#median
 Vulnerability.P1_2<-aggregate(Vulnerability.P1[,c("Cost","Reliability","Cost.Regret","Reliability.Regret")],list(Options=Vulnerability.P1$Options),function(x){as.numeric(quantile(x,0.50))})
 Vulnerability.P1_2$Metric<-"Q50"

#q75
 Vulnerability.P1_3<-aggregate(Vulnerability.P1[,c("Cost","Reliability","Cost.Regret","Reliability.Regret")],list(Options=Vulnerability.P1$Options),function(x){as.numeric(quantile(x,0.75))})
 Vulnerability.P1_3$Metric<-"Q75"

#q95
  Vulnerability.P1_4<-aggregate(Vulnerability.P1[,c("Cost","Reliability","Cost.Regret","Reliability.Regret")],list(Options=Vulnerability.P1$Options),function(x){as.numeric(quantile(x,0.90))})
  Vulnerability.P1_4$Metric<-"Q90"

#rbind All
  Vulnerability.P1<-rbind( Vulnerability.P1_0,Vulnerability.P1_1,Vulnerability.P1_2,Vulnerability.P1_3,Vulnerability.P1_4)


#Create table for all portfolios
 P1.options.table<-lapply(P1.options,function(x) { data.frame(t(
                                            ifelse(all.names%in%x==TRUE,1,0)
                                             )
                                          )
                                        } )

 P1.options.table<-do.call('rbind',P1.options.table)
 colnames(P1.options.table)<-all.names
 P1.options.table$Options<-1:nrow(P1.options.table)

#merge with Vulnerability table
 Vulnerability.P1<-merge(Vulnerability.P1,P1.options.table,by="Options")

#save options table

 write.csv(Vulnerability.P1,paste(dir.output,"P1_OptionsTable_09_03_2018_full_experiment.csv",sep=""),row.names=FALSE)
 #write.csv(Vulnerability.P1,paste(dir.output,"P1_OptionsTable_05_01_2018_block1.csv",sep=""),row.names=FALSE)
# write.csv(Vulnerability.P1,paste(dir.output,"P1_OptionsTable_09_01_2018_block2.csv",sep=""),row.names=FALSE)


#Plot tradeoff curve
 library(ggplot2)
 Vulnerability.P1$Options<-as.character(Vulnerability.P1$Options)
 ggplot(Vulnerability.P1, aes(Cost.Regret,Reliability.Regret,group=Options))+ geom_point(aes(colour=Options))+geom_text(aes(label=Options))

#Using the tradeoff curve we wee that options 4 and 7 are dominated strategies
#We choose to do more projects in the first step, so we go with Portfolio 2

#Transform selection into binary file
# step1.options<-ifelse(all.names%in%P1.options[[2]]==TRUE,1,0) # selection for block 1
# step1.options<-ifelse(all.names%in%P1.options[[1]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
#print all options
#1
 step1.options<-ifelse(all.names%in%P1.options[[1]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_1_10_03_2018.csv",sep=""),row.names=FALSE)

#2
 step1.options<-ifelse(all.names%in%P1.options[[2]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_2_10_03_2018.csv",sep=""),row.names=FALSE)
#
#3
 step1.options<-ifelse(all.names%in%P1.options[[3]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_3_10_03_2018.csv",sep=""),row.names=FALSE)

#
#4
 step1.options<-ifelse(all.names%in%P1.options[[4]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_4_10_03_2018.csv",sep=""),row.names=FALSE)

#
#5
 step1.options<-ifelse(all.names%in%P1.options[[5]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_5_10_03_2018.csv",sep=""),row.names=FALSE)

#
#6
 step1.options<-ifelse(all.names%in%P1.options[[6]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_6_10_03_2018.csv",sep=""),row.names=FALSE)

#
#7
 step1.options<-ifelse(all.names%in%P1.options[[7]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_7_10_03_2018.csv",sep=""),row.names=FALSE)

#
#8
 step1.options<-ifelse(all.names%in%P1.options[[8]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_8_10_03_2018.csv",sep=""),row.names=FALSE)
#
#9
 step1.options<-ifelse(all.names%in%P1.options[[9]]==TRUE,1,0) # selection for block 2, the only difference is that we do pozo en el obispado first inestead of subalveo la union
 step1.options<-data.frame(t(step1.options))
 colnames(step1.options)<-all.names
#write step 1 options
 write.csv(step1.options,paste(dir.output,"step1_option_9_10_03_2018.csv",sep=""),row.names=FALSE)





 #============================================================================================================================================================================================
 #Section III.1 : Clasification Algorithms for Adaptive Plan -Block 1 Experiment-
 #============================================================================================================================================================================================
#Note: To carry on with the analysis is now necessary to re-run de optimization experiment using OptimFunctionsStep2.r

#using clasification algos to understand the database
  dir.data<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
  dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\P1\\"


#  Portfolios<-read.csv(paste(dir.data,"OptimalPortfolios_26_12_2017_Step2.csv",sep=""))
#  Portfolios<-read.csv(paste(dir.data,"OptimalPortfolios_05_01_2018_Step2.csv",sep=""))
  all.names<-colnames(Portfolios)[1:15]

  P1.selection<-as.numeric(unique(Portfolios[Portfolios$Period=='P1',1:15]))
  P1.selection<-all.names[which(P1.selection==1)]

#Create a data frame for the adaptive plan
#step1.options
 Adaptive.Plan<-data.frame(Future.ID=unique(Portfolios$Future.ID),
                           step1.options= paste(P1.selection,collapse=",")
                           )



#subset to period 2
  remaining.projects<-length(all.names)-length(P1.selection)
  P2<-subset(Portfolios[,c(subset(all.names,!(all.names%in%P1.selection)),"Future.ID")],Portfolios$Period=='P2')
  P2.names<-colnames(P2)[1:remaining.projects]
#create column for portfolio type
  P2$Type<-apply(P2[,1:remaining.projects], 1, paste, collapse=",")

#Number of unique portfolios
  length(unique(P2$Type))
  unique(P2$Type)

#How often each portafolio is used
  table(P2$Type)

#read future Chars
  Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_27_12_2017.csv",sep=""))
#subset
 Futures.Chars<-subset(Futures.Chars,Futures.Chars$Future.ID%in%unique(Portfolios$Future.ID))
#merge future chars
  dim(P2)
   P2<-merge(P2,Futures.Chars[Futures.Chars$Period=='P2',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
  dim(P2)

#Now what happens if we apply clasiffication
# library(C50)
# P2.tree<-C5.0(P2[,c('CurrentSources.HDiff','Demand.cms')],
#                   as.factor(as.character(P2[,'Type'])),
#                  trials=100,costs=NULL)
 #P2.tree
 #summary(P2.tree)
 #plot(P2.tree)

#it performs well and from here I could just develop a technique for trimming the tree
 library(RWeka)
 set.seed(55555)
 P2.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms , data = P2 )
 summary(P2.tree)
 P2.tree

#save selected brances

#Expimerent of 05_01_2018
 branches <-list(
                        branch1=list(names=P2.names[which(c(0,0,0,0,0,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms<=15.76))),
                        branch2=list(names=P2.names[which(c(0,0,0,0,1,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>15.76 &  Demand.cms<=16.75 & CurrentSources.HDiff > 5.35))),
                        branch3=list(names=P2.names[which(c(0,1,0,0,0,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>15.76 &  Demand.cms<=16.75 & CurrentSources.HDiff <= 5.35))),
                        branch4=list(names=P2.names[which(c(0,1,0,1,1,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>16.75 &  Demand.cms<=18.61 & CurrentSources.HDiff > 5.35))),
                        branch5=list(names=P2.names[which(c(1,0,0,0,1,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>16.75 &  Demand.cms<=18.61 & CurrentSources.HDiff <= 5.35))),
                        branch6=list(names=P2.names[which(c(1,1,1,1,1,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>18.61)))
                      )
#test if all futures are contained
  length(c(branches[[1]]$futures,branches[[2]]$futures,branches[[3]]$futures,branches[[4]]$futures,branches[[5]]$futures,branches[[6]]$futures))
  length(unique(c(branches[[1]]$futures,branches[[2]]$futures,branches[[3]]$futures,branches[[4]]$futures,branches[[5]]$futures,branches[[6]]$futures)))

#Update Adaptive PLan
  for (i in 1:length(names(branches)))
  {
   Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID%in%branches[[i]]$futures]<-paste(branches[[i]]$names,collapse=",")
  }

#Now for each brach do the subsequent branches in Period 3
 j<-5
 P3<-subset(Portfolios[,c(subset(all.names,!(all.names%in%c(P1.selection,branches[[j]]$names))),"Future.ID")],Portfolios$Period=='P3')
 P3<-subset(P3,P3$Future.ID%in%branches[[j]]$futures)
 P3.names<-colnames(P3)[1:(ncol(P3)-1)]
 P3.names.5<-P3.names
 #create column for portfolio type
 P3$Type<-apply(P3[,1:(ncol(P3)-1)], 1, paste, collapse=",")
 dim(P3)
  P3<-merge(P3,Futures.Chars[Futures.Chars$Period=='P3',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
 dim(P3)
 set.seed(55555)
 P3.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms , data = P3 )


# Save branches

 branchesP3 <-list(
                        branch1.1=list( names=P3.names.1[which(c(0,0,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[1]]$futures &   Demand.cms <= 17.09)) ),
                        branch1.2=list( names=P3.names.1[which(c(0,0,0,1,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[1]]$futures &  Demand.cms > 17.09)) ),
                        branch2.1=list( names=P3.names.2[which(c(0,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[2]]$futures)) ),
                        branch3.1=list( names=P3.names.3[which(c(0,0,1,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[3]]$futures &  CurrentSources.HDiff > -4.57)) ),
                        branch3.2=list( names=P3.names.3[which(c(1,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[3]]$futures &  CurrentSources.HDiff <= -4.57)) ),
                        branch4.1=list( names=P3.names.4[which(c(0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[4]]$futures  & Demand.cms<=21.05 )) ),
                        branch4.2=list( names=P3.names.4[which(c(1,0,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[4]]$futures  & Demand.cms>21.05 )) ),
                        #branch5.1=list( names=P3.names.5[which(c(0,1,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[5]]$futures &  CurrentSources.HDiff > 1.152128)) ),
                        #branch5.2=list( names=P3.names.5[which(c(1,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[5]]$futures &  CurrentSources.HDiff <= 1.152128)) ),
                        branch5.1=list( names=P3.names.5[which(c(0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[5]]$futures &  CurrentSources.HDiff > 1.152128)) ),
                        branch5.2=list( names=P3.names.5[which(c(1,0,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[5]]$futures &  CurrentSources.HDiff <= 1.152128)) ),
                        branch6=list( names=c(),futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[6]]$futures )))
                      )
#test
  length(c(branchesP3[[1]]$futures,branchesP3[[2]]$futures,branchesP3[[3]]$futures,branchesP3[[4]]$futures,branchesP3[[5]]$futures,branchesP3[[6]]$futures,
           branchesP3[[7]]$futures,branchesP3[[8]]$futures,branchesP3[[9]]$futures,branchesP3[[10]]$futures))
#
 length(unique(c(branchesP3[[1]]$futures,branchesP3[[2]]$futures,branchesP3[[3]]$futures,branchesP3[[4]]$futures,branchesP3[[5]]$futures,branchesP3[[6]]$futures,
                branchesP3[[7]]$futures,branchesP3[[8]]$futures,branchesP3[[9]]$futures,branchesP3[[10]]$futures)))

#Update Adaptive PLan
  for (i in 1:length(names(branchesP3)))
  {
   Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%branchesP3[[i]]$futures]<-paste(branchesP3[[i]]$names,collapse=",")
  }

#Change Adaptive Plan into project columns

#Period 1
 PlanBlock1.P1<-apply(Adaptive.Plan,1,function(x){
                                   step1.options<- strsplit(as.character(x["step1.options"]),",")[[1]];
                                   step1.options<-ifelse(all.names%in%step1.options,1,0);
                                   PlanBlock1<-data.frame(t(step1.options));
                                   PlanBlock1$Future.ID<-x["Future.ID"] ;
                                   return(PlanBlock1)
                                }   )

 PlanBlock1.P1<-do.call("rbind",PlanBlock1.P1)
 PlanBlock1.P1$Period<-"P1"

#Period 2
 PlanBlock1.P2<-apply(Adaptive.Plan,1,function(x){
                                 step2.options<- unique(
                                                        c(
                                                          strsplit(as.character(x["step1.options"]),",")[[1]],
                                                          strsplit(as.character(x["step2.options"]),",")[[1]]
                                                          )
                                                        )
                                 step2.options<-ifelse(all.names%in%step2.options,1,0)
                                  PlanBlock1<-data.frame(t(step2.options));
                                  PlanBlock1$Future.ID<-x["Future.ID"] ;
                                  return(PlanBlock1)
                               }   )

 PlanBlock1.P2<-do.call("rbind",PlanBlock1.P2)
 PlanBlock1.P2$Period<-"P2"

#Period 3
 PlanBlock1.P3<-apply(Adaptive.Plan,1,function(x){
                                 step3.options<- unique(
                                                        c(
                                                          strsplit(as.character(x["step1.options"]),",")[[1]],
                                                          strsplit(as.character(x["step2.options"]),",")[[1]],
                                                          strsplit(as.character(x["step3.options"]),",")[[1]]
                                                          )
                                                        )
                                 step3.options<-ifelse(all.names%in%step3.options,1,0)
                                  PlanBlock1<-data.frame(t(step3.options));
                                  PlanBlock1$Future.ID<-x["Future.ID"] ;
                                  return(PlanBlock1)
                               }   )

 PlanBlock1.P3<-do.call("rbind",PlanBlock1.P3)
 PlanBlock1.P3$Period<-"P3"

#rbind all periods
 PlanBlock1<-rbind(PlanBlock1.P1,PlanBlock1.P2,PlanBlock1.P3)
 colnames(PlanBlock1)<-c(all.names,"Future.ID","Period")
 PlanBlock1$Block<-"Block1"
 PlanBlock1$Policy<-"Block1_Portfolio_2"
 Adaptive.Plan<- PlanBlock1
 Adaptive.Plan$Future.ID<-as.numeric(Adaptive.Plan$Future.ID)
##AFTER EVALUATE VULNERABILITIES
#Evaluate vulnerability of portfolio accross all futures
#Source suppoting options

  dir.model<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
  source(paste(dir.model,"PortfolioEval_SupportingFunctions.r",sep=""))
#
# Future 1
 step1.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P1",all.names])
 step2.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P2",all.names])
 step3.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P3",all.names])
#
Vulnerability.Adaptive.Plan<-vulnerability.eval(dir.model,
                                             dir.output,
                                             Demand.Scenarios.Table,
                                             Climate.Scenarios.Table,
                                             GW.Scenarios.Table,
                                             Desalt.Scenarios.Table,
                                             Projects_Chars,
                                             step1.options,
                                             step2.options,
                                             step3.options,
                                             unique(Adaptive.Plan$Future.ID)[1])


for (i in 2:length(unique(Adaptive.Plan$Future.ID)))
{
  step1.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P1",all.names])
  step2.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P2",all.names])
  step3.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P3",all.names])

pivot<-vulnerability.eval(dir.model,
                                             dir.output,
                                             Demand.Scenarios.Table,
                                             Climate.Scenarios.Table,
                                             GW.Scenarios.Table,
                                             Desalt.Scenarios.Table,
                                             Projects_Chars,
                                             step1.options,
                                             step2.options,
                                             step3.options,
                                             unique(Adaptive.Plan$Future.ID)[i])

 Vulnerability.Adaptive.Plan<-rbind(Vulnerability.Adaptive.Plan,pivot)
}

dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\AdaptivePlan\\"
write.csv(Vulnerability.Adaptive.Plan,paste(dir.output,"Vulnerability_Adaptive_Plan_Block1.csv",sep=""),row.names=FALSE)
#
#read the file
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\AdaptivePlan\\"
 Vulnerability.Adaptive.Plan<-read.csv(paste(dir.output,"Vulnerability_Adaptive_Plan_Block1.csv",sep=""))

#merge with the adaptive plan
 dim(Adaptive.Plan)
 dim(Vulnerability.Adaptive.Plan)
 Adaptive.Plan<-Reduce(function(...) { merge(..., all=TRUE) }, list(Adaptive.Plan, Vulnerability.Adaptive.Plan))
 dim(Adaptive.Plan)

Adaptive.Plan.B1<-Adaptive.Plan

#
#============================================================================================================================================================================================
#Section III.2 : Clasification Algorithms for Adaptive Plan -Block 2 Experiment-
#============================================================================================================================================================================================
#Note: To carry on with the analysis is now necessary to re-run de optimization experiment using OptimFunctionsStep2.r

#using clasification algos to understand the database
 dir.data<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\P1\\"

 Portfolios<-read.csv(paste(dir.data,"OptimalPortfolios_06_03_2018_Step2_Option2.csv",sep=""))
 all.names<-colnames(Portfolios)[1:15]

 P1.selection<-as.numeric(unique(Portfolios[Portfolios$Period=='P1',1:15]))
 P1.selection<-all.names[which(P1.selection==1)]

#Create a data frame for the adaptive plan
#step1.options
Adaptive.Plan<-data.frame(Future.ID=unique(Portfolios$Future.ID),
                          step1.options= paste(P1.selection,collapse=",")
                          )



#subset to period 2
 remaining.projects<-length(all.names)-length(P1.selection)
 P2<-subset(Portfolios[,c(subset(all.names,!(all.names%in%P1.selection)),"Future.ID")],Portfolios$Period=='P2')
 P2.names<-colnames(P2)[1:remaining.projects]
#create column for portfolio type
 P2$Type<-apply(P2[,1:remaining.projects], 1, paste, collapse=",")

#Number of unique portfolios
 length(unique(P2$Type))
 unique(P2$Type)

#How often each portafolio is used
 table(P2$Type)

#read future Chars
# Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_27_12_2017.csv",sep=""))
# Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_16_01_2018.csv",sep=""))
 Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_04_03_2018.csv",sep=""))
#subset
#Futures.Chars<-subset(Futures.Chars,Futures.Chars$Future.ID%in%unique(Portfolios$Future.ID))
#merge future chars
 dim(P2)
  P2<-merge(P2,Futures.Chars[Futures.Chars$Period=='P2',c('Future.ID','WaterTarrifs','gw.factor','desalt.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
 dim(P2)

#Select tarrif scheme under analysis

 P2<-subset(P2,P2$WaterTarrifs=='Current')


#Now what happens if we apply clasiffication
# library(C50)
# P2.tree<-C5.0(P2[,c('CurrentSources.HDiff','Demand.cms')],
#                   as.factor(as.character(P2[,'Type'])),
#                  trials=100,costs=NULL)
#P2.tree
#summary(P2.tree)
#plot(P2.tree)

#it performs well and from here I could just develop a technique for trimming the tree
library(RWeka)
set.seed(55555)
P2.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms+gw.factor+desalt.factor , data = P2 )
summary(P2.tree)
P2.tree

#save selected brances

#Expimerent of 05_01_2018
branches <-list(
                       branch1=list(names=P2.names[which(c(0,0,0,0,1,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms<=15.76 & gw.factor > 0.12 ))),
                       branch2=list(names=P2.names[which(c(0,0,0,0,1,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms<=15.76 & gw.factor <= 0.12 & desalt.factor > -0.066 ))),
                       branch3=list(names=P2.names[which(c(0,0,1,0,0,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms<=15.76 & gw.factor <= 0.12 & desalt.factor <= -0.066 ))),
                       branch4=list(names=P2.names[which(c(0,0,1,0,0,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>15.76 &  Demand.cms<=16.75))),
                       branch5=list(names=P2.names[which(c(0,0,1,0,0,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>16.75 &  Demand.cms<=18.60 & gw.factor > 0.08))),
                       branch6=list(names=P2.names[which(c(0,0,1,0,1,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>16.75 &  Demand.cms<=18.60 & gw.factor <= 0.08))),
                       branch7=list(names=P2.names[which(c(1,1,1,1,1,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>18.60)))
                     )
#test if all futures are contained
 length(c(branches[[1]]$futures,branches[[2]]$futures,branches[[3]]$futures,branches[[4]]$futures,branches[[5]]$futures,branches[[6]]$futures,branches[[7]]$futures))
 length(unique(c(branches[[1]]$futures,branches[[2]]$futures,branches[[3]]$futures,branches[[4]]$futures,branches[[5]]$futures,branches[[6]]$futures,branches[[7]]$futures)))

#Update Adaptive PLan
 for (i in 1:length(names(branches)))
 {
  Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID%in%branches[[i]]$futures]<-paste(branches[[i]]$names,collapse=",")
 }


#Now for each brach do the subsequent branches in Period 3
j<-6
P3<-subset(Portfolios[,c(subset(all.names,!(all.names%in%c(P1.selection,branches[[j]]$names))),"Future.ID")],Portfolios$Period=='P3')
P3<-subset(P3,P3$Future.ID%in%branches[[j]]$futures)
P3.names<-colnames(P3)[1:(ncol(P3)-1)]
P3.names.6<-P3.names

#create column for portfolio type
P3$Type<-apply(P3[,1:(ncol(P3)-1)], 1, paste, collapse=",")
dim(P3)
 P3<-merge(P3,Futures.Chars[Futures.Chars$Period=='P3',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms','desalt.factor')],by='Future.ID')
dim(P3)
set.seed(55555)
P3.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms+gw.factor+desalt.factor , data = P3 )


# Save branches

branchesP3 <-list(
                       branch1.1=list( names=P3.names.1[which(c(0,0,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[1]]$futures &   Demand.cms <= 15.00)) ),
                       branch1.2=list( names=P3.names.1[which(c(0,0,1,0,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[1]]$futures &  Demand.cms > 15.00)) ),
                       branch2.1=list( names=P3.names.2[which(c(0,0,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[2]]$futures &   Demand.cms <= 15.00))  ),
                       branch2.2=list( names=P3.names.2[which(c(0,0,1,0,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[2]]$futures &  Demand.cms > 15.00 ))  ),
                       branch3.1=list( names=P3.names.3[which(c(0,0,0,1,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[3]]$futures)) ),
                       branch4.1=list( names=P3.names.4[which(c(0,0,0,1,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[4]]$futures  & CurrentSources.HDiff > 1.02691 )) ),
                       branch4.2=list( names=P3.names.4[which(c(0,0,0,1,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[4]]$futures  & CurrentSources.HDiff <= 1.02691 )) ),
                       branch5.1=list( names=P3.names.5[which(c(0,0,0,1,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[5]]$futures &  gw.factor > 0.204748)) ),
                       branch5.2=list( names=P3.names.5[which(c(0,0,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[5]]$futures &  gw.factor <= 0.204748)) ),
                       branch6.1=list( names=P3.names.5[which(c(0,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[6]]$futures &   gw.factor > -0.190244)) ),
                       branch6.2=list( names=P3.names.5[which(c(1,1,1,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[6]]$futures &  gw.factor <= -0.190244)) ),
                       branch7=list( names=c(),futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[7]]$futures )))
                     )
#test
 length(c(branchesP3[[1]]$futures,branchesP3[[2]]$futures,branchesP3[[3]]$futures,branchesP3[[4]]$futures,branchesP3[[5]]$futures,branchesP3[[6]]$futures,
          branchesP3[[7]]$futures,branchesP3[[8]]$futures,branchesP3[[9]]$futures,branchesP3[[10]]$futures,branchesP3[[11]]$futures,branchesP3[[12]]$futures))
#
length(unique(c(branchesP3[[1]]$futures,branchesP3[[2]]$futures,branchesP3[[3]]$futures,branchesP3[[4]]$futures,branchesP3[[5]]$futures,branchesP3[[6]]$futures,
         branchesP3[[7]]$futures,branchesP3[[8]]$futures,branchesP3[[9]]$futures,branchesP3[[10]]$futures,branchesP3[[11]]$futures,branchesP3[[12]]$futures)))

#
#Update Adaptive PLan
 for (i in 1:length(names(branchesP3)))
 {
  Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%branchesP3[[i]]$futures]<-paste(branchesP3[[i]]$names,collapse=",")
 }

#
#Period 1
 PlanBlock2.P1<-apply(Adaptive.Plan,1,function(x){
                                   step1.options<- strsplit(as.character(x["step1.options"]),",")[[1]];
                                   step1.options<-ifelse(all.names%in%step1.options,1,0);
                                   PlanBlock2<-data.frame(t(step1.options));
                                   PlanBlock2$Future.ID<-x["Future.ID"] ;
                                   return(PlanBlock2)
                                }   )

 PlanBlock2.P1<-do.call("rbind",PlanBlock2.P1)
 PlanBlock2.P1$Period<-"P1"

#Period 2
 PlanBlock2.P2<-apply(Adaptive.Plan,1,function(x){
                                 step2.options<- unique(
                                                        c(
                                                          strsplit(as.character(x["step1.options"]),",")[[1]],
                                                          strsplit(as.character(x["step2.options"]),",")[[1]]
                                                          )
                                                        )
                                 step2.options<-ifelse(all.names%in%step2.options,1,0)
                                  PlanBlock2<-data.frame(t(step2.options));
                                  PlanBlock2$Future.ID<-x["Future.ID"] ;
                                  return(PlanBlock2)
                               }   )

 PlanBlock2.P2<-do.call("rbind",PlanBlock2.P2)
 PlanBlock2.P2$Period<-"P2"

#Period 3
 PlanBlock2.P3<-apply(Adaptive.Plan,1,function(x){
                                 step3.options<- unique(
                                                        c(
                                                          strsplit(as.character(x["step1.options"]),",")[[1]],
                                                          strsplit(as.character(x["step2.options"]),",")[[1]],
                                                          strsplit(as.character(x["step3.options"]),",")[[1]]
                                                          )
                                                        )
                                 step3.options<-ifelse(all.names%in%step3.options,1,0)
                                  PlanBlock2<-data.frame(t(step3.options));
                                  PlanBlock2$Future.ID<-x["Future.ID"] ;
                                  return(PlanBlock2)
                               }   )

 PlanBlock2.P3<-do.call("rbind",PlanBlock2.P3)
 PlanBlock2.P3$Period<-"P3"

#rbind all periods
 PlanBlock2<-rbind(PlanBlock2.P1,PlanBlock2.P2,PlanBlock2.P3)
 colnames(PlanBlock2)<-c(all.names,"Future.ID","Period")
 PlanBlock2$Block<-"Block2"
 PlanBlock2$Policy<-"Block2_Portfolio_1"
 Adaptive.Plan<- PlanBlock2
 Adaptive.Plan$Future.ID<-as.numeric(Adaptive.Plan$Future.ID)


##AFTER EVALUATE VULNERABILITIES
#Evaluate vulnerability of portfolio accross all futures
#Source suppoting options

 source(paste(dir.model,"PortfolioEval_SupportingFunctions.r",sep=""))

# Future 1
 step1.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P1",all.names])
 step2.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P2",all.names])
 step3.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P3",all.names])
#
Vulnerability.Adaptive.Plan<-vulnerability.eval(dir.model,
                                             dir.output,
                                             Demand.Scenarios.Table,
                                             Climate.Scenarios.Table,
                                             GW.Scenarios.Table,
                                             Desalt.Scenarios.Table,
                                             Projects_Chars,
                                             step1.options,
                                             step2.options,
                                             step3.options,
                                             unique(Adaptive.Plan$Future.ID)[1])


for (i in 2:length(unique(Adaptive.Plan$Future.ID)))
{
  step1.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P1",all.names])
  step2.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P2",all.names])
  step3.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P3",all.names])

pivot<-vulnerability.eval(dir.model,
                                             dir.output,
                                             Demand.Scenarios.Table,
                                             Climate.Scenarios.Table,
                                             GW.Scenarios.Table,
                                             Desalt.Scenarios.Table,
                                             Projects_Chars,
                                             step1.options,
                                             step2.options,
                                             step3.options,
                                             unique(Adaptive.Plan$Future.ID)[i])

 Vulnerability.Adaptive.Plan<-rbind(Vulnerability.Adaptive.Plan,pivot)
}

dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\AdaptivePlan\\"
#write.csv(Vulnerability.Adaptive.Plan,paste(dir.output,"Vulnerability_Adaptive_Plan_Block2.csv",sep=""),row.names=FALSE)

#
#read the file
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\AdaptivePlan\\"
 Vulnerability.Adaptive.Plan<-read.csv(paste(dir.output,"Vulnerability_Adaptive_Plan_Block2.csv",sep=""))

#merge with the adaptive plan
 dim(Adaptive.Plan)
 dim(Vulnerability.Adaptive.Plan)
 Adaptive.Plan<-Reduce(function(...) { merge(..., all=TRUE) }, list(Adaptive.Plan, Vulnerability.Adaptive.Plan))
 dim(Adaptive.Plan)

Adaptive.Plan.B2<-Adaptive.Plan


#============================================================================================================================================================================================
#Section III.3 : Clasification Algorithms for Adaptive Plan -Block 1 Experiment with tarrifs--
#============================================================================================================================================================================================
#Note: To carry on with the analysis is now necessary to re-run de optimization experiment using OptimFunctionsStep2.r

#using clasification algos to understand the database
 dir.data<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\P1\\"

 Portfolios<-read.csv(paste(dir.data,"OptimalPortfolios_06_03_2018_Step2_Option2.csv",sep=""))
 all.names<-colnames(Portfolios)[1:15]

 P1.selection<-as.numeric(unique(Portfolios[Portfolios$Period=='P1',1:15]))
 P1.selection<-all.names[which(P1.selection==1)]

#Create a data frame for the adaptive plan
#step1.options
Adaptive.Plan<-data.frame(Future.ID=unique(Portfolios$Future.ID),
                          step1.options= paste(P1.selection,collapse=",")
                          )



#subset to period 2
 remaining.projects<-length(all.names)-length(P1.selection)
 P2<-subset(Portfolios[,c(subset(all.names,!(all.names%in%P1.selection)),"Future.ID")],Portfolios$Period=='P2')
 P2.names<-colnames(P2)[1:remaining.projects]
#create column for portfolio type
 P2$Type<-apply(P2[,1:remaining.projects], 1, paste, collapse=",")

#Number of unique portfolios
 length(unique(P2$Type))
 unique(P2$Type)

#How often each portafolio is used
 table(P2$Type)

#read future Chars
# Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_27_12_2017.csv",sep=""))
#  Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_16_01_2018.csv",sep=""))
  Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_04_03_2018.csv",sep=""))
#subset
Futures.Chars<-subset(Futures.Chars,Futures.Chars$Future.ID%in%unique(Portfolios$Future.ID))
#merge future chars
 dim(P2)
  P2<-merge(P2,Futures.Chars[Futures.Chars$Period=='P2',c('Future.ID','gw.factor','desalt.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
 dim(P2)

#Now what happens if we apply clasiffication
# library(C50)
# P2.tree<-C5.0(P2[,c('CurrentSources.HDiff','Demand.cms')],
#                   as.factor(as.character(P2[,'Type'])),
#                  trials=100,costs=NULL)
#P2.tree
#summary(P2.tree)
#plot(P2.tree)

#it performs well and from here I could just develop a technique for trimming the tree
library(RWeka)
set.seed(55555)
P2.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms , data = P2 )
summary(P2.tree)
P2.tree

#save selected brances

#Expimerent of 14_01_2018
branches <-list(
                       branch1=list(names=P2.names[which(c(0,0,0,0,0,1,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms<=15.28774))),
                       branch2=list(names=P2.names[which(c(0,0,0,0,0,1,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>15.28774 &  Demand.cms<=16.244195 & CurrentSources.HDiff > -4.567442))),
                       branch3=list(names=P2.names[which(c(0,1,0,0,0,0,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>15.28774 &  Demand.cms<=16.244195 & CurrentSources.HDiff <= -4.567442))),
                       branch4=list(names=P2.names[which(c(0,0,0,1,0,0,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>16.244195 &  Demand.cms<=17.15 & CurrentSources.HDiff > 5.350468))),
                       branch5=list(names=P2.names[which(c(1,0,0,0,0,0,0)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>16.244195 &  Demand.cms<=17.15 & CurrentSources.HDiff <= 5.350468))),
                       branch6=list(names=P2.names[which(c(1,1,1,1,1,1,1)==1)],futures=with(Futures.Chars,subset(Future.ID,Period=='P2' & Demand.cms>17.15)))
                     )
#test if all futures are contained
 length(c(branches[[1]]$futures,branches[[2]]$futures,branches[[3]]$futures,branches[[4]]$futures,branches[[5]]$futures,branches[[6]]$futures))
 length(unique(c(branches[[1]]$futures,branches[[2]]$futures,branches[[3]]$futures,branches[[4]]$futures,branches[[5]]$futures,branches[[6]]$futures)))

#Update Adaptive PLan
 for (i in 1:length(names(branches)))
 {
  Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID%in%branches[[i]]$futures]<-paste(branches[[i]]$names,collapse=",")
 }

#Now for each brach do the subsequent branches in Period 3
 j<-5
 P3<-subset(Portfolios[,c(subset(all.names,!(all.names%in%c(P1.selection,branches[[j]]$names))),"Future.ID")],Portfolios$Period=='P3')
 P3<-subset(P3,P3$Future.ID%in%branches[[j]]$futures)
 P3.names<-colnames(P3)[1:(ncol(P3)-1)]
 P3.names.5<-P3.names
#create column for portfolio type
 P3$Type<-apply(P3[,1:(ncol(P3)-1)], 1, paste, collapse=",")
 dim(P3)
  P3<-merge(P3,Futures.Chars[Futures.Chars$Period=='P3',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
 dim(P3)
 set.seed(55555)
 P3.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms , data = P3 )


# Save branches

## re-run all names, before proceeding)
branchesP3 <-list(
                       branch1.1=list( names=P3.names.1[which(c(0,0,0,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[1]]$futures &    CurrentSources.HDiff > -10.161793 )) ),
                       branch1.2=list( names=P3.names.1[which(c(0,0,0,1,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[1]]$futures  &    CurrentSources.HDiff < -10.161793 )) ),
                       #branch1.3=list( names=P3.names.1[which(c(0,0,0,1,0,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[1]]$futures &  Demand.cms > 17.09 &  CurrentSources.HDiff > -4.567442 )) ),
                       #branch1.4=list( names=P3.names.1[which(c(0,0,0,1,1,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[1]]$futures &  Demand.cms > 17.09 &  CurrentSources.HDiff < -4.567442)) ),
                       branch2.1=list( names=P3.names.2[which(c(0,0,0,1,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[2]]$futures)) ),
                       branch3.1=list( names=P3.names.3[which(c(0,0,1,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[3]]$futures )) ),
                      # branch3.2=list( names=P3.names.3[which(c(1,0,0,0,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[3]]$futures &  CurrentSources.HDiff <= -4.57)) ),
                       branch4.1=list( names=P3.names.4[which(c(0,0,0,0,1,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[4]]$futures  &  Demand.cms < 19.35 )) ),
                       branch4.2=list( names=P3.names.4[which(c(0,1,0,1,0,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[4]]$futures  &  Demand.cms > 19.35 &  CurrentSources.HDiff > -15.175029 )) ),
                       branch4.3=list( names=P3.names.4[which(c(0,1,0,0,0,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[4]]$futures  &  Demand.cms > 19.35 &  CurrentSources.HDiff <= -15.175029 )) ),
                       branch5.1=list( names=P3.names.5[which(c(0,0,1,0,1,1)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[5]]$futures & Demand.cms<=19.35  )) ),
                       branch5.2=list( names=P3.names.5[which(c(1,0,1,0,0,0)==1)],futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[5]]$futures & Demand.cms>19.35  )) ),
                       branch6=list( names=c(),futures= with(Futures.Chars,subset(Future.ID,Period=='P3' & Future.ID%in%branches[[6]]$futures )))
                     )
#test
 length(c(branchesP3[[1]]$futures,branchesP3[[2]]$futures,branchesP3[[3]]$futures,branchesP3[[4]]$futures,branchesP3[[5]]$futures,branchesP3[[6]]$futures,
          branchesP3[[7]]$futures,branchesP3[[8]]$futures,branchesP3[[9]]$futures,branchesP3[[10]]$futures))
#
length(unique(c(branchesP3[[1]]$futures,branchesP3[[2]]$futures,branchesP3[[3]]$futures,branchesP3[[4]]$futures,branchesP3[[5]]$futures,branchesP3[[6]]$futures,
         branchesP3[[7]]$futures,branchesP3[[8]]$futures,branchesP3[[9]]$futures,branchesP3[[10]]$futures)))
#
#Update Adaptive PLan
 for (i in 1:length(names(branchesP3)))
 {
  Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%branchesP3[[i]]$futures]<-paste(branchesP3[[i]]$names,collapse=",")
 }


#Change to columns

#Period 1
 PlanBlock3.P1<-apply(Adaptive.Plan,1,function(x){
                                   step1.options<- strsplit(as.character(x["step1.options"]),",")[[1]];
                                   step1.options<-ifelse(all.names%in%step1.options,1,0);
                                   PlanBlock3<-data.frame(t(step1.options));
                                   PlanBlock3$Future.ID<-x["Future.ID"] ;
                                   return(PlanBlock3)
                                }   )

 PlanBlock3.P1<-do.call("rbind",PlanBlock3.P1)
 PlanBlock3.P1$Period<-"P1"

#Period 2
 PlanBlock3.P2<-apply(Adaptive.Plan,1,function(x){
                                 step2.options<- unique(
                                                        c(
                                                          strsplit(as.character(x["step1.options"]),",")[[1]],
                                                          strsplit(as.character(x["step2.options"]),",")[[1]]
                                                          )
                                                        )
                                 step2.options<-ifelse(all.names%in%step2.options,1,0)
                                  PlanBlock3<-data.frame(t(step2.options));
                                  PlanBlock3$Future.ID<-x["Future.ID"] ;
                                  return(PlanBlock3)
                               }   )

 PlanBlock3.P2<-do.call("rbind",PlanBlock3.P2)
 PlanBlock3.P2$Period<-"P2"

#Period 3
 PlanBlock3.P3<-apply(Adaptive.Plan,1,function(x){
                                 step3.options<- unique(
                                                        c(
                                                          strsplit(as.character(x["step1.options"]),",")[[1]],
                                                          strsplit(as.character(x["step2.options"]),",")[[1]],
                                                          strsplit(as.character(x["step3.options"]),",")[[1]]
                                                          )
                                                        )
                                 step3.options<-ifelse(all.names%in%step3.options,1,0)
                                  PlanBlock3<-data.frame(t(step3.options));
                                  PlanBlock3$Future.ID<-x["Future.ID"] ;
                                  return(PlanBlock3)
                               }   )

 PlanBlock3.P3<-do.call("rbind",PlanBlock3.P3)
 PlanBlock3.P3$Period<-"P3"

#rbind all periods
 PlanBlock3<-rbind(PlanBlock3.P1,PlanBlock3.P2,PlanBlock3.P3)
 colnames(PlanBlock3)<-c(all.names,"Future.ID","Period")
 PlanBlock3$Block<-"Block3"
 PlanBlock3$Policy<-"Block3_Portfolio_4"
#
Adaptive.Plan<- PlanBlock3
Adaptive.Plan$Future.ID<-as.numeric(Adaptive.Plan$Future.ID)

##AFTER EVALUATE VULNERABILITIES

#Evaluate vulnerability of portfolio accross all futures
#Source suppoting options

source(paste(dir.model,"PortfolioEval_SupportingFunctions.r",sep=""))

# Future 1
step1.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P1",all.names])
step2.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P2",all.names])
step3.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P3",all.names])
#
Vulnerability.Adaptive.Plan<-vulnerability.eval(dir.model,
                                            dir.output,
                                            Demand.Scenarios.Table,
                                            Climate.Scenarios.Table,
                                            GW.Scenarios.Table,
                                            Desalt.Scenarios.Table,
                                            Projects_Chars,
                                            step1.options,
                                            step2.options,
                                            step3.options,
                                            unique(Adaptive.Plan$Future.ID)[1])


for (i in 2:length(unique(Adaptive.Plan$Future.ID)))
{
 step1.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P1",all.names])
 step2.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P2",all.names])
 step3.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P3",all.names])

pivot<-vulnerability.eval(dir.model,
                                            dir.output,
                                            Demand.Scenarios.Table,
                                            Climate.Scenarios.Table,
                                            GW.Scenarios.Table,
                                            Desalt.Scenarios.Table,
                                            Projects_Chars,
                                            step1.options,
                                            step2.options,
                                            step3.options,
                                            unique(Adaptive.Plan$Future.ID)[i])

Vulnerability.Adaptive.Plan<-rbind(Vulnerability.Adaptive.Plan,pivot)
}

dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\AdaptivePlan\\"
write.csv(Vulnerability.Adaptive.Plan,paste(dir.output,"Vulnerability_Adaptive_Plan_Block3.csv",sep=""),row.names=FALSE)

#read the file
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\AdaptivePlan\\"
 Vulnerability.Adaptive.Plan<-read.csv(paste(dir.output,"Vulnerability_Adaptive_Plan_Block3.csv",sep=""))

#merge with the adaptive plan
 dim(Adaptive.Plan)
 dim(Vulnerability.Adaptive.Plan)
 Adaptive.Plan<-Reduce(function(...) { merge(..., all=TRUE) }, list(Adaptive.Plan, Vulnerability.Adaptive.Plan))
 dim(Adaptive.Plan)

Adaptive.Plan.B3<-Adaptive.Plan


##AFTER EVALUATE VULNERABILITIES






#rbind all blocks

 Plans<-rbind( PlanBlock1, PlanBlock2, PlanBlock3)
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 write.csv(Plans,paste(dir.output,"AdaptivePlans.csv",sep=""),row.names=FALSE)


#rbind all adaptive plans
 Vulnerabilty.Adaptive.Plans<-rbind(Adaptive.Plan.B1,Adaptive.Plan.B2,Adaptive.Plan.B3)
 dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 write.csv(Vulnerabilty.Adaptive.Plans,paste(dir.output,"VulnerablityAdaptivePlans.csv",sep=""),row.names=FALSE)















#now collect all of branches with their conditions
#b1
  branch1<-c(0,0,0,0,0,1,1) # Demand.cms <= 15.759348
  branch1.names<-P2.names[which(branch1==1)]
  branch1.futures<-Futures.Chars$Future.ID[Futures.Chars$Period=='P2' & Futures.Chars$Demand.cms<=15.759348]
#b2
  branch2<-c(1,1,1,1,1,1,1) # Demand.cms > 17.676395
  branch2.names<-P2.names[which(branch2==1)]
  branch2.futures<-Futures.Chars$Future.ID[Futures.Chars$Period=='P2' & Futures.Chars$Demand.cms > 17.676395]

#b3
    branch3<-c(0,0,0,1,0,0,1) # Demand.cms > 15.759348 Demand.cms <= 17.676395 CurrentSources.HDiff > -18.709843
    branch3.names<-P2.names[which(branch3==1)]
    branch3.futures<-Futures.Chars$Future.ID[Futures.Chars$Period=='P2' & Futures.Chars$Demand.cms > 15.759348 & Futures.Chars$Demand.cms <= 17.676395 & Futures.Chars$CurrentSources.HDiff > -18.709843]
#
#b4
    branch4<-c(1,0,0,0,0,0,0) # Demand.cms > 15.759348 Demand.cms <= 17.676395 CurrentSources.HDiff <= -18.709843
    branch4.names<-P2.names[which(branch4==1)]
    branch4.futures<-Futures.Chars$Future.ID[Futures.Chars$Period=='P2' & Futures.Chars$Demand.cms > 15.759348 & Futures.Chars$Demand.cms <= 17.676395 & Futures.Chars$CurrentSources.HDiff <= -18.709843]


#now do period tree for all branches
#branch 1
  P3<-subset(Portfolios[,c(subset(all.names,!(all.names%in%c(P1.selection,branch1.names))),"Future.ID")],Portfolios$Period=='P3')
  P3<-subset(P3,P3$Future.ID%in%branch1.futures)
  P3.names<-colnames(P3)[1:5]
#create column for portfolio type
  P3$Type<-apply(P3[,1:5], 1, paste, collapse=",")
  dim(P3)
   P3<-merge(P3,Futures.Chars[Futures.Chars$Period=='P3',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
  dim(P3)

  P3.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms , data = P3 )

#
#branch 3
  P3<-subset(Portfolios[,c(subset(all.names,!(all.names%in%c(P1.selection,branch3.names))),"Future.ID")],Portfolios$Period=='P3')
  P3<-subset(P3,P3$Future.ID%in%branch3.futures)
  P3.names<-colnames(P3)[1:5]
#create column for portfolio type
  P3$Type<-apply(P3[,1:5], 1, paste, collapse=",")
  dim(P3)
   P3<-merge(P3,Futures.Chars[Futures.Chars$Period=='P3',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
  dim(P3)

  P3.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms , data = P3 )

#
#branch 4
  P3<-subset(Portfolios[,c(subset(all.names,!(all.names%in%c(P1.selection,branch4.names))),"Future.ID")],Portfolios$Period=='P3')
  P3<-subset(P3,P3$Future.ID%in%branch4.futures)
  P3.names<-colnames(P3)[1:6]
#create column for portfolio type
  P3$Type<-apply(P3[,1:6], 1, paste, collapse=",")
  dim(P3)
   P3<-merge(P3,Futures.Chars[Futures.Chars$Period=='P3',c('Future.ID','gw.factor','CurrentSources.HDiff','Demand.cms')],by='Future.ID')
  dim(P3)

  P3.tree<-J48(as.factor(as.character(Type)) ~ CurrentSources.HDiff + Demand.cms , data = P3 )


#now collect all of branches with their conditions
#b3
    branch3.1.names<-c("Pozo.En.el.Obispado","Subalveo.LaUnion")
    branch3.1.futures<-Futures.Chars[Futures.Chars$Future.ID%in%branch3.futures,]
    branch3.1.futures<-branch3.1.futures$Future.ID[branch3.1.futures$Period=='P3' & branch3.1.futures$CurrentSources.HDiff <= 20]
#
    branch3.2.names<-c("Pozo.En.el.Obispado")
    branch3.2.futures<-Futures.Chars[Futures.Chars$Future.ID%in%branch3.futures,]
    branch3.2.futures<-branch3.2.futures$Future.ID[branch3.2.futures$Period=='P3' & branch3.2.futures$CurrentSources.HDiff > 20]

#b4
    branch4.1.names<-c("VicenteGuerrero","Inyeccion.Inducida")
    branch4.1.futures<-Futures.Chars[Futures.Chars$Future.ID%in%branch4.futures,]
    branch4.1.futures<-branch4.1.futures$Future.ID[branch4.1.futures$Period=='P3' & branch4.1.futures$CurrentSources.HDiff <= -4.5]

#
    branch4.2.names<-c("Cuchillo","Inyeccion.Inducida")
    branch4.2.futures<-Futures.Chars[Futures.Chars$Future.ID%in%branch4.futures,]
    branch4.2.futures<-branch4.2.futures$Future.ID[branch4.2.futures$Period=='P3' & branch4.2.futures$CurrentSources.HDiff > -4.5]

#so after we are done we should be able to evaluate the reliability of the adaptive plan

#for every future I should have the corresponding options step 1, step 2 and step 3

#step1.options
 Adaptive.Plan<-data.frame(Future.ID=unique(Portfolios$Future.ID),
                          step1.options= paste(P1.selection,collapse=","),
                          step2.options= as.character("tbd"),
                          step3.options= as.character("tbd")
                           )

#
#step2.options
 Adaptive.Plan$step2.options<-as.character(Adaptive.Plan$step2.options)
 Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID%in%branch1.futures]<-paste(branch1.names,collapse=",")
 Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID%in%branch2.futures]<-paste(branch2.names,collapse=",")
 Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID%in%branch3.futures]<-paste(branch3.names,collapse=",")
 Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID%in%branch4.futures]<-paste(branch4.names,collapse=",")

#step3.options
 Adaptive.Plan$step3.options<-as.character(Adaptive.Plan$step3.options)

#first process those branches that do not change
 Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%branch1.futures]<-paste(branch1.names,collapse=",")
 Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%branch2.futures]<-paste(branch2.names,collapse=",")

#second process those branche that do change

 Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%subset(branch3.futures,branch3.futures%in%branch3.1.futures)]<-paste(branch3.1.names,collapse=",")
 Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%subset(branch3.futures,branch3.futures%in%branch3.2.futures)]<-paste(branch3.2.names,collapse=",")
 Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%subset(branch4.futures,branch4.futures%in%branch4.1.futures)]<-paste(branch4.1.names,collapse=",")
 Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%subset(branch4.futures,branch4.futures%in%branch4.2.futures)]<-paste(branch4.2.names,collapse=",")


#Now we can evaluate the results of this plan

#Evaluate vulnerability of portfolio accross all futures

dir.output<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\AdaptivePlan\\"

for (i in unique(Adaptive.Plan$Future.ID))
   {
  #   i<-271

     #step 1
     step1.options<- strsplit(as.character(Adaptive.Plan$step1.options[Adaptive.Plan$Future.ID==i]),",")[[1]]
     step1.options<-ifelse(all.names%in%step1.options,1,0)

    #step 2
     step2.options<- unique(c(strsplit(as.character(Adaptive.Plan$step1.options[Adaptive.Plan$Future.ID==i]),",")[[1]],
                              strsplit(as.character(Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID==i]),",")[[1]])
                            )
     step2.options<-ifelse(all.names%in%step2.options,1,0)

    #step 3
     step3.options<- unique(c(strsplit(as.character(Adaptive.Plan$step1.options[Adaptive.Plan$Future.ID==i]),",")[[1]],
                               strsplit(as.character(Adaptive.Plan$step2.options[Adaptive.Plan$Future.ID==i]),",")[[1]],
                               strsplit(as.character(Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID==i]),",")[[1]])
                             )
     step3.options<-ifelse(all.names%in%step3.options,1,0)


     vulnerability.eval(dir.model,
                        dir.output,
                        Demand.Scenarios.Table,
                        Climate.Scenarios.Table,
                        GW.Scenarios.Table,
                        Projects_Chars,
                        step1.options,
                        step2.options,
                        step3.options,
                        i)

    }

#
filenames <- list.files(dir.output, pattern="*.csv", full.names=FALSE)
VulnerabilityAnalysis<-lapply(filenames, function (x) {read.csv(paste(dir.output,x,sep=""))})
VulnerabilityAnalysis<-do.call("rbind",VulnerabilityAnalysis)
#read future Chars
 dir.data<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 Futures.Chars<-read.csv(paste(dir.data,"FuturesChars_27_12_2017.csv",sep=""))

#Change to characters
 VulnerabilityAnalysis$Period<-as.character(VulnerabilityAnalysis$Period)
 Futures.Chars$Period<-as.character(Futures.Chars$Period)

#Merge with Futures Chars
dim(VulnerabilityAnalysis)
 VulnerabilityAnalysis<-Reduce(function(...) { merge(...) }, list(VulnerabilityAnalysis,Futures.Chars[,c('Future.ID','Period','Demand.cms','CurrentSources.HDiff')]))
dim(VulnerabilityAnalysis)

#Vulnerability of doing nothing
dir.vulnerability<-"C:\\Users\\L03054557\\OneDrive - Instituto Tecnologico y de Estudios Superiores de Monterrey\\Edmundo-ITESM\\Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\VulnerabilityAnalysis\\"
write.csv(VulnerabilityAnalysis,paste(dir.vulnerability,"Vulnerability_AdaptivePlan.csv",sep=""),row.names=FALSE)



 Adaptive.Plan$step3.options[Adaptive.Plan$Future.ID%in%branch4.futures]<-paste(branch4.names,collapse=",")



#step 2 options
 c(branch1.futures,branch2.futures,branch3.futures,branch4.futures)



                     rep(P1.selection,10) )
#


ifelse(all.names%in%P1.selection,1,0)


all.names[which(P1.selection==TRUE)]

all.names[]

ifelse(all.names%in%P1.Selection,1,0)

step1.options,
step2.options,
step3.options,



# what about rule classifiers




#we do not need this anymore

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
