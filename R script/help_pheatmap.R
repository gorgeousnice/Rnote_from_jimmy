library(pheatmap)
# Create test matrix
test = matrix(rnorm(200), 20, 10)#构建随机数20*10的矩阵
#创造数与数之间的关系，体现后面的聚类分析
test[1:10, seq(1, 10, 2)] = test[1:10, seq(1, 10, 2)] + 3#seq等差函数
test[11:20, seq(2, 10, 2)] = test[11:20, seq(2, 10, 2)] + 2#11到20行的2,4,6,8,10列的每个数加2
test[15:20, seq(2, 10, 2)] = test[15:20, seq(2, 10, 2)] + 4#11到20行的2,4,6,8,10列的每个数加4
#修改矩阵的行名和列名
colnames(test) = paste("Test", 1:10, sep = "")#没有sep会默认空格
rownames(test) = paste("Gene", 1:20, sep = "")

# Draw heatmaps
pheatmap(test)
pheatmap(test,cluster_rows = F,cluster_cols = F)#不对行列进行聚类分析
pheatmap(test, kmeans_k = 2)#将行聚为2列

#scale数据标准化，防止有过大的值存在导致别的值之间的差异不易看清
pheatmap(test, scale = "row", clustering_distance_rows = "correlation")

pheatmap(test, color = colorRampPalette(c("navy", "white", "firebrick3"))(50))#修改颜色
pheatmap(test, cluster_row = FALSE)
pheatmap(test, cluster_row = FALSE,legend = FALSE)#不显示标尺值

# Show text within cells
pheatmap(test, display_numbers = TRUE)#显示数据
pheatmap(test, display_numbers = TRUE, number_format = "%.1e")#科学计数法显示数据
pheatmap(test, display_numbers = matrix(ifelse(test > 5, "*", ""), nrow(test)))#将test>5的数值*标注，其余不标注
pheatmap(test, cluster_row = FALSE, legend_breaks = -1:4, #标尺标注
                                    legend_labels = c("0","1e-4", "1e-3", "1e-2", "1e-1", "1"))

# Fix cell sizes and save to file with correct size
pheatmap(test, cellwidth = 15, cellheight = 12, main = "Example heatmap")#设置热图单元格宽度和高度
pheatmap(test, cellwidth = 15, cellheight = 12, fontsize = 8, filename = "test.pdf")#设置基础字体和

# 创建基因注释Generate annotations for rows and columns***
CellType=factor(rep(c("CT1", "CT2"), 5))#准备分组列表
annotation_col = data.frame(CellType,Time = 1:5)#创建数据框
rownames(annotation_col) = colnames(test)#增加行名：保证分组列表的列名与分组行名相同
annotation_row = data.frame(GeneClass = factor(rep(c("Path1", "Path2", "Path3"), c(10, 4, 6))))
rownames(annotation_row) = paste("Gene", 1:20, sep = "")
#该步也可以直接在excel里准备csv文件

# Display row and color annotations
pheatmap(test, annotation_col = annotation_col,filename = "test2.pdf")
pheatmap(test, annotation_col = annotation_col, annotation_legend = FALSE,filename = "test2.pdf")#不显示注释图例
pheatmap(test, annotation_col = annotation_col, annotation_row = annotation_row,filename = "test2.pdf")

# Change angle of text in the columns
pheatmap(test, annotation_col = annotation_col, annotation_row = annotation_row, 
               angle_col = "45",filename = "test2.pdf")#设置列标签角度
pheatmap(test, annotation_col = annotation_col, angle_col = "0",filename = "test2.pdf")

# Specify colors
ann_colors = list(
  Time = c("white", "firebrick"),
  CellType = c(CT1 = "#1B9E77", CT2 = "#D95F02"),
  GeneClass = c(Path1 = "#7570B3", Path2 = "#E7298A", Path3 = "#66A61E")
)

pheatmap(test, annotation_col = annotation_col, annotation_colors = ann_colors, 
               main = "Title",filename = "test2.pdf")#增加title
pheatmap(test, annotation_col = annotation_col, annotation_row = annotation_row, 
         annotation_colors = ann_colors)#修改注释颜色
pheatmap(test, annotation_col = annotation_col, 
               annotation_colors = ann_colors[2]) #选择注释颜色设置的部分

# Gaps in heatmaps
pheatmap(test, annotation_col = annotation_col, cluster_rows = FALSE, 
         gaps_row = c(10, 14))#在第10行和第14行后面间断
pheatmap(test, annotation_col = annotation_col, cluster_rows = FALSE, gaps_row = c(10, 14), 
         cutree_col = 2)#根据聚类分析间断

# Show custom strings as row/col names将自定义字符串显示行列名称
labels_row = c("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
               "", "", "Il10", "Il15", "Il1b")
pheatmap(test, annotation_col = annotation_col, 
               labels_row = labels_row,filename = "test.pdf")

# Specifying clustering from distance matrix从距离矩阵指定聚类
drows = dist(test, method = "minkowski")
dcols = dist(t(test), method = "minkowski")
pheatmap(test, clustering_distance_rows = drows, clustering_distance_cols = dcols,filename = "test.pdf")

# Modify ordering of the clusters using clustering callback option
callback = function(hc, mat){
  sv = svd(t(mat))$v[,1]
  dend = reorder(as.dendrogram(hc), wts = sv)
  as.hclust(dend)
}
pheatmap(test, clustering_callback = callback,filename = "test.pdf")#回调函数来修改聚类

## Not run: 
# Same using dendsort package
library(dendsort)

callback = function(hc, ...){dendsort(hc)}
pheatmap(test, clustering_callback = callback)

## End(Not run)

[Package pheatmap version 1.0.12 Index]

