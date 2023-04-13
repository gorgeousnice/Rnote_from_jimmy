#表达矩阵的样本的相关性分析的应用代码apply_code：
#(以分析airway矩阵数据为例)

#数据准备：下载airway数据集
#tips:下载不了的去官网https://www.r-project.org.选择Bioconductor一栏输入airway找下载代码
if (!require("BiocManager", quietly = TRUE))#这个就是官网找的
  install.packages("BiocManager")#BiocManager分为三个包：功能函数包，数据包，注释包(芯片,基因转换)
BiocManager::install("airway")
BiocManager::install("edgeR")
library(airway)
library("edgeR")
data(airway)#加载airway数据集
exprSet=assay(airway)#获得表达矩阵
dim(exprSet)#64102个基因(行)，八个样本(列)

#找到真实事件的相关性，应该删掉没有意义的数据：
#每一行和大于5则挑出来：
exprSet_new=exprSet[apply(exprSet,1,function(x) sum(x>1)>5),]
#标准化表达矩阵，去除文库大小的差异（不能省略）
exprSet_new2=log(edgeR::cpm(exprSet_new)+1)
#取估计标准差前50的基因
exprSet_new=exprSet_new[names(sort(apply(exprSet_new,1,mad),decreasing=T)[1:500]),]
#相关性分析，绘制热图
M=cor(log2(exprSet_new+1))#老师写的，为什么要对数据进行log(x+1)处理？
pheatmap(M,annotation_col = tmp)


