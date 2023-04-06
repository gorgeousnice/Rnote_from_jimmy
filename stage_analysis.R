#任意基因任意癌症表达量与临床性状(stage)关联
rm(list=ls())
options(stringsAsFactors = F)
#利用http://www.cbioportal.org网站读取任意基因在任意疾病中的临床信息
#读取ARHGAP18基因在卵巢(Ovary)中的表达信息
#目的：看不同的肿瘤分期tumor stage，表达量的差异


#数据准备：
dat=read.table("Cbioportal_ARHGAP_ovary.txt",header = T,sep = "\t",fill=T)
colnames(dat)=c("id","stage","express","mut")#修改列名
#绘制小提琴图，按照stage分类，
library(ggstatsplot)
ggbetweenstats(data=dat,x="stage",y="express")#绘制小提琴图
library(ggplot2)
ggsave("Cbioportal_ARHGAP_ovary.png")#保存小提琴图

#方差分析：比较两个or两个以上样本均数的显著性检验
res.aov <- aov(express~stage,data=dat)
summary(res.aov)#方差分析：p-value>0.05，则可认为各总体均数相等
TukeyHSD(res.aov)
plot(res.aov)




