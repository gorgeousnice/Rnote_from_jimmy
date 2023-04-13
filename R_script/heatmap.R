rm(list=ls())#删除所有的环境变量
library(pheatmap)#加载pheatmap包

#数据准备：创建数据集
a1=rnorm(100)#生成100个随机数
dim(a1)=c(5,20)#将a1数据结构类型由向量改成矩阵
a2=rnorm(100)+2#整体随机数据上比a1加2
dim(a2)=c(5,20)
a2=matrix(rnorm(100)+2,5,20)#也可以直接通过matrix函数构建矩阵数据集

#绘制热图
pheatmap(a1)
pheatmap(a2)#发现热图旁边的标尺值改-变比a1加2

#合并a1和a2两个矩阵
pheatmap(cbind(a1,a2))
pheatmap(cbind(a1,a2),cluster_cols = F)#不对列聚类分析，只对行聚类分析

#修改热图里面的列名(在数据框基础上修改)
c=as.data.frame(cbind(a1,a2))#先将矩阵数据类型转化为数据框
pheatmap(c,cluster_cols = F)#以V1...命名
names(c)=paste("a",1:ncol(c),sep = "_")#修改数据框表头，都以a命名
pheatmap(c,cluster_cols = F)
#修改行名&列名：
colnames(c)=c(paste("a1",1:ncol(a1),sep = "_"),paste("a2",1:ncol(a2),sep = "_"))
rownames(c)=c("a","b","c","d","e")#行名
pheatmap(c,cluster_cols = F)#前面以a1，后面以a2命名

#聚类分析(三步走)：
tmp=data.frame(group_list=c(rep("a1",20),rep("a2",20)))#准备分组列表
rownames(tmp)=colnames(c)#保证分组列表的列名与分组行名相同
pheatmap(c,annotation_col = tmp)#绘制热图

#通过运行帮助文档中的实例去学习R包
#某一个函数中的参数不懂就把该参数删掉跑一跑做比较









