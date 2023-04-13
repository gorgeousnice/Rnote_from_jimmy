#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Example 1: Survival curves with two groups
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Fit survival curves拟合生存曲线
#++++++++++++++++++++++++++++++++++++
require("survival")
fit<- survfit(Surv(time, status) ~ sex, data = lung)

# Basic survival curves基本生存曲线
ggsurvplot(fit, data = lung)
ggsurvplot(fit, data = lung,title="Survival Curves")#加图名

# Customized survival curves定制生存曲线
ggsurvplot(fit, data = lung,
           surv.median.line = "hv", # Add medians survival中位虚线
           
           # Change legends: title & labels
           legend.title = "Sex",#修改命名层聚Strate
           legend.labs = c("Male", "Female"),#修改分组标签
           # Add p-value and tervals
           pval = TRUE,
           conf.int = TRUE,#有阴影，对生存函数的95%置信度的限制
           # Add risk table
           risk.table = TRUE,
           #当前时间下，尚存的没有发生终点事件的患者。他们有着发生终点事件的风险
           tables.height = 0.2,#risk table的数值间距
           tables.theme = theme_cleantable(),#不显示横轴
           
           # Color palettes. Use custom color: c("#E7B800", "#2E9FDF"),
           # or brewer color (e.g.: "Dark2"), or ggsci color (e.g.: "jco")
           palette = c("#E7B800", "#2E9FDF"),#修改曲线颜色
           ggtheme = theme_bw() # Change ggplot2 theme增加表格虚线
)

# Change font size, style and color改变字体大小，样式和颜色
#++++++++++++++++++++++++++++++++++++
## Not run: 
# Change font size, style and color at the same time
ggsurvplot(fit, data = lung,  main = "Survival curve",
           font.main = c(16, "bold", "darkblue"),#修改主题的字号16、字体、颜色
           font.x = c(14, "bold.italic", "red"),#修改x轴注释的字号14、字体、颜色
           font.y = c(14, "bold.italic", "darkred"),#修改y轴注释的字号、字体、颜色
           font.tickslab = c(12, "plain", "darkgreen"))#数值设置

## End(Not run)



#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Example 2: Facet ggsurvplot() output by
# a combination of factors
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Fit (complexe) survival curves
#++++++++++++++++++++++++++++++++++++
## Not run: 
require("survival")
fit3 <- survfit( Surv(time, status) ~ sex + rx + adhere,
                 data = colon )

# Visualize
#++++++++++++++++++++++++++++++++++++
ggsurvplot(fit3, data = colon,
          fun = "cumhaz", conf.int = TRUE,
          risk.table = TRUE, risk.table.col="strata",
          ggtheme = theme_bw())

# Faceting survival curves
curv_facet <- ggsurv$plot + facet_grid(rx ~ adhere)
curv_facet

# Faceting risk tables:only
# Generate risk table for each facet plot item
ggsurv$table + facet_grid(rx ~ adhere, scales = "free")+
  theme(legend.position = "none")

# Generate risk table for each facet columns
tbl_facet <- ggsurv$table + facet_grid(.~ adhere, scales = "free")
tbl_facet + theme(legend.position = "none")

# Arrange faceted survival curves and risk tables
g2 <- ggplotGrob(curv_facet)
g3 <- ggplotGrob(tbl_facet)
min_ncol <- min(ncol(g2), ncol(g3))
g <- gridExtra::gtable_rbind(g2[, 1:min_ncol], g3[, 1:min_ncol], size="last")
g$widths <- grid::unit.pmax(g2$widths, g3$widths)
grid::grid.newpage()
grid::grid.draw(g)


## End(Not run)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Example 3: CUSTOMIZED PVALUE
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Customized p-value对p-value值进行个性化
ggsurvplot(fit, data = lung, pval = TRUE)#显示p-value
ggsurvplot(fit, data = lung, pval = 0.03)#输入p-value值
ggsurvplot(fit, data = lung, pval = "The hot p-value is: 0.031")