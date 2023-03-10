library(soilDB)
library(lattice)
library(latticeExtra)
library(tactile)

# let SDA do the work
# approx. MU acres by ST edition
x <- SDA_query("SELECT 
soiltaxedition, SUM((comppct_r / 100) * muacres) AS ac 
FROM mapunit AS mu 
JOIN component AS co ON mu.mukey = co.mukey 
WHERE soiltaxedition IS NOT NULL 
GROUP BY soiltaxedition 
ORDER BY ac DESC;")


# remove 'edition' for simpler axes labels
x$ed <- gsub(pattern = ' edition', replacement = '', x$soiltaxedition)

# numerical ordering
x$ed <- factor(x$ed, levels = c('first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth', 'thirteenth'))

# sort by acreage
x$ed.sorted <- factor(x$ed, levels = x$ed[order(x$ac)])


# unsorted
p1 <- dotplot(ed ~ ac / 1e6, data = x, par.settings = tactile.theme(), xlab = 'Millions of Acres', ylab = 'ST Edition', type = c('p', 'g'))

# sorted
p2 <- dotplot(ed.sorted ~ ac / 1e6, data = x, par.settings = tactile.theme(), xlab = 'Millions of Acres', ylab = 'ST Edition', type = c('p', 'g'))

# combine figures
p <- c(p1, p2, x.same = TRUE)

# add scales to both panels
p <- update(p, scales = list(alternating = 3), main = 'Editions of KST\nFY23 SSURGO')

# neat
print(p)


