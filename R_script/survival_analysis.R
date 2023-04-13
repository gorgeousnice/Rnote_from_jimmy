#任意基因任意癌症表达量分组的生存分析survival analysis
#一个基因在TCGA的各个癌症的生存管理组
rm(list=ls())
options(stringsAsFactors = F)

#数据准备：
#e.g.ARHGAP18基因lgG(多发性骨髓瘤)癌症样本中的表达量；
#网站http://www.oncolnc.org下载-表达矩阵；其中高低表达通过Expression表达量进行分类
dat=read.csv("LGG_93663_50_50.csv",header = T,sep = ",",fill=T)

#创建小提琴图箱形图的组合图:ggbetweenstats函数
library("ggstatsplot")
ggbetweenstats(dat,x=Group,y=Expression)#注意匹配colnames
#通过生和死(Status)分组:
ggbetweenstats(dat,x=Status,y=Expression)

#如果发现数据不太明显，可以将数据log一下：
dat$log2_Expression <- log2(dat$Expression)
ggbetweenstats(dat,x=Group,y=log2_Expression)
ggbetweenstats(dat,x=Status,y=log2_Expression)

#tips关于小提琴图的图形解释：
   ##关于中间的点位位平均值；
   ##某个Expression值分布的数量越多，小提琴的宽度越宽
   ##T检验：查看数据是否符合均匀的正态分布

#重画网页中“生存分析”的图：
#以下代码是别人写好的，保证准备的数据中有Status,Expression,Days即可
library(ggplot2)
library(survival)
library(survminer)
table(dat$Status)
dat$Status <- ifelse(dat$Status=="Dead",1,0)#拼写！
sfit <- survfit(Surv(Days,Status)~Group,data=dat)
sfit
summary(sfit)
ggsurvplot(sfit,conf.int = F,pval = T)#无阴影，显示p-value
ggsave("survival_ARHGAP18_in_LGG.png")#保存为图片格式
#调整参数
ggsurvplot(sfit,palette = c("#E7B800","#2E9FDF"),#修改颜色
           risk.table = T,#显示number at risk，在时间t处于危险状态的病人数量
           xlab="Time in Days",#显示x轴的注释
           ggtheme = theme_light(),#显示表格线
           ncensor.plot=T,#显示number of censoring；在时间t处被审查的对象的数量
           conf.int = T,#有阴影，对生存函数的95%置信度的限制
           pval = T) #显示p-value

#tips生存分析图的图形解释：
  ##Time:生存时间or最后一次能够联系到这个病人的时间；随着时间推移，就会有病人因为LGG而去世
  ##Survival probability:每去世一个病人，整体的生存概率就会下降
  ##p-value：看两组病人的生存时间是否存在显著差异
  ##短线：最后一次能联系到病人的时间；病人不是由于LGG造成的死亡，联系不到了(删失事件)；
  ##Hazard Ratio:风险比率；当小于1时，该基因是起到保护作用；大于1则是风险因子

#发现：##随访时间大概5000天中,高表达ARHGAP18基因的病人存活概率要低一些；
       ##ARHGAP18基因的低表达组的生存状况要好一些 





