custom.theme <-  theme_bw() +
  theme(
    
    panel.border = element_blank(),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line.x = element_line(colour = "black", size = 0.8),
    axis.line.y = element_line(colour = "black", size = 0.8),
    axis.ticks.x = element_line(size = 0.8),
    axis.ticks.y = element_line(size = 0.8),
    axis.text.x = element_text(
      angle = 30, hjust = 1, vjust = 1
    ),
    legend.position = "none",
    legend.key = element_blank(),
    legend.title = element_blank(),
    legend.text = element_text(size = 12, face = "bold"),
    legend.background = element_rect(fill = "transparent"),
    strip.background = element_rect(
      colour = "white", fill = "white",
      size = 0.2
    ),
    strip.text.x = element_text(size = 14),
    strip.text.y = element_text(size = 14),
    
    text = element_text(
      size = 14, 
      #family = "arial",
      face = "bold"
    ),
    plot.title = element_text(
      size = 16, 
      #family = "arial",
      face = "bold"
    )
  )


# 绘制小提琴图，查看有miR2275的物种 中 靶位点 和 没有 miR2275 的 物种中 靶位点的数目差异
violinData<-containSpe[Target4Counts$Species%in%containSpe$Species,]
# violinData<-violinData[violinData$TargetSiteRatio!=0,]
violinData<-merge(violinData,Target4Counts)
violinData<-violinData[violinData$GenomeSizeMb>=100,]

head(violinData)

p.value<-t.test(violinData[violinData$isContained==1,]$TargetSiteRatio,violinData[violinData$isContained!=1,]$TargetSiteRatio)$p.value
p.value

library(ggthemes)

ggplot(violinData)+
  geom_violin(aes(x=factor(isContained),fill=factor(isContained),y=TargetSiteRatio),color=I("grey70"),size=1.3,alpha=I(0.7)) +
  # geom_jitter(aes(x=factor(isContained),y=TargetSiteRatio),color=I("black"),size=4) +
  geom_boxplot(aes(x=factor(isContained),y=TargetSiteRatio,fill=factor(isContained)),size=1.5,width=0.2)+
  geom_jitter(aes(x=factor(isContained),y=TargetSiteRatio,fill=factor(isContained),color=I("grey50")),size=2.5,shape=21,stroke=1.2,alpha=I(0.7))+
  
  
  geom_text(x=1.5,y=max(violinData$TargetSiteRatio)*1.05,label=format(p.value,scientific=TRUE,digit=3))+
  geom_segment(x=0.8,xend=2.2,y=max(violinData$TargetSiteRatio)*1.08,yend=max(violinData$TargetSiteRatio)*1.08,size=1.3)+
  geom_text(x=1.5,y=max(violinData$TargetSiteRatio)*1.11,label="**",size=10)+
  ylim(0,max(violinData$TargetSiteRatio)*1.18)+
  xlab("")+
  scale_x_discrete(labels=c("NotContained","Contained"))+
  scale_fill_manual(values=c("#db625e","#78a1c7"))+custom.theme
  
ggsave("violin.pdf",w=4.95,h=8.24)