initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)
other.name <- paste(sep="/", script.basename, script.name)


argv <- commandArgs(TRUE)

if(length(argv)<1){
        print("[Usage]:",quote=F)
        print(paste0("        Rscript ",other.name," enrichment.txt"),quote=F)
        q(save="no")
}

KeggEnrichment <- argv[1]
enrichmentInfo <- read.delim(file=KeggEnrichment,header=T);
head(enrichmentInfo)
library(ggplot2)
enrichmentInfoMod<-enrichmentInfo[enrichmentInfo$p.value<=5e-2 & enrichmentInfo$GeneHitsInSelectedSet>=5,]
# enrichmentInfoMod<-enrichmentInfo[enrichmentInfo$p_adjust<=5e-2 & enrichmentInfo$seletedWhiteBalls>=5,]
# enrichmentInfoMod<-enrichmentInfo
if(dim(enrichmentInfoMod)[1]==0) quit(save="no")

head(enrichmentInfoMod)

enrichmentInfoMod$Term.Name<-gsub("^\\s*\\d{5}\\s+","",enrichmentInfoMod$Term.Name,perl=T)


# 按照EnrichementFactor排序
enrichmentInfoMod<-enrichmentInfoMod[order(enrichmentInfoMod$enrichFactor,decreasing=F),]
enrichmentInfoMod$Term.Name<-factor(enrichmentInfoMod$Term.Name,unique(as.character(enrichmentInfoMod$Term.Name)))

p<-ggplot(enrichmentInfoMod)
# 因为q值可能直接不显著
q<-p+geom_point(aes(x=enrichFactor,y=Term.Name,size=GeneHitsInSelectedSet,color=p.value))+scale_colour_gradient(low="red",high="blue")+scale_size_area()+theme_bw()+
# q<-p+geom_point(aes(x=EnrichmentFactor,y=Term.Name,size=NumberOfGeneInSelectedSet,color=p_adjust))+scale_colour_gradient(low="red",high="blue") +theme_bw()+
    theme(
      plot.title=element_text(face="bold",vjust=1.0),
      axis.title.x=element_text(face="bold",vjust=-0.2),
      axis.title.y=element_text(face="bold"),
      axis.text.y=element_text(hjust=1.0,colour="black"),
      axis.text.x=element_text(angle=0,colour="black")
    )+ggtitle("Statistics of KEGG Pathway Enrichment")+
    ylab("Pathway")+
    xlab("Enrichment Factor");
q
tiff(filename = paste0(KeggEnrichment,".KEGGPathwayEnrichment.tiff"),res=300,width=(666*4.17),height=(615*4.17),compression="lzw");
q
dev.off()
ggsave(paste0(KeggEnrichment,".KEGGPathwayEnrichment.pdf"),width=8.5,height=11)