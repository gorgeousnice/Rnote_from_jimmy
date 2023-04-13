#id转换：将ensembl.id转化成Symbol(基因名)

#数据准备
options(stringsAsFactors = F)#在调用as.data.frame函数进行数据类型转化时
                              #防止将字符串转化成因子
a=read.table("ensembl.txt")#Ensembl数据库中对基因的命名
#取数据框的'.'前面的内容
library(stringr)
str_split(a$V1,"[.]")#用'.'讲数据进行分割
str_split(a$V1,"[.]")[1]#列表格式，所以无法将其单独取出
str_split(a$V1,"[.]",simplify = T)[1]#返回matrix类型，可以单独取出
a$ensembl_id=str_split(a$V1,"[.]",simplify = T)[,1] #加到数据框中

#利用R包匹配gene_id和symblo(类似excel的vlookup函数)
#加载数据包
library(org.Hs.eg.db)
g2e=toTable(org.Hs.egENSEMBL)
g2s=toTable(org.Hs.egSYMBOL)
#ensembl_id--g2e--g2s
#检索匹配（合并merge函数）
b=merge(a,g2e,by="ensembl_id")#根据ensembl_id匹配g2e中的gene_id
b=merge(a,g2e,by="ensembl_id",all.x=T)#使未被匹配的ensembl_id也保留
c=merge(b,g2s,by="gene_id",all.x=T)#根据gene_id匹配g2s中的symbol

#有些ensembl_id会对应不同的gene_id,导致对应不同的symbol
c=c[order(c$V1),]#按照ensembl_id从小到大排序，生成新位序，再检索
c=c[!duplicated(c$V1),]#删除重复项，返回逻辑值，再检索
c=c[match(a$V1,c$V1),]#将合并后的数据框按照最初的数据框的V1排序

#调整数据框的列的顺序
colnames(c)#返回数据框列名
library(dplyr)
c = c %>% select(V1,ensembl_id,gene_id,symbol)#修改列的顺序
c = c %>% select(ensembl_id,gene_id,symbol)#删除V1
colnames(c)







