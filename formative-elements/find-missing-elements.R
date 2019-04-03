library(SoilTaxonomy)
library(purrr)

data("ST_unique_list")

# formative element parsing requires taxa one level higher
x <- OrderFormativeElements(ST_unique_list$tax_suborder)
any(is.na(x$defs$order))
any(is.na(x$char.index))

# formative element parsing requires taxa one level higher
x <- OrderFormativeElements(ST_unique_list$tax_greatgroup)
any(is.na(x$defs$order))

# formative element parsing requires taxa one level higher
x <- OrderFormativeElements(ST_unique_list$tax_subgroup)
any(is.na(x$defs$order))


##

# formative element parsing requires taxa one level higher
x <- SubOrderFormativeElements(ST_unique_list$tax_greatgroup)
# OK
any(is.na(x$defs$order))
# some bugs
any(is.na(x$char.index))

# "fibristels" "folistels"  "hemistels"  "glacistels" "sapristels"
idx <- which(is.na(x$char.index))
ST_unique_list$tax_greatgroup[idx]

# fixed
x <- 'calciargids'
SubOrderFormativeElements(x)

# correct parsing of formative elements, but not character position
x <- 'folistels'
SubOrderFormativeElements(x)

# hmm
x <- c('argixerolls', 'folistels', 'calciargids', 'fartyblogfish')
SubOrderFormativeElements(x)



# works !
x <- SubOrderFormativeElements(ST_unique_list$tax_subgroup)
any(is.na(x$defs$order))
any(is.na(x$char.index))

# find errors
s <- ST_unique_list$tax_subgroup
names(s) <- s
s.test <- map(s, safely(SubOrderFormativeElements))
s.test <- transpose(s.test)

# find errors
idx <- ! sapply(s.test$error, is.null)
names(s.test$error[idx])


# how about some problematic subgroups
x <- c('argixerolls', 'acrustoxic kanhaplustults')
SubOrderFormativeElements(x)



