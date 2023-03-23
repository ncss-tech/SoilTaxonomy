library(soilDB)
library(lattice)
library(latticeExtra)
library(tactile)

SDA_query("SELECT 
SUM((CAST(comppct_r AS NUMERIC) / 100.0) * CAST(muacres AS numeric)) / 1000000 AS ac 
FROM legend
INNER JOIN mapunit mu ON mu.lkey = legend.lkey
INNER JOIN component AS co ON mu.mukey = co.mukey 
WHERE legend.areasymbol != 'US' ;")

SDA_query("SELECT 
SUM(CAST(muacres AS numeric)) / 1000000 AS ac 
FROM legend
INNER JOIN mapunit mu ON mu.lkey = legend.lkey
WHERE legend.areasymbol != 'US' ;")


# let SDA do the work
# approx. MU acres by ST edition
# exclude STATSGO
# note idiotic CAST required for integer columns
x <- SDA_query("SELECT 
soiltaxedition, SUM((CAST(comppct_r AS numeric) / 100.0) * CAST(muacres AS NUMERIC)) AS ac 
FROM legend
INNER JOIN mapunit mu ON mu.lkey = legend.lkey
INNER JOIN component AS co ON mu.mukey = co.mukey 
WHERE compkind != 'Miscellaneous area' 
AND legend.areasymbol != 'US'
GROUP BY soiltaxedition 
ORDER BY ac DESC;")

# re-code NA taxedition
x$soiltaxedition[is.na(x$soiltaxedition)] <- '<missing>'

# remove 'edition' for simpler axes labels
x$ed <- gsub(pattern = ' edition', replacement = '', x$soiltaxedition)

# numerical ordering
x$ed <- factor(x$ed, levels = c('first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth', 'thirteenth', '<missing>'))

# sort by acreage
x$ed.sorted <- factor(x$ed, levels = x$ed[order(x$ac)])


# unsorted
p1 <- dotplot(ed ~ ac / 1e6, data = x, par.settings = tactile.theme(), xlab = 'Millions of Acres', ylab = 'ST Edition', type = c('p', 'g'), scales = list(x = list(log = 10)), xscale.components = xscale.components.log10.3)

# sorted
p2 <- dotplot(ed.sorted ~ ac / 1e6, data = x, par.settings = tactile.theme(), xlab = 'Millions of Acres', ylab = 'ST Edition', type = c('p', 'g'), scales = list(x = list(log = 10)), xscale.components = xscale.components.log10.3)

# combine figures
p <- c(p1, p2, x.same = TRUE)

# total acres
.txt <- sprintf("Excluding Misc. Area Components\n%s million acres total", round(sum(x$ac / 1e6)))

# add scales to both panels
p <- update(
  p, 
  scales = list(alternating = 3), 
  main = 'Editions of KST\nFY23 SSURGO',
  sub = .txt
)

# neat
print(p)




## again with SC database
# sc <- get_soilseries_from_NASIS()

# not possible?
