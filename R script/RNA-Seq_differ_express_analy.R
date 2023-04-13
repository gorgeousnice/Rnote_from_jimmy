rm(list=ls())
options(stringsAsFactors = F)
#RNA-Seq差异表达分析

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")

#获取数据
library(airway)
data(airway)
exprSet=assay(airway)#获得表达矩阵(八个样本中的基因表达情况)
colnames(exprSet)
group_list=colData(airway)[,3]#获取分组factor
exprSet=exprSet[apply(exprSet,1,function(x) sum(x>1)>5),]#筛选出有分析意义的gene
table(group_list)#分组情况
exprSet[1:4,1:4]#展示16个表达量
boxplot(log(exprSet+1))#看箱线图，中位数多分布在5，不明显

#差异分析：DESeq2法
#画火山图呈现差异表达分析的结果
if(T){
  library(DESeq2)
  
  (colData<- data.frame(row.names=colnames(exprSet),
                   group_list=group_list) )
  dds<-DESeqDataSetFromMatrix(countData= exprSet,
                           colData=colData,
                           design=~group_list)
  tmp_f="airway_DESeq2-dds.Rdata"
  if(!file.exists(tmp_f)){
    dds<-DESeq(dds)
    save(dds, file = tmp_f)
  }
  load(file = tmp_f)
   res <- results(dds,
                 contrast=c("group_list", "trt", "untrt"))
  resOrdered<- res[order(res$padj),]
  head(resOrdered)
  DEG=as.data.frame(resOrdered)
  DESeq2_DEG=na.omit(DEG)
  
  nrDEG=DESeq2_DEG[,c(2,6)]
  colnames(nrDEG)=c('log2FoldChange','pvalue')
}
  colnames(nrDEG)=c("logFC","P.Value")
attach(nrDEG)
plot(logFC,-log10(P.Value))#画图代码
library(ggpubr)
df=nrDEG
df$v=-log10(P.Value)
ggscatter(df,x="logFC",y="v",size=0.5)
df$q=ifelse(df$P.Value>0.01,'stable',
             ifelse(df$logFC >1.5, 'up',
                     ifelse(df$logFC < -1.5, 'down', 'stable'))
)             
table(df$q)
df$name=rownames(df)
ggscatter(df,x="logFC",y="v",size=0.5,color="red")
ggscatter(df,x="logFC",y="v",size = 0.5,
          palette=c("#00AFBB","#E7B800","  #FC4E07"))

 #画火山图需要的logFC,FDR
#logFC:基因相对于在正常组织or样本中的表达差异；
      #e.g.下调4倍：-log2(4)=-2
#FDR：矫正之后的p-value
