#commentata per galaxy
#setwd("./home")
 #source("functions.R")
 #library("SIMLR")
 library("argparser")
 #library(dplyr)
 #library("vioplot")
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "nCluster", help="First cluster number ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "finalName", help="matrix separator ")


argv <- parse_args(p)



#argv=list()
#argv$matrixName="New_Buettner"
#argv$nCluster=3
#argv$format="csv"
#argv$separator=","
matrixName=argv$matrixName
nCluster=as.numeric(argv$nCluster)
format=argv$format
separator=argv$separator
finalName=argv$finalName

if(separator=="tab"){separator2="\t"}else{separator2=separator}
#commentata per galaxy
#setwd("./../scratch")
clustering.output=read.table(paste("./",matrixName,"/",nCluster,"/",matrixName,"_clustering.output.",format,sep=""),header=TRUE,sep=separator2)
label=as.matrix(read.table(paste("./",matrixName,"_Label.",format,sep=""),header=TRUE,sep=separator2,row.names=1))
mainVector=clustering.output[,2]
dataPlot=cbind(clustering.output[,3],clustering.output[,4])
finalScore=read.table(paste("./",matrixName,"/",nCluster,"/",matrixName,"_scoreSum.",format,sep=""),header=FALSE,sep=separator2,row.names=1)
colnameLabel=c()
for(i in 1:max(label[,1])){
try=as.numeric(label[,1])
colnameLabel=append(colnameLabel,paste(label[which(try==i)[1],2]))

}   


pdf(paste("./",matrixName,"/",nCluster,"/",matrixName,"_labelGraph_",finalName,".pdf",sep=""))
  colours=rainbow(max(label[,1]))
     par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
     par(xpd=TRUE)
     plot(1, main=paste(matrixName," Clustering"),type="n", xlab="X component", ylab="Y component", xlim=c(min(dataPlot[,1]),max(dataPlot[,1])), ylim=c(min(dataPlot[,2]),max(dataPlot[,2])))
     t25=which(finalScore<=0.25)
     t50=which(finalScore>0.25 & finalScore<=0.50)
     t75=which(finalScore>0.50 & finalScore <=0.75)
     t100=which(finalScore>0.75 & finalScore <=1)
     colt25=colours[as.numeric(label[,1][t25])]
     colt50=colours[as.numeric(label[,1][t50])]
     colt75=colours[as.numeric(label[,1][t75])]
     colt100=colours[as.numeric(label[,1][t100])]

     points(dataPlot[t25,],pch=0,cex=0.5,col=colt25)
     points(dataPlot[t50,],pch=1,cex=0.5,col=colt50)
     points(dataPlot[t75,],pch=2,cex=0.5,col=colt75)
     points(dataPlot[t100,],pch=3,cex=0.5,col=colt100)
     
 

     legend("topright", inset=c(-0.338,0),legend=c("Cells stable between 0 and 25%","Cells stable between 25% and 50%","Cells stable between 50 and 75%","Cells stable between 75% and 100%"),pch=c(0,1,2,3,4),cex=0.5)
    legend("topright", inset=c(-0.181,0.137),legend=paste(colnameLabel),pch=20,col=colours,cex=0.5)
    
   # labelComponent=matrix(ncol=max(as.numeric(label[,1])))
labelComponent=matrix(ncol=max(as.numeric(label[,1])),nrow=nCluster,0)
for(i in 1:nCluster){

        tempLabelComp=table(label[,1][which(mainVector==i)])
        for(n in 1:nrow(tempLabelComp)){
        labelComponent[i,as.integer(names(tempLabelComp))[n]]=as.integer(tempLabelComp)[n]
        }
   # labelComponent=rbind(labelComponent,table(label[,1][which(mainVector==i)]))
   
    
}
#labelComponent=labelComponent[-1,]
 
colnames(labelComponent)=colnameLabel
rownames(labelComponent)=seq(1:nCluster)
write.table(labelComponent,paste("./",matrixName,"/",nCluster,"/",matrixName,"_labelComponent_",finalName,".",format,sep=""),col.names=NA,sep=separator2,row.names=TRUE)
 for(i in 1:nCluster){
 pie(labelComponent[i,], labels = colnames(labelComponent), main=paste(matrixName,"Cluster number ",i))
}
dev.off()

