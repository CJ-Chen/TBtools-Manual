#############
#	DEseq2 有重复数据
#############

# 设定工作目录 -- 随后所有的文件从这个
setwd(".")
########
# 从RSEM结果整理出Counts数据
##########
targetFileLists<-list.files(pattern = "*.genes.results") # 这个模式可以设定为1个参数
targetFileLists
counts<-read.table(targetFileLists[1],header=T)[,1];
for(i in 1:length(targetFileLists)){
  counts<-data.frame(counts,read.table(targetFileLists[i],header=T,sep="\t")[,5]);
}
names(counts)<-c("ID",targetFileLists) # 这里可以设定为1个参数
rownames(counts)<-counts[,1]
counts<-counts[,-1]

head(counts)
              # FZX-DY1.genes.results FZX-DY2.genes.results FZX-DY3.genes.results
# Unigene_0                      4.00                 13.00                  1.00
# Unigene_1                   2740.00               3008.00               1993.00
# Unigene_10                   841.00                996.00                815.00
# Unigene_100                  108.88                 91.22                 43.03
# Unigene_1000                1123.55               1490.51               1033.10
# Unigene_10000                  0.00                 20.43                  0.00


# 修饰列名 
colnames(counts)<-gsub(".genes.results","",colnames(counts))
head(counts)
              # FZX-DY1 FZX-DY2 FZX-DY3 FZX-leaves1 FZX-leaves2 FZX-leaves3
# Unigene_0        4.00   13.00    1.00        8.00       19.00       13.00
# Unigene_1     2740.00 3008.00 1993.00     3969.00     2693.00     3197.00
# Unigene_10     841.00  996.00  815.00      342.00      303.00      438.00
# Unigene_100    108.88   91.22   43.03     1088.57      723.97      611.06
# Unigene_1000  1123.55 1490.51 1033.10      852.18      608.65      846.42
# Unigene_10000    0.00   20.43    0.00        0.00        0.00        0.00
              # ZNX-DY1 ZNX-DY2 ZNX-DY3 ZNX-leaves1 ZNX-leaves2 ZNX-leaves3
# Unigene_0        7.00   11.00    7.00       14.00     3394.00       10.00
# Unigene_1     1606.00 2533.00 1801.00     3179.00      718.00     3398.00
# Unigene_10     539.00  428.00  531.00      404.00      198.00      347.00
# Unigene_100     17.63    4.36    0.00        0.00        0.00       27.17
# Unigene_1000   938.31 1026.63 1013.52      721.19       23.70      757.79
# Unigene_10000  101.19   72.66  128.27      573.59      219.28      322.41

 
# 
# 载入响应的R包
library(DESeq2)

# 整理对象
# 必须先转换为DESeq对象
colData<-data.frame(colnames(counts),rep("pair-end",length(colnames(counts))))
names(colData)<-c("sample","type")
# ！！！！！！！！！！！！！！！ 这里要视具体样本情况而定
# 去掉末尾的数值，取得样本条件
condition<-rep(unique(gsub("\\d+$","",colData$sample,perl=T)),each=3)
condition
 # [1] "FZX-DY"     "FZX-DY"     "FZX-DY"     "FZX-leaves" "FZX-leaves"
 # [6] "FZX-leaves" "ZNX-DY"     "ZNX-DY"     "ZNX-DY"     "ZNX-leaves"
# [11] "ZNX-leaves" "ZNX-leaves"
colData<-data.frame(colData,condition)
colData
        # sample     type  condition
# 1      FZX-DY1 pair-end     FZX-DY
# 2      FZX-DY2 pair-end     FZX-DY
# 3      FZX-DY3 pair-end     FZX-DY
# 4  FZX-leaves1 pair-end FZX-leaves
# 5  FZX-leaves2 pair-end FZX-leaves
# 6  FZX-leaves3 pair-end FZX-leaves
# 7      ZNX-DY1 pair-end     ZNX-DY
# 8      ZNX-DY2 pair-end     ZNX-DY
# 9      ZNX-DY3 pair-end     ZNX-DY
# 10 ZNX-leaves1 pair-end ZNX-leaves
# 11 ZNX-leaves2 pair-end ZNX-leaves
# 12 ZNX-leaves3 pair-end ZNX-leaves

# 使用循环，针对每个condition进行差异表达分析

getPaitList<-function(vector){
  list<-c()
  for(i in 1:(length(vector)-1)){
    for(j in (i+1):(length(vector))){
      list<-rbind(list,c(i,j))
    }
  }
  list
}

uniqCondition<-unique(condition)
Pairindex<-getPaitList(uniqCondition)

for(i in 1:nrow(Pairindex)){
	# 获取所有对应index组合
	j<-Pairindex[i,][1]
	k<-Pairindex[i,][2]
	print(paste(uniqCondition[j],uniqCondition[k],sep=" vs "))
	
	sample_1 = uniqCondition[j]
	sample_2 = uniqCondition[k]
	
	curColData<-colData[colData$condition==sample_1 | colData$condition==sample_2,]
	colnames(curColData)<-c("sample","type","curCondition")
	row.names(curColData)<-curColData$sample
	# curCountData<-counts[,which(colnames(counts) %in% curColData$sample)] # 不能用=号,因为会缺失
	curCountData<-counts[,which(colnames(counts) %in% curColData$sample)]
	curCondition<-rep(c(sample_1,sample_2),each=3)
	
	dds <- DESeqDataSetFromMatrix(countData = ceiling(curCountData),
		colData = curColData,
		design =~ curCondition) # factor levels were dropped which had no samples 不影响，因为没有自行去除而已
	# 过滤掉没表达或者几乎不表达的
	# 所有counts 加和 不足10 的 过滤掉
	dds <- dds[rowSums(counts(dds)) > 10,]
	dds
	# 开始做差异表达分析
	dds <- DESeq(dds)
	res <- results(dds)
	resOrdered <- res[order(res$padj),]
	summary(resOrdered)
	# 查看有显著差异的基因的个数
	print(sum(resOrdered$padj < 0.01 & abs(resOrdered$log2FoldChange)>1, na.rm=TRUE))
	# 

	# 输出MAplot... 
	pdf(paste0(sample_1,"_vs_",sample_2,"_MAplot.pdf"))
	# plotMA(res, main="DESeq2", ylim=c(-2,2)) # 不同处理之间差异太大，大量超过 -2 2 这个foldchange 范围
	plotMA(res, main=paste0(sample_1,"_vs_",sample_2,("_MAplot"), ylim=c(-10,10)))
	dev.off()
	
	# 保存结果
	write.table(as.data.frame(resOrdered),
		file=paste0(sample_1,"_vs_",sample_2,"_results.all.xls"),quote=F,sep="\t")
	# 保存符合规定的结果
	write.table(as.data.frame(resOrdered[(!is.na(resOrdered$padj)) & resOrdered$padj < 0.01 & abs(resOrdered$log2FoldChange)>1,]),
		file=paste0(sample_1,"_vs_",sample_2,"_results.padj01.logFC2.xls"),quote=F,sep="\t")
	
}

#########
#	差异表达分析结束，输出一些信息
##########


row.names(colData)<-colData$sample
dds <- DESeqDataSetFromMatrix(countData = ceiling(counts),
	colData = colData,
	design =~ condition)
# # 无重复的条件下...都是零
# summary(res)
# sum(res$padj < 0.1, na.rm=TRUE)
# # 调整adj-pvalue
# res05 <- results(dds, alpha=0.05)
# summary(res05)
# sum(res05$padj < 0.05, na.rm=TRUE)
# #
vsd <- varianceStabilizingTransformation(dds)

library("pheatmap")
sampleDists <- dist(t(assay(vsd)))
library("RColorBrewer")
sampleDistMatrix <- as.matrix(sampleDists)
# rownames(sampleDistMatrix) <- paste(vsd$curCondition, vsd$type, sep="-")
rownames(sampleDistMatrix) <- colnames(vsd)
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(file="sample-vsd-counts-cor.heatmap.pdf",sampleDistMatrix,
clustering_distance_rows=sampleDists,
clustering_distance_cols=sampleDists,
col=colors)

############
#	PCA分析
###############
# plotPCA(vsd, intgroup=c("condition", "type"))
# dev.off()
#

# data <- plotPCA(vsd, intgroup=c("condition", "type"), returnData=TRUE)
library(ggplot2)
data <- plotPCA(vsd, intgroup=c("condition"), returnData=TRUE)
percentVar <- round(100 * attr(data, "percentVar"))

ggplot(data, aes(PC1, PC2, color=condition)) +
geom_point(size=3) +
xlab(paste0("PC1: ",percentVar[1],"% variance")) +
ylab(paste0("PC2: ",percentVar[2],"% variance"))
# 
ggsave("sample-vsd-counts-PCA.pdf")