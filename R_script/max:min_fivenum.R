a=read.table("SraRunTable.txt",head=T,sep="\t")

#根据某一列进行排序
sort(a$MBases)#根据MBase列从小到大排序
sort(a$MBases,decreasing=T)#根据MBase列从大到小排序

max(a$MBases)#返回最大值
min(a$MBases)#返回最小值
fivenum(a$MBases)#返回：最小值、下四分位数、中位数、上四分位数、最大值

b=a[a$MBases<5000,]#取出MBases小于5000的行
View(b)#发现只有一个WXS类型的，说明该种范围设定并不合理
boxplot(a$MBases~a$Assay_Type)#可以通过绘制相亲图查看两种Assay_Type的分布

#故应该通过两组数据分别取出来分开定范围来绘制热图---后面会讲专门的包绘制
wxs=a[a$Assay_Type=="WXS",]#两个等于号才是判断；一个等于号是赋值
rna=a[a$Assay_Type=="RNA-Seq",]#记得加"引号")
fivenum(wxs$MBases)
fivenum(rna$MBases)

 
