## TODO: streamline this, consider using something other than XLSX

library(xlsx)
library(jsonlite)

# keeping track of the source data in XLSX for now, will eventially switch to JSON
f <- 'formative-elements.xlsx'

# order
soilorder <- read.xlsx(f, sheetName = 'order', stringsAsFactors=FALSE)
str(soilorder)

# suborder
suborder <- read.xlsx(f, sheetName = 'suborder', stringsAsFactors=FALSE)
str(suborder)

# greatgroup
greatgroup <- read.xlsx(f, sheetName = 'greatgroup', stringsAsFactors=FALSE)
str(greatgroup)

# subgroup
subgroup <- read.xlsx(f, sheetName = 'subgroup', stringsAsFactors=FALSE)
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
cat(ST.json, file = 'formative-elements.json')

# save in compressed format for packaging
save(ST.formative_elements, file='formative-elements.rda')
