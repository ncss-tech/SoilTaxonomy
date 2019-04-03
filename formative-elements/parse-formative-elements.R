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


cat(explainST('aquic cumulic hapludolls'))

cat(explainST('aeric umbric endoaqualfs'))

cat(explainST('typic endoaqualfs'))

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
