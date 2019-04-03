library(SoilTaxonomy)

## TODO: there are many subgroup formative elements missing from the dictionary, e.g. "xerollic"


# sample taxa
x <- c('fluvaquentic haplofibrists', 'abruptic durixeralfs', 'typic haploxerolls', 'aquic cumulic hapludolls', 'argic borfundgus', 'barfic ustox', 'typic ustorthents', 'aridic lithic argixerolls', 'petroferric sombriudox')

# the hard work is done by these functions
OrderFormativeElements(x)
SubOrderFormativeElements(x)
GreatGroupFormativeElements(x)
SubGroupFormativeElements(x)



cat(explainST(x[9]), sep = '\n')

cat(explainST(x[8]), sep = '\n')


cat(explainST(x[1]), sep = '\n')


cat(explainST('aeric umbric endoaqualfs'))

cat(explainST('typic endoaqualfs'))

# cat(explainST(ST$tax_subgroup[200]))

cat(explainST('acrustoxic kanhaplustults'))
