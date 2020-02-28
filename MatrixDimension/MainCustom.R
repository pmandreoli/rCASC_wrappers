 
# etwd("./home")
setwd("/home")
 library("argparser")
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
argv <- parse_args(p)


matrixName=argv$matrixName
format=argv$format
separator=argv$separator
if(separator=="tab"){separator2="\t"}else{separator2=separator} #BUG CORRECTION TAB PROBLEM 
setwd("/data/scratch")
write.table(dim(read.table(paste(matrixName,".",format,sep=""),header=TRUE,row.names=1,sep=separator2)),"dimensions.txt")
