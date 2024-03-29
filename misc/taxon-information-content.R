library(aqp)
library(lattice)
library(latticeExtra)
library(tactile)
library(SoilTaxonomy)
library(treemap)

data(ST)
data("ST_unique_list")


ST$order <- factor(ST$order, levels = ST_unique_list$order)
ST$suborder <- factor(ST$suborder, levels = ST_unique_list$suborder)
ST$greatgroup <- factor(ST$greatgroup, levels = ST_unique_list$greatgroup)
ST$subgroup <- factor(ST$subgroup, levels = ST_unique_list$subgroup)

x <- 'abruptic haplic durixeralfs'
cat(explainST(x))

x <- ST$subgroup[1]
cat(explainST(x))

aqp:::.compressedLength(
  FormativeElements(x)$defs$connotation
)


ST$information <- NA

for(i in 1:nrow(ST)) {
  
  .taxa <- ST$subgroup[i]
  .fm <- FormativeElements(.taxa)$defs$connotation 
  .z <- suppressMessages(
    aqp:::.compressedLength(.fm)
  )
  
  ST$information[i] <- .z
}


taxonTree('oxisols', special.chars = c("\u251c","\u2502", "\u2514", "\u2500 "))
taxonTree('entisols', special.chars = c("\u251c","\u2502", "\u2514", "\u2500 "))


taxonTree('rhodic eutrudox', special.chars = c("\u251c","\u2502", "\u2514", "\u2500 "))
FormativeElements('rhodic eutrudox')$defs$connotation
cat(explainST('rhodic eutrudox'))


taxonTree('aquic udipsamments', special.chars = c("\u251c","\u2502", "\u2514", "\u2500 "))
FormativeElements('aquic udipsamments')$defs$connotation
cat(explainST('aquic udipsamments'))

knitr::kable(
  ST[ST$subgroup %in% c('rhodic eutrudox', 'aquic udipsamments'), c('subgroup', 'information')],
  row.names = FALSE, 
  col.names = c('Subgroup', 'Total Formative Element Gzip Size (bytes)')
)


bwplot(
  order ~ information, 
  data = ST, 
  varwidth = TRUE,
  par.settings = tactile.theme(), 
  scales = list(x = list(tick.number = 15)), 
  xlab = 'Formative Element Information Content (bytes)', 
  panel = function(...) {
    panel.grid(-1, -1)
    panel.bwplot(...)
  }
)

bwplot(suborder ~ information, data = ST, par.settings = tactile.theme())

bwplot(suborder ~ information | order, data = ST, par.settings = tactile.theme(), scales = list(y = list(relation = 'free'), x = list(alternating = 1)), as.table = TRUE)


i <- aggregate(information ~ order, data = ST, FUN = 'sum')
bwplot(order ~ information, data = i, par.settings = tactile.theme())

i <- aggregate(information ~ order + suborder + greatgroup, data = ST, FUN = 'mean')
bwplot(order ~ information, data = i, par.settings = tactile.theme())



treemap(
  ST, 
  index = c('order', 'suborder', 'greatgroup'), 
  vSize = 'information', 
  fontsize.labels = c(8, 0, 0), 
  type = 'index', 
  title = 'I'
)





# treemap(
#   ST[which(ST$order == 'mollisols'), ], 
#   index = c('order', 'greatgroup', 'subgroup'), 
#   vSize = 'information', 
#   fontsize.labels = c(0, 0, 12), 
#   type = 'index', 
#   title = 'I'
# )

