rm(list=ls())
options(stringsAsFactors = F)
#表达矩阵的样本的相关性：用热图看几个样本之间不同基因的表达量差异

#关于相关性的理解：
cor(1:5,1:5)#一模一样的两组数，相关性为1
cor(1:5,-(1:5))#相反数的两组数，相关性为-1
cor(rnorm(5),rnorm(5))#两组各5个随机数，相关性每次跑都不一样
a=rnorm(5)
b=a*10
cor(a,b)#两组数呈倍数关系，相关性为1
c=a*10+rnorm(5)
cor(a,c)#多了一个rnorm(5)噪音，导致相关性稍稍下降

#数据准备：下载airway数据集
#tips:下载不了的去官网https://www.r-project.org.选择Bioconductor一栏输入airway找下载代码
if (!require("BiocManager", quietly = TRUE))#这个就是官网找的
  install.packages("BiocManager")#BiocManager分为三个包：功能函数包，数据包，注释包(芯片,基因转换)
BiocManager::install("airway")
BiocManager::install("edgeR")
library(airway)
data(airway)#加载airway数据集：气道平滑肌细胞系RNA-Seq实验中每个基因的读取计数
#tips：What is "RNA-Seq" experiment?
#例如：两组样本分别是正常的细胞和不正常的细胞，想要看看是什么遗传机制导致细胞不正常
#通过高通量测序可以告诉我们哪些基因是活跃的，并且转录了多少
exprSet=assay(airway)#获得表达矩阵
dim(exprSet)#64102个基因(行)，八个样本(列)

#+++++++++++++++++++++++++++++++++++++++++++++++++
#相关性检验：
#++++++++++++
cor(exprSet[,1],exprSet[,2])#对第一二个样本检验，发现相关性好；有可能是技术重复or两个中的0太多了
#检测相关性应该看高表达的基因，如果分析时当中有太多没有表达的基因or低表达基因，则分析没有意义

cor(exprSet)#获得每个样本之间相关性的表达矩阵；发现都接近于1
#并不符合实验设计要求，因为八个样本里有处理组和对照组，应该能够分开才对
pheatmap::pheatmap(cor(exprSet))#看不粗来?那添加聚类的注释分析

#为热图添加聚类的注释分析(详细见Script:heatmap.R)
colData(airway)#展示airway数据的列相关信息，也就是样品相关的信息
colData(airway)[,3]#数据集中的factor对样本进行分组
group_list=colData(airway)[,3]#取得分组列表
tmp=data.frame(group_list)#制备样本分组数据框
rownames(tmp)=colnames(airway)#保证样本分组数据框的行名与热图数据列名相同
pheatmap(cor(exprSet),annotation_col = tmp)#？发现咋看出来不明显的

#应该让数据分的开一点，找到真实事件的相关性。
#有些基因在八个样本中表达量都是0，应该删掉没有意义的数据：

#去掉有3个以上为表达量0的样本的基因：
exprSet_new=exprSet[apply(exprSet,1,function(x) sum(x>1)>5),]#每一行和大于5则挑出来
dim(exprSet_new)#数量只剩19481个
##代码分解
apply(exprSet,1,function(x) x>1)#返回矩阵,表达量大于1则返回TRUE
apply(exprSet,1,function(x) sum(x>1))#对每一行求和，TRUE为1，FALSE为0

#提出估计标准差前500的基因：
library("edgeR")
exprSet_new2=log(edgeR::cpm(exprSet_new)+1)#标准化表达矩阵，去除文库大小的差异（不能省略）
exprSet_new=exprSet_new[names(sort(apply(exprSet_new,1,mad),decreasing=T)[1:500]),]
dim(exprSet_new)
##代码拆解：
apply(exprSet_new,1,mad)#返回每一行的估计标准差(可以说是八个样本之间基因表达量变化的差异，类似方差)
#tips：apply返回的不是数据框,而是numeric；所以索引根据位置索引
sort(apply(exprSet_new,1,mad),decreasing=T)#整体行的估计标准差降序排列
sort(apply(exprSet_new,1,mad),decreasing=T)[1:500]#取出前500（可以说这500基因时表达量变化最大的）
names(sort(apply(exprSet_new,1,mad),decreasing=T)[1:500])#取出前500基因的名字(行名)
exprSet_new=exprSet_new[names(sort(apply(exprSet_new,1,mad),decreasing=T)[1:500]),]#根据行名检索

M=cor(log2(exprSet_new+1))#老师写的，为什么要对数据进行log(x+1)处理？
pheatmap(M,annotation_col = tmp)
#+++++++++++++++++++++++++++++++++++++++++++++++++

#不画图怎么办：
dev.off()#1、关一下画板
fileName("XXX.png")#2、保存为图片看 




