library("argparser")
#setwd("./../scratch/")
#cambiato poichè mi da errore ...la working dir viene settata da galaxy in fase di run del docker
#setwd("./")
#system("chmod -R 777 /opt")
#non serve in caso di galaxy
system("cp /home/SCELL/* .")

p <- arg_parser("matrixName")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "p_value", help="lorenz p_value ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")

argv <- parse_args(p)
matrixName=argv$matrixName
p_value=argv$p_value
format=argv$format
separator=argv$separator
#error=system("./run_normalize_samples2.sh /opt/mcr/v90/")
#non capisco lo slash finale
error=system("./run_normalize_samples2.sh /opt/mcr/v90/")
if(error==0){
while(length(which(list.files()=="ciao.csv"))==0){}
lorenz=read.csv("ciao.csv",header=FALSE)
passVector=which(lorenz>=p_value)
system("rm ciao.csv")
system("rm set1.csv")
if(separator=="tab"){separator="\t"}

#mainMatrix=read.table(gsub(" ","",paste("./../data/",matrixName,".",format)),header=TRUE,sep=separator,stringsAsFactors=F,row.names=1)
#cambiato path read.table per l'input 'l'input si trova all'interno della WD,grazie a un collegamento ln -s dal database alla WD
mainMatrix=read.table(gsub(" ","",paste("/data/",matrixName,".",format)),header=TRUE,sep=separator,stringsAsFactors=F,row.names=1)
mainMatrix=mainMatrix[,passVector]
#mainMatrix=log10(mainMatrix+1)
#write.table(mainMatrix,paste("./../data/lorenz_",matrixName,".",format,sep=""),sep=separator,col.names=NA)
#camnbiato il path dell'outup per redirigerlo nella cartella attuale
write.table(mainMatrix,paste("/data/lorenz_",matrixName,".",format,sep=""),sep=separator,col.names=NA)
}else{
#write("Dataset not strong enaugh \n unable to complete fdr algorithm ",paste("./../data/lorenz_",matrixName,"_ERROR.txt",sep=""))
write("Dataset not strong enaugh \n unable to complete fdr algorithm ",paste("./../data/lorenz_",matrixName,"_ERROR.txt",sep=""))

}
#eliminazione non eseguita poichè la working dir verrà automaticamente eliminata dal sistema quando il job avrà finito
#system("rm mccExcludedFiles.log")
#system("rm normalize_samples2")
#system("rm Readme")
#system("rm readme.txt")
#system("rm requiredMCRProducts.txt")
#system("rm run_normalize_samples2.sh")

