library(soilDB)
library(lattice)
library(latticeExtra)
library(tactile)

x <- SDA_query("SELECT soiltaxedition, SUM((comppct_r / 100) * muacres) AS ac from mapunit JOIN component on mapunit.mukey = component.mukey WHERE soiltaxedition IS NOT NULL GROUP BY soiltaxedition ORDER BY ac DESC;")


x$ed <- gsub(pattern = ' edition', replacement = '', x$soiltaxedition)
x$ed <- factor(x$ed, levels = c('first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth', 'thirteenth'))

x$ed.sorted <- factor(x$ed, levels = x$ed[order(x$ac)])


p1 <- dotplot(ed ~ ac / 1e6, data = x, par.settings = tactile.theme(), xlab = 'Millions of Acres (SSURGO)', ylab = 'ST Edition')


p2 <- dotplot(ed.sorted ~ ac / 1e6, data = x, par.settings = tactile.theme(), xlab = 'Millions of Acres (SSURGO)', ylab = 'ST Edition')

p <- c(p1, p2)

p <- update(p, scales = list(alternating = 3))

p
