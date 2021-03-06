library("argparser")
setwd("/scratch/")
system("chmod -R 777 .")
system("cp ./../home/SCELL/* .")

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
if(separator=="tab"){separator="\t"}

 write.csv(read.table(paste("/scratch/",matrixName,".",format,sep=""),sep=separator,header=TRUE,row.names=1),paste("/scratch/set1.csv",sep=""))
error=system("./run_normalize_samples2.sh /opt/mcr/v90/")
if(error==0){
while(length(which(list.files()=="ciao.csv"))==0){}
lorenz=read.csv("ciao.csv",header=FALSE)
passVector=which(lorenz>=p_value)
system("rm ciao.csv")
system("rm set1.csv")

mainMatrix=read.table(gsub(" ","",paste("/scratch/",matrixName,".",format)),header=TRUE,sep=separator,stringsAsFactors=F,row.names=1)
mainMatrix=mainMatrix[,passVector]
#mainMatrix=log10(mainMatrix+1)
write.table(mainMatrix,paste("/scratch/lorenz_",matrixName,".",format,sep=""),sep=separator,col.names=NA)
}else{
write("Dataset not strong enaugh \n unable to complete fdr algorithm ",paste("/scratch/lorenz_",matrixName,"_ERROR.txt",sep=""))

}
system("rm mccExcludedFiles.log")
system("rm normalize_samples2")
system("rm Readme")
system("rm readme.txt")
system("rm requiredMCRProducts.txt")
system("rm run_normalize_samples2.sh")
