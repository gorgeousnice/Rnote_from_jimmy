rm(list=ls())
#+++++++++++++++++++++++++++++++++++++++++++++++++
#芯片表达矩阵下游分析
#+++++++++++++++++++++++

#安装必要包
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("CLL")
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("affy")
#加载包
library(affy)
library(CLL)#CLL包包含慢性淋巴细胞白血病(CLL)基因表达数据。
#CLL数据中有24个样本，根据疾病进展情况被分类为进展或稳定。

#数据获取：
data(sCLLex)
sCLLex
exprSet=exprs(sCLLex)#获取表达矩阵
#SCLLex是依赖于CLL这个package的一个对象
samples=sampleNames(sCLLex)
pdata=pData(sCLLex)
group_list=as.character(pdata[,2])#准备分组列表
dim(exprSet)
exprSet[1:5,1:5]
 
#进行差异分析---直接用代码
# DEG by limma
suppressMessages(library(limma))
design <- model.matrix(~0+factor(group_list))
colnames(design)=levels(factor(group_list))
rownames(design)=colnames(exprSet)
design#样本分组，属于为1，不属于为0
contrast.matrix<-makeContrasts(paste0(unique(group_list),collapse = "-"),levels=design)
contrast.matrix#矩阵把progres组跟stable进行差异分析比较
##step1
fit <- lmFit(exprSet,design)
##step2
fit2<- contrasts.fit(fit, contrast.matrix) ##-#REE
fit2<- eBayes(fit2) ## default no trend !!!
##Bayes with trend-TRUE
##step3
tempOutput = topTable(fit2, coef=1, n=Inf)
nrDEG = na.omit(tempOutput)
#write.csv(nrDEGZ,"limma_notrend.results.csv", quote = F)
head(nrDEG)

#输出的nrDEG就可以拿去画火山图、或者挑选显著的基因，做富集分析等等






