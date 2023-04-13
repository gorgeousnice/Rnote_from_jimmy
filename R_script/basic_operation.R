#基础操作：基础代码，工具栏，快捷键

#基础代码
#删除现有环境变量：
rm(list=ls())
#避免将数据框内的相关变量转换成因子:
options(stringsAsFactors=F)
#查看现在工作目录：
getwd()
#修改工作目录
setwd()#e.g."/Users/gorgeous/Desktop/jimmy_R"
#查看数据类型
class()
#下载R包(有时候R studio下载不了可以去R Gui试一下)
install.packages("")
#加载包：
library()
#查看帮助文档
?pheatmap#以pheatmap包为例
#不画图怎么办：
dev.off()#1、关一下画板
fileName("XXX.png")#2、保存为图片看

#工具栏
##Files：相关文件
###Plot：图展示
##Package：已有软件包
##Help：查看包中文件
##Environment：对象展示
##History：control历史，打过的代码
##Tools—Global options软件各种设置

#快捷键(mac为例)
##清空控制台：Control+L
##快捷赋值：option+-
##列出历史记录：command+↑
##中断操作：Esc
##拓展函数框：函数首字母+TAB
##显示所有快捷键：alt+shift+K
##运行本行代码：command+回车
