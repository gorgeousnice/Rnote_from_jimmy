#数据准备
a=read.table("GSE17215_series_matrix.txt",sep="\t",comment.char = "!",head=T)
rownames(a)=a[,1]
a=a[,-1]
a=log2(a)#对数化处理，防止数据的差异过大以及符合正态性；？？？
         #将数据的范围压缩到一个较小的区间内，使得数据更容易处理和分析。

#计算第一行(某一行)数据平均值
a[1,]#数据索引：[row,col]
mean(a[1,])#发现报错：mean只能计算numeric
class(a[1,])#class一下发现数据类型是data.frame
mean(as.numeric(a[1,]))#将数据类型先转化为numeric类型再计算平均数

#计算返回每一行数据的平均值
#方法一：利用类似于C语言的for循环
for(i in 1:nrow(a))#nrow返回数据框行的数目
  {print(mean(as.numeric(a[i,])))}#不能采用赋值的方式输出，因为循环中新值会覆盖旧值
#方法二：利用apply函数***
apply(a,1,mean)# 参数MARGIN=1or2:1是行处理，2是列处理； FUN:整体处理的方法
apply(a,2,max)#返回每一列的最大值

#找探针排序 --找出在样本中表达差异性大的基因
sort(apply(a,1,sd),decreasing=T)#得到每一行的标准差,并从大到小排序，
sort(apply(a,1,sd),decreasing=T)[1:50]#输出前top50行
cg=names(sort(apply(a,1,sd),decreasing=T)[1:50])#top50的探针基因名字 

#如果不选择表达差异性较大的基因画热图：
pheatmap::pheatmap(a[1:50,])#因为很多探针本身就在各个样本中表达，所以热图没有显示明显差异
pheatmap::pheatmap(a[sample(1:nrow(a),50),])#利用sample函数随机取一行，运气好可能能渠取到差异表达的

#利用cg画热图
pheatmap::pheatmap(a[cg,])#选择cg基因绘制的热图差异会很大，后面关于热图还会具体讲

#利用function自定义函数preference
rowmax <- function(x){apply(x,1,max)}#其实有rowMax函数哈哈哈哈

#例如定义一个jimmy函数：对每一行都进行z=y[1]+y[2]-y[3]的运算
jimmy <-function(x)
  {for(i in 1:nrow(x))#nrow返回数据框行的数目
   y=as.numeric(x[i,])
   z=y[1]+y[2]-y[3]
   print(z)}
jimmy(a)#运行函数

 






 