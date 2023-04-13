# 生科人应该这样学R
来自大三生物科学专业的科研小白，根跟着b站jimmy大神的视频(https://www.bilibili.com/video/BV1cs411j75B)
总结的一些关于r语言的学习笔记;

你可以下载我的代码，在你的R Studio里面运行。里面有很多我自己的思考，基本上每条代码都有很详细的注释;

一些代码运行需要数据，我都整理在Data_folder里了，你可以把他们下载到你的工作目录里;

## 代码对应知识点
### 基础操作：
basic_operation.R
（基础代码、工具栏、快捷键）

### 数据的导入与导出：
data_in/output.R

### 变量操作：
1、varianbles_operation.R
（对数化处理，对某/每一行计算，apply函数，排序sort，自定义函数function）
2、max:min_fivenum.R
 (排序，规定取值，返回：最小值、最大值、fivenum)

### 热图：
1、heatmap.R
(构建矩阵，绘制热图，修改热图行列名，聚类分析)
2、help_pheatmap.R
(pheatmap包帮助文档的运行脚本解释）

### id转换：
id_conversion.R
(数据分割，org.Hs.eg.db包检索匹配，调整数据框的列顺序)

### 任意基因任意癌症表达量分组的生存分析
1、survival_analysis.R
(下载表达矩阵,绘制小提琴图，绘制生存曲线)
2、help_ggsurvplot.R
（ggsurvplot包帮助文档的运行脚本解释）

### 任意基因任意癌症表达量与临床性状(stage)关联
stage_analysis.R
（绘制小提琴图，方差分析）

### 表达矩阵的样本的相关性分析
1、correlation.R
(关于相关性的理解,绘制热图--数据处理(删除没有意义的数据，提出估计标准差前500的基因)）
2、ac_correlation.R
（应用代码：没有冗长的解释和代码拆解）

### 芯片表达矩阵下游分析
Chip_matrix_downstream_analysis.R

### RNA-Seq差异表达分析
RNA-Seq_differ_express_analy.R

