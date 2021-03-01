##
# STEP 1: PREPARE DATA
#####
#indicate which first period option in the pareto frontier you are analyzing
#for (i in 1:9)
#{
#   i<-1
    Options<-paste(c("Option"),1:9,sep="")
    Option<-Options[i]
    #Option<-"Option1"
#indicate data source directory
  Source<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\Experiment_06_03_2018_Step_2\\"
#Read all files in directory
  dir.data<-paste(Source,Option,"\\",sep="")
  filenames <- list.files(dir.data, pattern="*.csv", full.names=FALSE)
  Portfolios<-lapply(filenames, function (x) {read.csv(paste(dir.data,x,sep=""))})
  Portfolios<-do.call("rbind",Portfolios)
#Change column names
 project.names<-c("Panuco","VicenteGuerrero","Desalination","Cuchillo","Pozos.Ballesteros.Buenos.Aires","Pozo.En.el.Obispado","Campo.de.Pozos.El.Pajonal","Subalveo.LaUnion",
                  "Subalveo.RioConchos","Subalveo.RioPilonChapotal","TunelSanFranciscoII","Pozos.MTYI.Contry","Presa.LaLibertad","Reduccion.ANC","Inyeccion.Inducida")
 id.names<-c("Best.Cost","Best.Reliability","Period","Future.ID")
 colnames(Portfolios)<-c(project.names,id.names)

#Now merge portfolios with futures chars
 dir.futures<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
 Futures.Chars<-read.csv(paste(dir.futures,"FuturesChars_04_03_2018_New.csv",sep=""))
#change gw metrics and delsalt metrics to percent
  Futures.Chars$gw.factor<-Futures.Chars$gw.factor*100
  Futures.Chars$desalt.factor<-Futures.Chars$desalt.factor*100
 ids.futures<-c('Period','ClimateScenario','DemandScenario','WaterTarrifs','DesaltScenario','GWScenario','Future.ID')
#for the purpose of the analysis abbreviate variables
 library(stringr)
#for this analysis we have re-code some of the variables
#only rule,if variables use ".", we need to change this to "_"
 code.book<-c("Demand.cms" = "Demand_cms",
              "gw.factor" = "gw_factor",
              "desalt.factor" = "desalt_factor",
              "CurrentSources.Inflow.mean" = "CsIm",
              "CurrentSources.Inflow.ConsecutiveMonthsBelowHist" = "CsIcmbH",
              "AllSources.Inflow.ConsecutiveMonthsBelowHist" = "AsIcmbH",
              "CurrentSources.Inflow.median" = "CsIM",
              "CurrentSources.Inflow.sd" = "CsIsd"
             )
 colnames(Futures.Chars)<-str_replace_all(colnames(Futures.Chars),code.book)
#define chars of interest
 char.names.all<-subset(colnames(Futures.Chars),!(colnames(Futures.Chars)%in%ids.futures))
 char.names<-c('Demand_cms','gw_factor','desalt_factor','CsIm',
                                                        #'CsIM',
                                                        #'CsIsd',
                                                        'CsIcmbH',
                                                        'AsIcmbH'
                                                        )

##
 dim(Portfolios)
  Portfolios<-Reduce(function(...) { merge(..., all=TRUE) }, list(Portfolios, Futures.Chars))
 dim(Portfolios)
#Determine which tarrif scheme to analyze
 Portfolios<-subset(Portfolios,Portfolios$WaterTarrifs=='Current')

#============================================================================================================================================================================================
#Section III.2 : Clasification Algorithms for Adaptive Plan -Block 2 Experiment-
#============================================================================================================================================================================================
#Note: To carry on with the analysis is now necessary to re-run de optimization experiment using OptimFunctionsStep2.r

#Determine which is the first period selection
  P1.selection<-as.numeric(unique(Portfolios[Portfolios$Period=='P1',project.names]))
  P1.selection<-project.names[which(P1.selection==1)]

#Create a data frame for the adaptive plan
#step1.options
  Adaptive.Plan<-data.frame(Future.ID=unique(Portfolios$Future.ID),
                            step1.options= paste(P1.selection,collapse=",")
                            )
#subset to period 2
  P2.options<-subset(project.names,!(project.names%in%P1.selection))
  P2<-subset(Portfolios,Period=='P2')
#create column for portfolio type
  P2$Type<-apply(P2[,P2.options], 1, paste, collapse=",")
  P2$Type<-as.factor(P2$Type)

# remaining.projects<-length(project.names)-length(P1.selection)
#  P2<-subset(Portfolios[,c(subset(c(project.names,chars.names),!(c(project.names,chars.names)%in%P1.selection)),"Future.ID")],Portfolios$Period=='P2')
#  P2.names<-colnames(P2)[1:remaining.projects]

#Number of unique portfolios
 length(unique(P2$Type))
 unique(P2$Type)

#How often each portafolio is used
 table(P2$Type)

#it performs well and from here I could just develop a technique for trimming the tree
#if you have problems loading the package, see this blog:
#https://www.r-statistics.com/2012/08/how-to-load-the-rjava-package-after-the-error-java_home-cannot-be-determined-from-the-registry/
# for controlling J48 https://rdrr.io/cran/RWeka/man/Weka_control.html
 library(rJava)
 library(RWeka)
 set.seed(55555)
 model<-as.formula(paste("Type","~",paste(char.names,collapse="+"),sep=""))
 P2.tree<-J48(model , control = Weka_control(R=TRUE) ,data = P2 )
 summary(P2.tree)
 P2.tree
#remove lines we do not want
 P2.tree<-capture.output(P2.tree)
 P2.tree<-subset(P2.tree,P2.tree!="")
ind<-unlist(lapply(P2.tree,function(x){sum(which(unlist(strsplit(x, " "))%in%c("J48","pruned","tree","------------------","Size","Tree","Leaves")))}))
P2.tree<-P2.tree[which(ind==0)]

library(plyr)
#first round up thresholds
P2.tree<-unlist(
lapply(P2.tree,function(x){
  y<-unlist(strsplit(x,":"));
  original<-gsub("[^0-9\\.\\-]", "", y[1]);
  new<-round(as.numeric(original),2);
  if (length(y)>1) {
  z<-paste(gsub(original,new,y[1]),y[2],sep=":")
} else {z<-gsub(original,new,y[1])}
return(z)
})
)
P2.tree
#Now put tree in table
 P2.tree<-
rbind.fill(
 lapply(P2.tree, function(x) {
   char.vector<-unlist(strsplit(unlist(strsplit(x,":")),"\\|"));
   node<-data.frame(matrix(char.vector,nrow=1));
   colnames(node)<-paste("X",1:length(char.vector),sep="");
   node
     })
  )
 dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
# write.csv(P2.tree,paste(dir.tree,Option,"\\","P2_Raw.csv",sep=""),row.names=FALSE)

#after pruning the tree
 dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
 P2.tree<-read.csv(paste(dir.tree,Option,"\\","P2_Pruned.csv",sep=""))

#after this I can estime costs
#read project chars
dir.exp<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"
Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_26_12_2017.csv",sep=""))[,c("Project","Total.Investment.Millions")]
Projects_Chars$project.names<-project.names
Projects_Chars$Cost.musd<-Projects_Chars$Total.Investment.Millions/20 #exchange rate for costs 1 usd = 20 MXN
#then just cross the cost
 P2.costs<-as.numeric(subset(Projects_Chars,project.names%in%P2.options)$Cost.musd)
 P2.tree$TotalInvesment<-apply(P2.tree,1,function(x){sum(P2.costs*as.numeric(unlist(strsplit(as.character(x['Type']),","))))})
 P2.tree$TotalInvesment<-round(P2.tree$TotalInvesment)

#change variable names-not yet- better wait till the end
# P2.tree[,c("L1","L2","L3")]<-data.frame (apply(P2.tree[,c("L1","L2","L3")],2,function(x){gsub("Demand.cms", "Demand [cbs]",x)}) )
# P2.tree[,c("L1","L2","L3")]<-data.frame (apply(P2.tree[,c("L1","L2","L3")],2,function(x){gsub("gw.factor", "Ground Water Supply [percent]",x)}) )

#from this table, estimate number of paths, this equal to the number of rows
#from the conditions in column 1 and 2 you can know how many distinct main paths we have
#divide the plotting area accroding to these main paths.
#you can define if the path has subnotes or not, if it does no have, then you need four points only,
#if it has subnodes, then is always 5 nodes

maxY<-20
main.nodes<-max(P2.tree$Main)
hi<-(maxY*2)/(main.nodes-1)

Tree.path<-function(maxY,hi,Type,Main,Sub,Path.ID,TotalInvesment,P1.selection,P2.options,L1,L2,L3){
#option at the end of this path
 Type<-as.numeric(unlist(strsplit(as.character(Type),",")))
if (sum(Type)==0) {
 path.option<-"No Action"
} else {
  path.option<-P2.options[which(Type==1)]
}
if (Sub == 0 ){
Path<- data.frame(Node = c(1.0,2.0,3.0,4.0),
             Node.Type = c("Start","Split","Split","End"),
                     x = c(0.0,0.5,0.5,1.5),
                     y = c(0.0,0.0,maxY-(Main-1)*hi,maxY-(Main-1)*hi),
                 Order = c(1,2,3,4),
                Legend = c(paste(P1.selection,collapse="\n"),
                           paste(L1,L2,sep=" and "),
                           paste(L1,L2,sep=" and "),
                           paste(c(path.option,paste("Cost [million usd] = ",TotalInvesment,sep="")),collapse="\n")
                           ),
               Path.ID = Path.ID
                  ,row.names=NULL)
} else {
Path<- data.frame(Node = c(1.0,2.0,3.0,4.0,5.0,6.0),
             Node.Type = c("Start","Split","Split","Split","Split","End"),
                     x = c(0.0,0.5,0.5,1.0,1.0,1.5),
                     y = c(0.0,0.0,maxY-(Main-1)*hi,maxY-(Main-1)*hi,
                                   maxY-(Main-1)*hi+ifelse(Sub==1,+hi/3,-hi/3),
                                   maxY-(Main-1)*hi+ifelse(Sub==1,+hi/3,-hi/3)),
                                   #maxY-(Main-1)*hi+(hi/2-(Sub-1)*hi),
                                   #maxY-(Main-1)*hi+(hi/2-(Sub-1)*hi)),
                 Order = c(1,2,3,4,5,6),
                 Legend = c(paste(P1.selection,collapse="\n"),
                            paste(L1,L2,sep=" and "),
                            paste(L1,L2,sep=" and "),
                            L3,
                            L3,
                            paste(c(path.option,paste("Cost [million usd] = ",TotalInvesment,sep="")),collapse="\n")
                            ),
                 Path.ID = Path.ID,
                  row.names=NULL
                  )

}
return(Path)
}

P2.tree.Paths<-apply(P2.tree,1,function(x) {
                                   Tree.path(
                                             maxY,
                                             hi,
                                             as.character(x['Type']),
                                             as.numeric(x['Main']),
                                             as.numeric(x['Sub']),
                                             x['Path.ID'],
                                             x['TotalInvesment'],
                                             P1.selection,
                                             P2.options,
                                             as.character(x['L1']),
                                             as.character(x['L2']),
                                             as.character(x['L3'])
                                           )
                                           }
                      )

P2.tree.Paths<-do.call("rbind",P2.tree.Paths)
P2.tree.Paths$P1.Decision<-Option
#translate into english
translate.path<-function(x){
x<-unlist(strsplit( as.character(x),"\n"))
    x<-gsub("Panuco","Panuco Aqueduct",x)
    x<-gsub("VicenteGuerrero","Vicente Guerrero Dam",x)
    x<-gsub("Desalination","Desalination Plant",x)
    x<-gsub("Cuchillo","Cuchillo II Dam",x)
    x<-gsub("Pozos.Ballesteros.Buenos.Aires","Ballesteros-Buenos Aires GW Well",x)
    x<-gsub("Pozo.En.el.Obispado","Obispado GW Well",x)
    x<-gsub("Campo.de.Pozos.El.Pajonal","El Pajonal GW System",x)
    x<-gsub("Subalveo.LaUnion","Riverbed Aquifer: La Union",x)
    x<-gsub("Subalveo.RioConchos","Riverbed Aquifer: Rio Conchos",x)
    x<-gsub("Subalveo.RioPilonChapotal","Riverbed Aquifer: Pilon Chapotal",x)
    x<-gsub("TunelSanFranciscoII","Tunel San Francisco II",x)
    x<-gsub("Pozos.MTYI.Contry","Monterrey Country GW Well",x)
    x<-gsub("Presa.LaLibertad","La Libertad Dam",x)
    x<-gsub("Reduccion.ANC","Efficiency",x)
    x<-gsub("Inyeccion.Inducida","Conjunctive Use",x)
    x<-gsub('Demand_cms',"Demand [cms]",x)
    x<-gsub('gw_factor',"GW Availability [percent]",x)
    x<-gsub('desalt_factor',"Desalination Costs [percent]",x)
    x<-gsub('CsIm',"Mean Inflow to Current Sources [cms]",x)
    x<-gsub('CsIcmbH',"Consecutive Months Below Mean [months]",x)
    x<-gsub('CsIM',"Median Inflow to Current Sources [cms]",x)
    x<-gsub('CsIsd',"SD Inflow to Current Sources [cms]",x)
    x<-gsub('and NA',"",x)
    x<-paste(x,collapse="\n")
return(x)
}
P2.tree.Paths$Legend<-apply(P2.tree.Paths,1,function(x){translate.path(as.character(x['Legend']))})

#write.csv(P2.tree.Paths,paste(dir.tree,Option,"\\","P2_Paths.csv",sep=""),row.names=FALSE)



#ok, the tree is done, now what we need is to run everything do the adaptive plan table and
#we dod this for each node

path.chars<-apply(P2.tree,1,function(x) {

 clog<-c(as.character(x['L1']),as.character(x['L2']),as.character(x['L3']))
 clog<-subset(clog,is.na(clog)==FALSE)
 clog<-paste(clog,collapse=" & ")
 futures<-subset(P2,eval(parse(text=clog)))$Future.ID
 out<-data.frame(Path.ID  = x['Path.ID'],
            Nfutures = length(futures),
            futures = paste(as.character(futures),collapse=","))
}
)

path.chars<-do.call("rbind",path.chars)

#merge with P2.tree
P2.tree<-merge(P2.tree,path.chars,by="Path.ID")
P2.tree
sum(P2.tree$Nfutures)

#now we go for P3 tree.
 P3<-subset(Portfolios,Period=='P3')

 P3.leaves<-function(futures,Type,Path.ID,P2.options,project.names,P1.selection,P3) {
 #first determine options for the node
  P2i.selection<-as.numeric(unlist(strsplit(as.character(Type),",")))
  P2i.selection<-P2.options[which(P2i.selection==1)]
  P3i.options<-subset(project.names,!(project.names%in%c(P1.selection,P2i.selection)))

 if (length(P3i.options)>0)
 {
  #afer this introduce ifelse estament, if P3ioptions is length zero, then end the process
 #now subset the data
  P3i<-subset(P3,Future.ID%in% as.numeric(unlist(strsplit(as.character(futures),","))) )
 #now create "Type" column
  P3i$Type<-apply(P3i[,P3i.options], 1, paste, collapse=",")
  P3i$Type<-as.factor(P3i$Type)

  if (length(unique(P3i$Type))>1){
    model<-as.formula(paste("Type","~",paste(char.names,collapse="+"),sep=""))
    P3i.tree<-J48(model , control = Weka_control(R=TRUE) ,data = P3i )
    # summary(P3i.tree)
    # P3i.tree
    #remove text that we do not want
    P3i.tree<-capture.output(P3i.tree)
    P3i.tree<-subset(P3i.tree,P3i.tree!="")
    ind<-unlist(lapply(P3i.tree,function(x){sum(which(unlist(strsplit(x, " "))%in%c("J48","pruned","tree","------------------","Size","Tree","Leaves")))}))
    P3i.tree<-P3i.tree[which(ind==0)]
    #nowround up thresholds
    P3i.tree<-unlist(
       lapply(P3i.tree,function(x){
                              y<-unlist(strsplit(x,":"));
                              original<-gsub("[^0-9\\.\\-]", "", y[1]);
                              new<-round(as.numeric(original),2);
                               if (length(y)>1) {
                                     z<-paste(gsub(original,new,y[1]),y[2],sep=":")
                              } else {z<-gsub(original,new,y[1])}
                              return(z)
                                   })
                     )
     #P3i.tree
     #Now put tree in table
     library(plyr)
         P3i.tree<-
                   rbind.fill(
                       lapply(P3i.tree, function(x) {
                                        char.vector<-unlist(strsplit(unlist(strsplit(x,":")),"\\|"));
                                        node<-data.frame(matrix(char.vector,nrow=1));
                                        colnames(node)<-paste("X",1:length(char.vector),sep="");
                                        node
                                                     }
                              )
                              )
      #P3i.tree
      #now add path info to table
       P3i.tree$Path.ID<-Path.ID
       P3i.tree$i.options<-paste(P3i.options,collapse=",")
       #P3i.tree
       return(P3i.tree)
     } else {
       P3i.tree<-data.frame(X1=unique(P3i$Type),
                            Path.ID=Path.ID,
                            i.options=paste(P3i.options,collapse=",")
                          )
         #P3i.tree
        return(P3i.tree)
     }

 } else {
   P3i.tree<-NA
   return(P3i.tree)}
 }

P3.tree<-apply(P2.tree,1,function(x){P3.leaves(x['futures'],x['Type'],x['Path.ID'],P2.options,project.names,P1.selection,P3)})
P3.tree<-subset(P3.tree,is.na(P3.tree)==FALSE)
P3.tree<-do.call("rbind.fill",P3.tree)

#subset in P2.tree the path with all projects implemented
 all.id<-unlist(lapply(strsplit(as.character(P2.tree$Type),","),function(x){mean(as.numeric(unique(x)))}))
 all.id<-which(all.id==1)
 all.p2<-data.frame(X1=rep(NA,length(all.id)),
                    X2=rep(0,length(all.id)),
                    Path.ID=P2.tree$Path.ID[P2.tree$Path.ID%in%all.id],
                    i.options=rep("",length(all.id))
                  )
#rbind
  P3.tree<-rbind.fill(P3.tree,all.p2)

dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
#write.csv(P3.tree,paste(dir.tree,Option,"\\","P3_Raw.csv",sep=""),row.names=FALSE)

#rm(list = ls())

#}
#after pruning the tree
dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
P3.tree<-read.csv(paste(dir.tree,Option,"\\","P3_Pruned.csv",sep=""))

#first make sure we have all in order

P3.path.chars<-apply(P3.tree,1,function(x) {
#path futures
  path.futures<-as.character(P2.tree[P2.tree$Path.ID==x['Path.ID'],"futures"])
  path.futures<-as.numeric(unlist(strsplit(path.futures,",")))
if (is.na(x['L1'])==FALSE) {
  clog<-c(as.character(x['L1']))
  P3.path<-subset(P3,Future.ID%in%path.futures)
  futures<-subset(P3.path,eval(parse(text=clog)))$Future.ID
}else {
  futures<-path.futures
}
 out<-data.frame(Sub.Path.ID  = x['Sub.Path.ID'],
            Nfutures = length(futures),
            futures = paste(as.character(futures),collapse=","),row.names=NULL)
}
)

P3.path.chars<-do.call("rbind",P3.path.chars)
P3.path.chars$Sub.Path.ID<-as.numeric(as.character(P3.path.chars$Sub.Path.ID))

P3.tree<-merge(P3.tree,P3.path.chars,by="Sub.Path.ID")
sum(P3.tree$Nfutures)
P3.tree

#finally add the selection for P2
 add<-P2.tree[,c("Path.ID","Type")]
 colnames(add)<-c("Path.ID","P2.selection")

 dim(P3.tree)
 P3.tree<-merge(P3.tree,add,by="Path.ID",all.x=TRUE)
 dim(P3.tree)
 sum(P3.tree$Nfutures)
 P3.tree


#before creating paths build table for simulation Runs
#I have the following
#For period 1
  Adaptive.Plan<-data.frame(Future.ID=unique(Portfolios$Future.ID))
  Adaptive.Plan[project.names]<-0
  Adaptive.Plan[which(colnames(Adaptive.Plan)%in%P1.selection)]<-1
  Adaptive.Plan$Period<-"P1"
#For period 2
 Adaptive.PlanP2<-apply(P2.tree,1,function(x){
  pivot<-data.frame(Future.ID=as.numeric(unlist(strsplit(as.character(x['futures']),","))));
  pivot[project.names]<-0;
  P2.selection<-P2.options[which( as.numeric(unlist(strsplit(as.character(x['Type']),",")))==1) ];
  pivot[which(colnames(pivot)%in%c(P1.selection,P2.selection))]<-1;
  pivot
   }
 )
  Adaptive.PlanP2<-do.call("rbind",Adaptive.PlanP2)
  Adaptive.PlanP2$Period<-"P2"

#For period 3
Adaptive.PlanP3<-apply(P3.tree,1,function(x){
 P2.selection<-P2.options[which( as.numeric(unlist(strsplit(as.character(x['P2.selection']),",")))==1) ];
 pivot<-data.frame(Future.ID=as.numeric(unlist(strsplit(as.character(x['futures']),","))));
 pivot[project.names]<-0;
 P3.options<-as.character(unlist(strsplit(as.character(x['i.options']),",")));
 P3.selection<-P3.options[which( as.numeric(unlist(strsplit(as.character(x['Type']),",")))==1) ];
 pivot[which(colnames(pivot)%in%c(P1.selection,P2.selection,P3.selection))]<-1;
 pivot
  }
)
 Adaptive.PlanP3<-do.call("rbind",Adaptive.PlanP3)
 Adaptive.PlanP3$Period<-"P3"

#
#now put together the three data sets
 Adaptive.Plan<-rbind(Adaptive.Plan,Adaptive.PlanP2,Adaptive.PlanP3)
#
#write file
 dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
# write.csv(Adaptive.Plan,paste(dir.tree,Option,"\\","Adaptive_plan.csv",sep=""),row.names=FALSE)

#test things when ok
#load file
 dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
 Adaptive.Plan<-read.csv(paste(dir.tree,Option,"\\","Adaptive_plan.csv",sep=""))

#review first period
#load file
dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
Adaptive.Plan<-read.csv(paste(dir.tree,Option,"\\","Adaptive_plan.csv",sep=""))
#dimensions
nrow(Adaptive.Plan)==648*3
#columns
unique(project.names%in%colnames(Adaptive.Plan))
#project.names
#colnames(Adaptive.Plan)

#lets check P1
t1<-sapply(Adaptive.Plan[Adaptive.Plan$Period=="P1",project.names],mean)
unique(names(t1[which(t1==1)])%in%P1.selection)

#lets check P2
for (i in 1:nrow(P2.tree))
{
a<-subset(Adaptive.Plan,Adaptive.Plan$Future%in%as.numeric(unlist(strsplit(as.character(P2.tree$futures[i]),","))))
P2.selection<-P2.options[which(as.numeric(unlist(strsplit(as.character(P2.tree$Type[i]),",")))==1)]
t2<-sapply(a[a$Period=="P2",project.names],mean)
print(unique(names(t2[which(t2==1)])%in%c(P1.selection,P2.selection)))
}

#lets'check P3
for (i in 1:nrow(P3.tree))
{
a<-subset(Adaptive.Plan,Adaptive.Plan$Future%in%as.numeric(unlist(strsplit(as.character(P3.tree$futures[i]),","))))
P2.selection<-P2.options[which(as.numeric(unlist(strsplit(as.character(P3.tree$P2.selection[i]),",")))==1)]
P3.options<-unlist(strsplit(as.character(P3.tree$i.options[i]),","))
P3.selection<-P3.options[which(as.numeric(unlist(strsplit(as.character(P3.tree$Type[i]),",")))==1)]
t3<-sapply(a[a$Period=="P3",project.names],mean)
print(unique(names(t3[which(t3==1)])%in%c(P1.selection,P2.selection,P3.selection)))
}

#note: all adaptive trees passed these tests

#=========================
# Vulnerability Evaluation
#======================
for (i in 3:9)
{
#   i<-3
    Options<-paste(c("Option"),1:9,sep="")
    Option<-Options[i]

#Option<-"Option2"
#Change column names
 project.names<-c("Panuco","VicenteGuerrero","Desalination","Cuchillo","Pozos.Ballesteros.Buenos.Aires","Pozo.En.el.Obispado","Campo.de.Pozos.El.Pajonal","Subalveo.LaUnion",
                  "Subalveo.RioConchos","Subalveo.RioPilonChapotal","TunelSanFranciscoII","Pozos.MTYI.Contry","Presa.LaLibertad","Reduccion.ANC","Inyeccion.Inducida")

#load supporting functions
dir.model<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\ModeloRiverware\\"
source(paste(dir.model,"PortfolioEval_SupportingFunctions.r",sep=""))

#load file
dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
Adaptive.Plan<-read.csv(paste(dir.tree,Option,"\\","Adaptive_plan.csv",sep=""))

#Load libraries
 library(reshape2)
 library(data.table)
 library(rgenoud)
 library(snow)

#load experimental files
 dir.scenarios<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\Scenarios\\"
 dir.exp<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsDataTables\\"

#Source suppoting options
  source(paste(dir.model,"PortfolioEval_SupportingFunctions.r",sep=""))

#Read projects characteristics table
 Projects_Chars<-read.csv(paste(dir.exp,"Projects_Chars_26_12_2017.csv",sep=""))
 Projects_Chars$ID_Project<-as.character(Projects_Chars$ID_Project)
#Load futures table
 tariff.scheme<-c("Current","Scheme2")
Futures.Table<-read.csv(paste(dir.exp,"FuturesTable_04_03_2018.csv",sep="")) #UPDATE
#Subset to the tarrifs scheme we are analyzing
Futures.Table<-subset(Futures.Table,Futures.Table$WaterTarrifs==tariff.scheme[1])
#Load Demand Scenarios Table
 Demand.Scenarios.Table<-read.csv(paste(dir.scenarios,"DemandScenarios_16_01_2018.csv",sep=""))
# Demand.Scenarios.Table<-subset(Demand.Scenarios.Table,Demand.Scenarios.Table$WaterTarrifs==tariff.scheme)
#Load Climate Scenarios Table
  Climate.Scenarios.Table<-read.csv(paste(dir.scenarios,"ClimateScenarios_27_12_2017.csv",sep=""))
#Load Grounwater Scenarios Table
  GW.Scenarios.Table<-read.csv(paste(dir.scenarios,"GWScenarios_04_03_2018.csv",sep=""))
#Load Desalt Scenarios Table
 Desalt.Scenarios.Table<-read.csv(paste(dir.scenarios,"DesaltScenarios_04_03_2018.csv",sep=""))

#
# Future 1
step1.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P1",project.names])
step2.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P2",project.names])
step3.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[1] & Adaptive.Plan$Period=="P3",project.names])
#
Vulnerability.Adaptive.Plan<-vulnerability.eval(dir.model,
                                           paste(dir.tree,Option,"\\Reliability\\",sep=""),
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
step1.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P1",project.names])
step2.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P2",project.names])
step3.options<-as.numeric(Adaptive.Plan[Adaptive.Plan$Future.ID==unique(Adaptive.Plan$Future.ID)[i] & Adaptive.Plan$Period=="P3",project.names])

pivot<-vulnerability.eval(dir.model,
                                           paste(dir.tree,Option,"\\Reliability\\",sep=""),
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

dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
write.csv(Vulnerability.Adaptive.Plan,paste(dir.tree,Option,"\\","Vulnerability_Adaptive_Plan.csv",sep=""),row.names=FALSE)


}
###
#load the adaptive plans and analyze them
#
i<-1
Options<-paste(c("Option"),1:9,sep="")
Option<-Options[i]
dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
Vtable<-read.csv(paste(dir.tree,Option,"\\","Vulnerability_Adaptive_Plan.csv",sep=""))
#check for Nas
#P1
summary(Vtable$Reliability[Vtable$Period=="P1"])
unique(subset(Vtable,is.na(Vtable$Reliability)==TRUE)$Future.ID)
#P3
summary(Vtable$Reliability[Vtable$Period=="P2"])
unique(subset(Vtable,is.na(Vtable$Reliability)==TRUE)$Future.ID)
#P3
summary(Vtable$Reliability[Vtable$Period=="P3"])
unique(subset(Vtable,is.na(Vtable$Reliability)==TRUE)$Future.ID)

#Now update table trees so you can have this metric on the branches
#for P1
P1.r<-mean(Vtable$Reliability[Vtable$Period=="P1"],na.rm=TRUE)
P1.r
#for P2
P2.tree.Rs<-apply(P2.tree,1,function(x) {
   data.frame( Reliability= mean(subset(Vtable,Period=="P2" & Future.ID%in%as.numeric(unlist(strsplit(as.character(x['futures']),","))))$Reliability,na.rm=TRUE ),
              Path.ID=x['Path.ID'],
             row.names=NULL)
                            }
              )
P2.tree.Rs<-do.call("rbind",P2.tree.Rs)
P2.tree.Rs
#for P3
P3.tree.Rs<-apply(P3.tree,1,function(x) {
   data.frame( Reliability= mean(subset(Vtable,Period=="P3" & Future.ID%in%as.numeric(unlist(strsplit(as.character(x['futures']),","))))$Reliability,na.rm=TRUE ),
              Sub.Path.ID=x['Sub.Path.ID'],
              row.names=NULL
             )
                            }
              )
P3.tree.Rs<-do.call("rbind",P3.tree.Rs)
P3.tree.Rs

#finally merge with original trees

P2.tree<-merge(P2.tree,P2.tree.Rs,by="Path.ID")
P3.tree<-merge(P3.tree,P3.tree.Rs,by="Sub.Path.ID")



#load


 Adaptive.Plan<-data.frame(Future.ID=unique(Portfolios$Future.ID),
                          step1.options= paste(P1.selection,collapse=",")
                          )



##path option costs
 P3.tree$TotalInvesment<-apply(P3.tree,1,function(x){
                                            P3.costs<-as.numeric(subset(Projects_Chars,project.names%in%unlist(strsplit(as.character(x['i.options']),",")))$Cost.musd)
                                            sum(P3.costs*as.numeric(unlist(strsplit(as.character(x['Type']),","))))
                                            })
 P3.tree$TotalInvesment<-round(P3.tree$TotalInvesment)

#create paths
P3.Tree.path<-function(Type,i.options,Path.i,Sub.Path.ID,Sub,TotalInvesment,L1,P2.tree.Paths){
#option at the end of this path
 path.option<-as.numeric(unlist(strsplit(as.character(Type),",")))
 P3.options<-unlist(strsplit(as.character(i.options),","))
 path.option<-P3.options[which(path.option==1)]
 ##
 #yf<-as.numeric(as.character(subset(P2.tree.Paths,Node.Type=="End" & Path.ID==Path.ID)$y))
 #yf<-1.0
 yf<-subset(P2.tree.Paths,Node.Type=="End" & Path.ID==as.numeric(Path.i))$y
if (Sub == 0 ){
Path<- data.frame(Node = c(1.0,2.0),
             Node.Type = c("Start","End"),
                     x = c(0.0,1.0),
                     y = c(yf,yf),
                 Order = c(1,2),
                Legend = c(L1,
                           paste(path.option,paste("\nCost [million usd] = ",TotalInvesment,sep=""),collapse="\n")
                           ),
               Path.ID = Sub.Path.ID
                  ,row.names=NULL)
} else {
Path<- data.frame(Node = c(1.0,2.0,3.0,4.0),
             Node.Type = c("Start","Split","Split","End"),
                     x = c(0.0,0.5,0.5,1.0),
                     y = c(yf,yf,yf+(hi/4-(Sub-1)*hi/2),yf+(hi/4-(Sub-1)*hi/2)),
                 Order = c(1,2,3,4),
                 Legend = c("",L1,L1,paste(path.option,paste("\nCost [million usd] = ",TotalInvesment,sep=""),collapse="\n")
                            ),
                 Path.ID = Sub.Path.ID,
                  row.names=NULL
                  )

}
return(Path)
}

P3.tree.Paths<-apply(P3.tree,1,function(x) {
                                   P3.Tree.path(
                                                as.character(x['Type']),
                                                as.character(x['i.options']),
                                                as.character(x['Path.ID']),
                                                as.character(x['Sub.Path.ID']),
                                                as.numeric(x['Sub']),
                                                x['TotalInvesment'],
                                                as.character(x['L1']),
                                                P2.tree.Paths
                                                )

                                           }
                      )
#
#create paths
 P3.tree.Paths<-do.call("rbind",P3.tree.Paths)
 P3.tree.Paths$P1.Decision<-Option
 P3.tree.Paths$Legend<-apply(P3.tree.Paths,1,function(x){translate.path(as.character(x['Legend']))})
#add the no action Legend
 P3.tree.Paths[P3.tree.Paths$Node.Type=="End" & P3.tree.Paths$Legend=="","Legend"]<-"No Action"

#write file
 write.csv(P3.tree.Paths,paste(dir.tree,Option,"\\","P3_Paths.csv",sep=""),row.names=FALSE)

 #============================================================================================================================================================================================
 #Section IV.2 : consolidate all paths
 #============================================================================================================================================================================================
 #
 #Read files
 dir.tree<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\AdaptiveTrees\\"
 P2.trees<-data.frame(Options=paste(c("Option"),1:9,sep=""))
 P2.trees<-apply(P2.trees,1,function(x){read.csv(paste(dir.tree,x['Options'],"\\P2_Paths.csv",sep=""),row.names=NULL)})
 P2.trees<-do.call("rbind",P2.trees)
#PrintCosolidated
 write.csv(P2.trees,paste(dir.tree,"Consolidated\\","P2_Paths.csv",sep=""),row.names=FALSE)


#END----


#indicate data source directory
 Source<-"C:\\Users\\L03054557\\OneDrive\\Edmundo-ITESM\\3.Proyectos\\ProyectoAguaMty\\Phase2MTY\\ExperimentsRawOutput\\DynamicOptimalPortfolios\\Experiment_06_03_2018_Step_2\\"



#finish


P3.leaves<-function(P2.options,project.names,P1.selection) {
#first determine options for the node
 P2i.selection<-as.numeric(unlist(strsplit(as.character(P2.tree$Type[i]),",")))
 P2i.selection<-P2.options[which(P2i.selection==1)]
 P3i.options<-subset(project.names,!(project.names%in%c(P1.selection,P2i.selection)))

if (length(P3i.options)>0)
{
 #afer this introduce ifelse estament, if P3ioptions is length zero, then end the process
#now subset the data
 P3i<-subset(P3,Future.ID%in% as.numeric(unlist(strsplit(as.character(P2.tree$futures[i]),","))) )
#now create "Type" column
 P3i$Type<-apply(P3i[,P3i.options], 1, paste, collapse=",")
 P3i$Type<-as.factor(P3i$Type)
 model<-as.formula(paste("Type","~",paste(char.names,collapse="+"),sep=""))
 P3i.tree<-J48(model , control = Weka_control(R=TRUE) ,data = P3i )
# summary(P3i.tree)
# P3i.tree
#remove text that we do not want
 P3i.tree<-capture.output(P3i.tree)
 P3i.tree<-subset(P3i.tree,P3i.tree!="")
 ind<-unlist(lapply(P3i.tree,function(x){sum(which(unlist(strsplit(x, " "))%in%c("J48","pruned","tree","------------------","Size","Tree","Leaves")))}))
 P3i.tree<-P3i.tree[which(ind==0)]
#nowround up thresholds
P3i.tree<-unlist(
lapply(P3i.tree,function(x){
  y<-unlist(strsplit(x,":"));
  original<-gsub("[^0-9\\.\\-]", "", y[1]);
  new<-round(as.numeric(original),2);
  if (length(y)>1) {
  z<-paste(gsub(original,new,y[1]),y[2],sep=":")
} else {z<-gsub(original,new,y[1])}
return(z)
})
)
#P3i.tree
#Now put tree in table
 P3i.tree<-
rbind.fill(
 lapply(P3i.tree, function(x) {
   char.vector<-unlist(strsplit(unlist(strsplit(x,":")),"\\|"));
   node<-data.frame(matrix(char.vector,nrow=1));
   colnames(node)<-paste("X",1:length(char.vector),sep="");
   node
     })
  )
#P3i.tree
#now add path info to table
P3i.tree$Path.ID<-P2.tree$Path.ID[i]
P3i.tree
} else {
  P3i.tree<-NULL
  P3i.tree}
}








#now start with the first condition

ifelse(is.na(P2.tree$L2[1])==TRUE,NULL,P2.tree$L2[1])

i<-3

x<-paste(ifelse(is.na(P2.tree$L1[i])==TRUE,"",as.character(P2.tree$L1[i])),
      ifelse(is.na(P2.tree$L2[i])==TRUE,"",as.character(P2.tree$L2[i])),
      ifelse(is.na(P2.tree$L3[i])==TRUE,"",as.character(P2.tree$L3[i])),sep=" & ")

#from P2, we extract future IDs, then we subset those in P3 and run the analysis
futures<-subset(P2,eval(parse(text=x)))
dim(futures)


futures<-subset(P2,Demand.cms > 16.746206)
dim(futures)

x<-as.formula(x)

#substract condition for subsetting

#it performs well and from here I could just develop a technique for trimming the tree
  library(RWeka)
  set.seed(55555)
  model<-as.formula(paste("Type","~",paste(char.names,collapse="+"),sep=""))
  P2.tree<-J48(model , data = P2 )
  summary(P2.tree)
  P2.tree

P2.tree<-capture.output(P2.tree)





Tree.path(maxY,hi,P2.tree$Main[5],P2.tree$Sub[5])

##
#if path does not have subnodes
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1,y=maxY-2*hi,order = 3 )
  p3<-c(x=1.5,y=maxY-2*hi,order = 4 )
  p4<-c(x=1.5,y=maxY-2*hi+(hi/2-0*hi,order = 5 )
  p5<-c(x=2.0,y=maxY-2*hi+(hi/2-0*hi),order = 6 )
#
##
 maxY<-5
 main.nodes<-4
 hi<-(maxY*2)/(main.nodes-1)
#path ID 1
#if path does not have subnodes
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1,y=maxY-0*hi,order = 3 )
  p3<-c(x=2,y=maxY-0*hi,order = 4 )

#path ID 2
#if path does not have subnodes
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1,y=maxY-1*hi,order = 3 )
  p3<-c(x=2,y=maxY-1*hi,order = 4 )

#
#path ID 3
#if path does not have subnodes
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1,y=maxY-2*hi,order = 3 )
  p3<-c(x=1.5,y=maxY-2*hi,order = 4 )
  p4<-c(x=1.5,y=maxY-2*hi+(hi/2-0*hi,order = 5 )
  p5<-c(x=2.0,y=maxY-2*hi+(hi/2-0*hi),order = 6 )
#
#path ID 4
#if path does not have subnodes
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1,y=maxY-2*hi,order = 3 )
  p3<-c(x=1.5,y=maxY-2*hi,order = 4 )
  p4<-c(x=1.5,y=maxY-2*hi+(hi/2-1*hi,order = 5 )
  p5<-c(x=2.0,y=maxY-2*hi+(hi/2-1*hi),order = 6 )

#
#path ID 5
#if path does not have subnodes
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1,y=maxY-3*hi,order = 3 )
  p3<-c(x=2,y=maxY-3*hi,order = 4 )




#path ID 2
#if path does not have subnodes
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1,y=hight-1*hi,order = 3 )
  p3<-c(x=2,y=hight-1*hi,order = 4 )



#path ID 2
#if path does have subnotes
  subnodes<-2
  hi.s<-hi/(subnodes-1)
#path 2.1
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1.5,y=hight-2*hi,order = 3 )
  p3<-c(x=1.5,y=hight-2*hi+,order = 3 )

#path ID 3
#if path does not have subnodes
  p0<-c(x=0,y=0,order=1)
  p1<-c(x=1,y=0,order=2)
  p2<-c(x=1,y=hight-3*hi,order = 3 )
  p3<-c(x=2,y=hight-3*hi,order = 4 )


do.call("rbind.fill",test2)

i<-2

#split into strings
 char.vector<-unlist(strsplit(unlist(strsplit(test[i],":")),"\\|"))
 node<-data.frame(matrix(char.vector,nrow=1))
 colnames(node)<-paste("X",1:length(char.vector),sep="")
 node


data.frame(
matrix(

  ,nrow=1)
 )

[4]
unlist(strsplit(test,":"))

strsplit(test,"\\s+")
strsplit(test,"\\s+")
strsplit(test,"\\|")

#doing more systematic work with this
  library(partykit)
  test<-as.party(P2.tree)
  partykit:::.list.rules.party(test)

 #when I do, as.character(P2.tree), the first element tells me for each future.ID, the corresponding classification
library("Rgraphviz")
 ff <- tempfile()
 write_to_dot(P2.tree, ff)
 plot(agread(ff))
