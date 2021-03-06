## 2021-03-05
## DEB


## this would be a lot more informative after:
# normalization of concepts / labels
# linkages to other formative element dictionaries
# linkages to taxa via string matching
# > 2 rankings per SFF


library(cluster)
library(ape)

# x <- read.csv('misc/soil-forming-factors/epipedons.csv')
x <- read.csv('misc/soil-forming-factors/subsurface.csv')
# x <- read.csv('misc/soil-forming-factors/diag-soil-characteristics.csv')
# x <- read.csv('misc/soil-forming-factors/mineral-and-organic.csv')
# x <- read.csv('misc/soil-forming-factors/organic.csv')


str(x)

# codes:
# 0: not important
# 1: weakly important
# 2: strongly important


# convert everything but IDs to ordered factors
for(i in 2:ncol(x)) {
  x[[i]] <- factor(x[[i]])
  x[[i]] <- ordered(x[[i]])
}

# ok
str(x)

# ensure IDs move -> distance matrix -> clustering
rownames(x) <- x[, 1]

# pair-wise distances, using ordered factors, ignoring ID column
d <- daisy(x[, -c(1)])

# convert to hclust
h <- as.hclust(diana(d))

# convert to phylo for better plotting
p <- as.phylo(h)

par(mar = c(1,1,3,1))

plot(p, label.offset = 0.01, direction = 'down')
