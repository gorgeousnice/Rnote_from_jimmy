#读取txt.类型的文件
b=read.table("GSE17215_series_matrix.txt",sep="\t",comment.char = "!",head=T)
##其中：sep分割类型；comment.char标注不读取；
##head=T则excel的第一行作为数据框的列名称；
a=read.table("GSE17215_series_matrix.txt",sep="\t",skip=66,nrows = 22277,head=T)
##a是b的另外一种读法，但是不太推荐，可以用来读中间数据


#修改数据框行名：将第一列转化为行名
rownames(b)=b[,1]#(先加上，再删除)
b<- b[,-1]


#想要把b以代码的形式发给别人R studio专用的格式R.data
save(b,file="b_input.Rdata")#适合大家一起代码
load("b_input.Rdata")#对方直接load进去就可以


#将b数据读出并读出为csv格式
write.csv(b,"GSE17215_series_matrix.csv")
##如果未将第一列转化行名，直接输出会导致多一行行名
##去掉多一行行名的 方法一：将第一列转化为行名（代码在前面）
write.csv(b,"GSE17215_series_matrix.csv",row.names = F)#法二：添加参数(行名也会自动转化)


#读取其他类型的文件
c=read.csv("GSE17215_series_matrix.csv",sep="\t")#e文件读取到R;excel建议转为csv格式来读
d=read.table("SraRunTable.txt",sep="\t",head=T)#读取其他文件

#删除现有环境变量：
rm(list=ls())
#避免将数据框内的相关变量转换成因子:
options(stringsAsFactors=F)
