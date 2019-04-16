#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

counts.table=args[1]
gtf.name=args[2]
biotype=args[3]
mt=args[4]
if(mt=="TRUE" || mt=="T"){
   mt <- TRUE
}else{
   mt <- FALSE
}
mt2=mt
ribo.proteins=args[5]
if(ribo.proteins=="TRUE" || ribo.proteins=="T"){
   ribo.proteins <- TRUE
}else{
   ribo.proteins <- FALSE
}

file.type=args[6]

percentage.ribo=c(as.numeric(args[7]),as.numeric(args[8])) # DA METTERE DEFAULT X
percentage.mito=c(as.numeric(args[9]),as.numeric(args[10]))# Y
umiXgene=as.numeric(args[11])
thresholdGenes=as.numeric(args[12])
#DATI DEFINE 
#counts.table="setPace.txt"
#gtf.name="Mus_musculus.GRCm38.92.gtf"
#biotype="protein_coding"
#mt=TRUE
#ribo.proteins=TRUE
#file.type="txt"
#percentage.ribo=c(20,70)
#percentage.mito=c(1,100)
#FINE




require("refGenome") || stop("\nMissing refGenome library\n")
  ######
  '%!in%' <- function(x,y)!('%in%'(x,y))
  ######
  




if(file.type=="txt"){
   mainMatrix <- read.table(counts.table, sep="\t", header=T, row.names=1, stringsAsFactors=FALSE)
}else{
   mainMatrix <- read.table(counts.table, sep=",", header=T, row.names=1, stringsAsFactors=FALSE)
}



beg <- ensemblGenome()
basedir(beg) <- getwd()
read.gtf(beg, gtf.name)
annotation <- extractPaGenes(beg)
if(length(biotype) > 0){
  annotation <- annotation[which(annotation$gene_biotype%in%biotype),]
}
  #annotation <- annotation[which(annotation$seqid!="MT"),]
rps <- grep("^RPS",toupper(annotation$gene_name))
  rpl <- grep("^RPL",toupper(annotation$gene_name))
rib=annotation$gene_id[c(rps,rpl)]
  mt=annotation$gene_id[which(annotation$seqid=="MT")]

mmMito=unlist(sapply(mt,FUN=function(x){
return(which(x==rownames(mainMatrix)))

}))

mmRibo=unlist(sapply(rib,FUN=function(x){
return(which(x==rownames(mainMatrix)))

}))  
  
 
 

  
x=colSums(mainMatrix[mmRibo,])/colSums(mainMatrix)*100
y=colSums(mainMatrix[mmMito,])/colSums(mainMatrix)*100



xTest=sapply(x,FUN=function(x){data.table::between(x,percentage.ribo[1],percentage.ribo[2])})
yTest=sapply(y,FUN=function(y){data.table::between(y,percentage.mito[1],percentage.mito[2])})
filteredCells=xTest & yTest
  
  

  
  
beg <- ensemblGenome()
read.gtf(beg, gtf.name)
annotation <- extractPaGenes(beg)

if(mt2==FALSE){
  annotation <- annotation[which(annotation$seqid!="MT"),]
}
if(ribo.proteins==FALSE){
  rps <- grep("^RPS",toupper(annotation$gene_name))
  rpl <- grep("^RPL",toupper(annotation$gene_name))
  rp <- c(rps, rpl)
  annotation <- annotation[setdiff(seq(1,dim(annotation)[1]), rp),]
}

if(length(biotype) > 0){
  annotation <- annotation[which(annotation$gene_biotype%in%biotype),]
}
if(file.type=="txt"){
   tmp0 <- read.table(counts.table, sep="\t", header=T, row.names=1, stringsAsFactors=FALSE)
}else{
   tmp0 <- read.table(counts.table, sep=",", header=T, row.names=1, stringsAsFactors=FALSE)
}
tmp <- tmp0[which(rownames(tmp0)%in%annotation$gene_id),]
tmp <- tmp[order(row.names(tmp)),]
annotation <- annotation[which(annotation$gene_id%in%rownames(tmp)),]
annotation <- annotation[order(annotation$gene_id),]
if(identical(annotation$gene_id, rownames(tmp))){
   tmp.n <- paste(rownames(tmp), annotation$gene_name, sep=":")
   row.names(tmp) <- tmp.n
}

if(file.type=="txt"){
  write.table(tmp, paste("annotated_",counts.table, sep=""), sep="\t", col.names=NA)
    write.table(tmp[,filteredCells], paste("filtered_annotated_",counts.table, sep=""), sep="\t", col.names=NA)

}else{
   write.table(tmp, paste("annotated_",counts.table, sep=""), sep=",", col.names=NA)
  write.table(tmp[,filteredCells], paste("filtered_annotated_",counts.table, sep=""), sep=",", col.names=NA)

}


#SECONDA PARTE


file=counts.table

  data.folder=dirname(file)
positions=length(strsplit(basename(file),"\\.")[[1]])
matrixNameC=strsplit(basename(file),"\\.")[[1]]
counts.table=paste(matrixNameC[seq(1,positions-1)],collapse="")
  matrixName=counts.table
file.type=strsplit(basename(basename(file)),"\\.")[[1]][positions]
scratch.folder=data.folder
counts.table=paste(counts.table,".",file.type,sep="")

 dir <- dir(getwd())
  files <- dir[grep(counts.table, dir)]
  
  if(length(files) == 3){
    files.annotated <- dir[grep("^annotated", dir)]
    output=paste("annotated_",matrixName,".",file.type,sep="")
    input=paste(matrixName,".",file.type,sep="")
    #plotting the genes vs umi all cells
    if(file.type=="txt"){
       tmp0 <- read.table(input, sep="\t", header=T, row.names=1)
       tmp <- read.table(output, sep="\t", header=T, row.names=1)
    }else{
       tmp0 <- read.table(input, sep=",", header=T, row.names=1)
       tmp <- read.table(output, sep=",", header=T, row.names=1)
    }
    genes0 <- list()
    for(i in 1:dim(tmp0)[2]){
      x = rep(0, dim(tmp0)[1])
      x[which(tmp0[,i] >=  umiXgene)] <- 1
      genes0[[i]] <- x
    }
    genes0 <- as.data.frame(genes0)
    genes.sum0 <-  apply(genes0,2, sum)
    umi.sum0 <- apply(tmp0,2, sum)

    genes <- list()
    for(i in 1:dim(tmp)[2]){
      x = rep(0, dim(tmp)[1])
      x[which(tmp[,i] >=  umiXgene)] <- 1
      genes[[i]] <- x
    }
    genes <- as.data.frame(genes)
    genes.sum <-  apply(genes,2, sum)
    umi.sum <- apply(tmp,2, sum)

    pdf(paste(matrixName,"_annotated_genes.pdf",sep=""))
    plot(log10(umi.sum0), genes.sum0, xlab="log10 UMI", ylab="# of genes",
         xlim=c(log10(min(c(umi.sum0 + 1, umi.sum +1))), log10(max(c(umi.sum0 + 1, umi.sum + 1)))),
         ylim=c(min(c(genes.sum0, genes.sum)), max(c(genes.sum0, genes.sum))), type="n")
    points(log10(umi.sum0 + 1), genes.sum0, pch=19, cex=0.2, col="blue")
    points(log10(umi.sum + 1), genes.sum, pch=19, cex=0.2, col="red")
    legend("topleft",legend=c("All","Retained & annotated"), pch=c(15,15), col=c("blue", "red"))

    #/////////////////////////////////////////////

xCoord=log10(colSums(tmp))
b=tmp
b[b<3]=0
b[b>=3]=1
yCoord=colSums(b)


xCoord2=log10(colSums(tmp0))
b2=tmp0
b2[b2<3]=0
b2[b2>=3]=1
yCoord2=colSums(b2)


 plot(yCoord,yCoord2-yCoord,cex=0.2,pch=19,col="purple",xlab="# of genes", ylab="genesWMT&rib - genes-MT-RB")




    #////////////////////////////////////////////////
    dev.off()
  }
fm=read.table(paste("filtered_annotated_",matrixName,".",file.type,sep=""),header=TRUE,row.names=1)
  if(length(intersect(names(which(umi.sum0<thresholdGenes)),colnames(fm)))!=0){
  for(i in intersect(names(which(umi.sum0<thresholdGenes)),colnames(fm))){
    fm=fm[,-which(colnames(fm)==i)]
  
  }
  write.table(fm,paste("filtered_annotated_",matrixName,".",file.type,sep=""),col.names=NA)
  }
  cat("\nannotated_genes.pdf is ready\n")
  write(paste(nrow(tmp0)-nrow(tmp),"filtered genes \n",ncol(tmp0)-ncol(fm),"filtered cells"),"filteredStatistics.txt")




