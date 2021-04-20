
library(jsonlite)

# order
soilorder <- read.csv('misc/formative-elements/dictionaries/order.csv', stringsAsFactors=FALSE)
str(soilorder)

# suborder
suborder <- read.csv('misc/formative-elements/dictionaries/suborder.csv', stringsAsFactors=FALSE)
str(suborder)

# greatgroup
greatgroup <- read.csv('misc/formative-elements/dictionaries/greatgroup.csv', stringsAsFactors=FALSE)
str(greatgroup)

# subgroup
subgroup <- read.csv('misc/formative-elements/dictionaries/subgroup.csv', stringsAsFactors=FALSE)
str(subgroup)


# pack into a list
ST.formative_elements <- list(
  soilorder=soilorder,
  suborder=suborder,
  greatgroup=greatgroup,
  subgroup=subgroup
)

# try saving as JSON
ST.json <- toJSON(ST.formative_elements, auto_unbox = TRUE, pretty = TRUE, na='string')
cat(ST.json, file = 'misc/formative-elements/formative-elements.json')

# save in compressed format for packaging
save(ST.formative_elements, file='misc/formative-elements/formative-elements.rda')
