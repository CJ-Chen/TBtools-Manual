####
# 加载所需的R包
#######
# source("http://bioconductor.org/biocLite.R")
# biocLite("edgeR")
# biocLite("DESeq")
library(DESeq)
library(edgeR)


library(ggplot2) # 绘制火山图


# 设定工作目录 -- 随后所有的文件从这个
setwd(".")
########
# 基因层面
##########
targetFileLists<-list.files(pattern = "*.genes.results") # 这个模式可以设定为1个参数
targetFileLists
# merged_gene_Counts
# counts
counts<-read.table(targetFileLists[1],header=T)[,1];
for(i in 1:length(targetFileLists)){
  counts<-data.frame(counts,read.table(targetFileLists[i],header=T,sep="\t")[,5]);
}
names(counts)<-c("ID",targetFileLists) # 这里可以设定为1个参数
rownames(counts)<-counts[,1]
counts<-counts[,-1]

head(counts)

keep <- rowSums(cpm(counts)>1) >= 2
counts <- counts[keep,]+1
# conds <- c("Control","Case1","Case2")
conds<-colnames(counts)
# 由于edgeR要求counts是整数，所以对齐进行向上取整，如何取整看心情
cds <- newCountDataSet(ceiling(counts), conds)

getPaitList<-function(vector){
  list<-c()
  for(i in 1:(length(vector)-1)){
    for(j in (i+1):(length(vector))){
      list<-rbind(list,c(i,j))
    }
  }
  list
}
c1<-c("a","b","c")
# getPaitList(c1)


# 直接使用变量连接，之后可以形成pipelines
Pairindex<-getPaitList(colnames(counts))
for(i in 1:nrow(Pairindex)){
  # 获取所有对应index组合
  j<-Pairindex[i,][1]
  k<-Pairindex[i,][2]
  print(paste(j,k))
  
  
  # 这个图没什么用
  cds1 = cds[,c(j,k)]
  cds1 <- estimateSizeFactors(cds1)
  cds1 <- estimateDispersions(cds1, method="blind", sharingMode="fit-only",fitType="local")
  pdf(file=paste0(colnames(counts)[j],"_",colnames(counts)[k],"_Dispersion.pdf"))
  plotDispEsts(cds1)
  dev.off()
  
  res1 <- nbinomTest(cds1, colnames(counts)[j], colnames(counts)[k])
  r1 <- res1[!is.na(res1$padj),]
  r1<-(r1[order(r1[,7],decreasing=F),])
  write.table(r1,file=paste0(colnames(counts)[j],"_",colnames(counts)[k],"_DEbyDESeqAll.xls"),row.names=F,sep="\t",quote=FALSE)
  
  
  
  vocanoP<-(data.frame(r1$log2FoldChange,log2(r1$pval)))
  names(vocanoP)<-c("log2FoldChange","log2Pvalue")
  
  p<-ggplot(vocanoP)+geom_point(aes(x=log2FoldChange,y=abs(log2Pvalue),color=!(abs(log2FoldChange)>=1& log2Pvalue<=log2(0.05))),size=1)+theme_bw()+
  theme(
    legend.position = "none",
    plot.background = element_blank(),
    # axis.line = element_line(color = 'black'),
    panel.border = element_rect(linetype = "solid", color="black"),
    # panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
    )
    ggsave(p,file=paste0(colnames(counts)[j],"_",colnames(counts)[k],"_vocanoPlot.pdf"))
  #dev.off()

  
  pdf(file=paste0(colnames(counts)[j],"_",colnames(counts)[k],"_MAPlot.pdf"))
  DESeq::plotMA(res1)
  dev.off()
  # 一般无重复进行BH矫正，会过分严格，干脆不矫正，直接限制pvalue
  r1 <- r1[abs(r1$log2FoldChange)>1 & r1$pval<0.05,]
  write.table(r1,file=paste0(colnames(counts)[j],"_",colnames(counts)[k],"_DEbyDESeq_log2FC1_pval0.05.xls"),row.names=F,sep="\t",quote=FALSE)   
  
  
}




#  res1 <- nbinomTest(cds1, colnames(counts)[j], colnames(counts)[k])
#  r1 <- res1[!is.na(res1$padj),]
#  r1<-(r1[order(r1[,7],decreasing=F),])
#  write.table(r1,file=paste0(colnames(counts)[j],"_",colnames(counts)[k],"_DEbyDESeqAll.xls"),row.names=F,sep="\t",quote=FALSE)
  

#   dev.off()
  
  
  