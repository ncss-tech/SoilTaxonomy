library(SoilTaxonomy)

## TODO: there are many subgroup formative elements missing from the dictionary, e.g. "xerollic"


# sample taxa
x <- c('fluvaquentic haplofibrists', 'abruptic durixeralfs', 'typic haploxerolls', 'aquic cumulic hapludolls', 'argic borfundgus', 'barfic ustox', 'typic ustorthents', 'aridic lithic argixerolls', 'petroferric sombriudox')

# the hard work is done by these functions
OrderFormativeElements(x)
SubOrderFormativeElements(x)
GreatGroupFormativeElements(x)
SubGroupFormativeElements(x)



cat(explainST(x[9]))

cat(explainST(x[8]))


cat(explainST(x[1]))


cat(explainST('petrosalic anhyturbels'))


cat(explainST('aquic cumulic hapludolls'))

cat(explainST('aeric umbric endoaqualfs'))

cat(explainST('typic endoaqualfs'))

cat(explainST('aquertic eutrudepts'))

cat(explainST('humic rhodic acroperox'))

cat(explainST('alfic humic vitrixerands'))

cat(explainST('aquic petroferric eutroperox'))

cat(explainST('entic haplustolls'))


# missing subgroup formative element
cat(explainST('leptic torrertic natrustolls'))

# dang it, this doesn't work
cat(explainST('acrustoxic kanhaplustults'))

# OK
OrderFormativeElements('acrustoxic kanhaplustults')
# OK
SubOrderFormativeElements('acrustoxic kanhaplustults')
# crap: https://github.com/ncss-tech/SoilTaxonomy/issues/7
GreatGroupFormativeElements('acrustoxic kanhaplustults')
# OK
SubGroupFormativeElements('acrustoxic kanhaplustults')


# HTML: sends to viewer panel, invisibly returns HTML text blob
cat(explainST('entic haplustolls'))
explainST('entic haplustolls', format = 'html')




# image, but why?
img.width <- 5
scaling.factor <- 1.5

par(mar=c(0, 0, 0, 0), bg='black')
plot(1,1, type='n', xlim=c(0, img.width), ylim=c(0, 1), axes=FALSE, xlab='', ylab='') 
points(0, 0.5, col='white', pch=16)

txt <- explainST('aquic cumulic hapludolls')
# width in current graphics device
# new lines are included, so this is the width of the longest line of text
txt.width <- strwidth(txt)
txt.height <- strwidth(txt)
txt.cex <- img.width / (txt.width * scaling.factor)

text(0, 0.5, txt, family='mono', pos=4, col='white', font=1, cex=txt.cex)
box(col='white')

