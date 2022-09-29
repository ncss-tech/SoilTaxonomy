## code to prepare package datasets goes here
## 2022-07-12
## D.E. Beaudette, A.G. Brown
##
## Rebuild /data directory of SoilTaxonomy R package from flat files/products from NASIS in /misc

library(soilDB)
library(SoilTaxonomy)

channel <- NASIS()
ST.orders <- dbQueryNASIS(channel, "SELECT ChoiceName as soilorder FROM MetadataDomainDetail WHERE DomainID = 132 AND ChoiceObsolete = 0", close=FALSE)
ST.suborders <- dbQueryNASIS(channel, "SELECT ChoiceName as suborder FROM MetadataDomainDetail WHERE DomainID = 134 AND ChoiceObsolete = 0", close=FALSE)
ST.greatgroups <- dbQueryNASIS(channel, "SELECT ChoiceName as greatgroup FROM MetadataDomainDetail WHERE DomainID = 130 AND ChoiceObsolete = 0", close=FALSE)
ST.subgroups <- dbQueryNASIS(channel, "SELECT ChoiceName as subgroup FROM MetadataDomainDetail WHERE DomainID = 187 AND ChoiceObsolete = 0", close=FALSE)
ST.family.classes <- dbQueryNASIS(channel, "SELECT DomainID, ChoiceName as classname FROM MetadataDomainDetail WHERE DomainID IN ('126','127','128','131','184','185','186','188','520','521','5247') AND ChoiceObsolete = 0", close=TRUE)

ST.family.classes$group <- c(
  `126` = "mineralogy class",
  `127` = "particle-size class",
  `128` = "reaction class",
  `131` = "soil moisture subclass",
  `184` = "other family class",
  `185` = "temperature class",
  `186` = "moisture regime",
  `188` = "temperature regime",
  `520` = "activity class",
  `521` = "particle-size modifier",
  `5247` = "human-altered and human transported class"
)[as.character(ST.family.classes$DomainID)]

# convert to vectors
ST.orders <- ST.orders$soilorder
ST.suborders <- ST.suborders$suborder
ST.greatgroups <- ST.greatgroups$greatgroup
ST.subgroups <- ST.subgroups$subgroup

# compose into single DF, populate with subgroups as starting point
ST <- data.frame(order=NA, suborder=NA, greatgroup=NA, subgroup=ST.subgroups, stringsAsFactors = FALSE)

# associate subgroup with parent greatgroup
ST$greatgroup <- getTaxonAtLevel(ST$subgroup, "greatgroup")

# associate great group with parent sub order
ST$suborder <- getTaxonAtLevel(ST$subgroup, "suborder")
ST$order <- getTaxonAtLevel(ST$subgroup, "order")
ST$code <- taxon_to_taxon_code(ST$subgroup)

# re-order by code
ST <- ST[order(ST$code), ]
ST$order_code <- substr(ST$code, 1, 1)
ST$suborder_code <- substr(ST$code, 2, 2)
ST$greatgroup_code <- substr(ST$code, 3, 3)
ST$subgroup_code <- substr(ST$code, 4, 5)

# drop taxa that do not exist in lookup tables
ST <- ST[which(complete.cases(ST)),]

write.csv(ST, file='data-raw/ST-full.csv', row.names=FALSE, quote = FALSE)

write.csv(ST.family.classes, file='data-raw/ST-family-classes.csv', row.names=FALSE, quote = FALSE)

## ST to the subgroup level, simple data.frame
ST <- read.csv('data-raw/ST-full.csv', stringsAsFactors = FALSE)
usethis::use_data(ST, overwrite = TRUE)

ST_logic <- cbind(ST, )

## unique taxa, sorted by appearance in the 'Keys
## as a list
ST_unique_list <- list()

# requires codes / taxa list
load('data/ST_higher_taxa_codes_12th.rda')
load('data/ST.rda')

# re-arrange taxa according to letter codes in the 'Keys
.uniqueTaxaLogicalOrdering <- function(x) {
  # find taxa in the letter code LUT
  idx <- match(tolower(x), tolower(ST_higher_taxa_codes_12th$taxon))

  # missing taxa
  if (any(is.na(idx))) {
    message(sprintf('missing: %s', paste(x[which(is.na(idx))], collapse = ',')))
  }

  # sort taxa based on letter codes
  res <- ST_higher_taxa_codes_12th$taxon[idx][order(ST_higher_taxa_codes_12th$code[idx])]

  return(tolower(res))
}

# unique taxa, in 'Keys order
ST_unique_list$order <- .uniqueTaxaLogicalOrdering(unique(ST$order))
ST_unique_list$suborder <- .uniqueTaxaLogicalOrdering(unique(ST$suborder))
ST_unique_list$greatgroup <- .uniqueTaxaLogicalOrdering(unique(ST$greatgroup))
ST_unique_list$subgroup <- .uniqueTaxaLogicalOrdering(unique(ST$subgroup))

# done
usethis::use_data(ST_unique_list, overwrite = TRUE)

## formative element dictionaries
load('misc/formative-elements/formative-elements.rda')
ST_formative_elements <- ST.formative_elements
names(ST_formative_elements) <- c("order","suborder","greatgroup","subgroup")

# find formative elements in order names and add to table
y <- ST_formative_elements[["order"]]
res <- data.frame(y$order, stringr::str_locate(y$order, gsub("(.*)s$","\\1", y$element)))
colnames(res) <- c("order","element_start","element_end")
ST_formative_elements[["order"]] <- merge(ST_formative_elements[["order"]], res, by = "order")

usethis::use_data(ST_formative_elements, overwrite = TRUE)

ST_feature_SKB <- jsonlite::read_json("https://github.com/ncss-tech/SoilKnowledgeBase/raw/main/inst/extdata/KST/2014_KST_EN_featurelist.json",
                                      simplifyVector = TRUE)

# handle marked UTF8 strings
ST_feature_SKB$description <- sapply(ST_feature_SKB$description, stringi::stri_enc_toascii)
ST_feature_SKB$criteria <- lapply(ST_feature_SKB$criteria, stringi::stri_enc_toascii)

# check
sapply(ST_feature_SKB$criteria, function(x) all(stringi::stri_enc_isascii(x)))

# types of soil materials and their differentiae
materials <- ST_feature_SKB[1:7,]

# there are headers and some explanatory sections in this chapter
epipedons <- ST_feature_SKB[9:16,]
# c("Anthropic Epipedon", "Folistic Epipedon", "Histic Epipedon",
#   "Melanic Epipedon", "Mollic Epipedon", "Ochric Epipedon", "Plaggen Epipedon",
#   "Umbric Epipedon")

diagnostic_horizons <- ST_feature_SKB[18:37,]
# c("Agric Horizon", "Albic Horizon", "Anhydritic Horizon", "Argillic Horizon",
#   "Calcic Horizon", "Cambic Horizon", "Duripan", "Fragipan", "Glossic Horizon",
#   "Gypsic Horizon", "Kandic Horizon", "Natric Horizon", "Ortstein",
#   "Oxic Horizon", "Petrocalcic Horizon", "Petrogypsic Horizon",
#   "Placic Horizon", "Salic Horizon", "Sombric Horizon", "Spodic Horizon")

characteristics_mineral <- ST_feature_SKB[39:48,]
# c("Abrupt Textural Change", "Albic Materials", "Andic Soil Properties",
#   "Anhydrous Conditions", "Coefficient of Linear Extensibility (COLE)",
#   "Fragic Soil Properties", "Free Carbonates", "Identifiable Secondary Carbonates",
#   "Interfingering of Albic Materials", "Lamellae")

characteristics_organic <- ST_feature_SKB[60:73,]
# c("Kinds of Organic Soil Materials", "Fibers", "Fibric Soil Materials",
#   "Hemic Soil Materials", "Sapric Soil Materials", "Humilluvic Material",
#   "Kinds of Limnic Materials", "Coprogenous Earth", "Diatomaceous Earth",
#   "Marl", "Thickness of Organic Soil Materials", "Surface Tier",
#   "Subsurface Tier", "Bottom Tier")

characteristics_all <- ST_feature_SKB[75:89,]
# c("Aquic Conditions", "Cryoturbation", "Densic Contact", "Densic Materials",
#   "Gelic Materials", "Glacic Layer", "Lithic Contact", "Paralithic Contact", "Paralithic Materials",
#   "Permafrost", "Soil Moisture Regimes", "Soil Moisture Control Section",
#   "Classes of Soil Moisture Regimes", "Sulfidic Materials", "Sulfuric Horizon")

characteristics_anthro <- ST_feature_SKB[92:101,]
# c("Anthropogenic Landforms", "Constructional Anthropogenic Landforms",
#   "Destructional Anthropogenic Landforms", "Anthropogenic Microfeatures",
#   "Constructional Anthropogenic Microfeatures", "Destructional Anthropogenic Microfeatures",
#   "Artifacts", "Human-Altered Material", "Human-Transported Material",
#   "Manufactured Layer", "Manufactured Layer Contact")

ST_features <- list(
  materials = materials,
  epipedons = epipedons,
  diagnostic_horizons = diagnostic_horizons,
  characteristics_mineral = characteristics_mineral,
  characteristics_organic = characteristics_organic,
  characteristics_all = characteristics_all,
  characteristics_anthro = characteristics_anthro
)

ST_features <- do.call('rbind', ST_features)
rownames(ST_features) <- NULL
usethis::use_data(ST_features, overwrite = TRUE)

## get NASIS class names (family-level taxonomy)
ST_family_classes <- read.csv('data-raw/ST-family-classes.csv', stringsAsFactors = FALSE)

# Join in chapter and page information from latest Keys
#
# the logic here is hardcoded for now, and there still may be some missing pieces/bad parsing lurking...
#
# TODO: in long term take these structures and use them to make the keys easier to use/mapping to domains easier
#       NASIS domains are handy lists but they ignore a lot of the nuance that applies within ST itself in that the
#       classes from different keys are combined into common drop-downs/domain lists and need to be disaggregated

ST_family_classes$group[ST_family_classes$classname %in% c("euic", "dysic")] <- "organic soil reaction class"

# limnic subgroups
ST_family_classes$group[ST_family_classes$classname %in% c("coprogenous", "diatomaceous", "marly")] <- "limnic subgroup mineralogy class"

#  terric subgroups only
ST_family_classes$group[ST_family_classes$classname %in% c("ferrihumic")] <- "terric subgroup mineralogy class"

# temperature classes
ST_family_classes$group[ST_family_classes$DomainID == 185] <- "temperature class"
ST_family_classes$group[ST_family_classes$DomainID == 188] <- "soil moisture class"

ST_family_classes$FeatureID <- c(
  "mineralogy class" = 112,
  "particle-size class" = 106,
  "reaction class" = 119,
  "organic soil reaction class" = 136,
  "limnic subgroup mineralogy class" = 131,
  "terric subgroup mineralogy class" = 133,
  # "soil moisture subclass" = TODO,
  # "other family class" = MULTIPLE LOCATIONS,
  "temperature class" = 120,
  "moisture regime" = 85,
  # "soil moisture class" = 87,
  "activity class" = 115,
  "human-altered and human transported class" = 108
)[as.character(ST_family_classes$group)]

ST_family_classes$FeatureID[ST_family_classes$DomainID == 131] <- 901
ST_family_classes$FeatureID[ST_family_classes$DomainID == 184] <- 902

# > ST_feature_SKB$name
feature_data <- ST_feature_SKB[na.omit(unique(ST_family_classes$FeatureID)),]
feature_data[6, 'name'] <- "Reaction Classes for Organic Soils"

feature_data$FeatureID <- c(
  "Mineralogy Classes" = 112,
  "Key to the Particle-Size and Substitute Classes of Mineral Soils" = 106,
  "Calcareous and Reaction Classes of Mineral Soils" = 119,
  "Reaction Classes for Organic Soils" = 136,
  "Mineralogy Classes Applied Only to Limnic Subgroups" = 131,
  "Mineralogy Classes Applied Only to Terric Subgroups" = 133,
  "soil moisture subclass" = 901, #custom
  "other family class" = 902, #custom
  "Soil Temperature Classes" = 120,
  "Soil Moisture Regimes" = 85,
  "Cation-Exchange Activity Classes" = 115,
  "Use of Human-Altered and Human-Transported Material Classes" = 108
)[as.character(feature_data$name)]

# custom feature definitions (not in 12th edition or defs not yet mappable to single domain)
smsubcl <- data.frame(group = "Mineral or Organic", name = "Soil Moisture Subclasses",
                      chapter = NA, page = NA, description = "Soil moisture subclasses are used to depict intragrades between Soil Moisture Regimes.", criteria = "", FeatureID = 901)

fmsubcl <- data.frame(group = "Mineral or Organic", name = "Other Family Classes",
                      chapter = NA, page = NA, description = "These are 'other' family-level differentiae as described in Soil Taxonomy.", criteria = "", FeatureID = 902)

feature_data <- rbind(subset(feature_data, !is.na(group)), smsubcl, fmsubcl)

ST_family_classes_before <- ST_family_classes
ST_family_classes <- merge(
  ST_family_classes[, !colnames(ST_family_classes) %in% c("group", "name")],
  subset(feature_data, !is.na(FeatureID)),
  by = "FeatureID",
  all.x = TRUE,
  sort = FALSE,
  incomparables = NA
)

# ignore soil temperature class
ST_family_classes <- subset(ST_family_classes, DomainID != 188)

# remove internal "feature ID" referencing list from SKB
ST_family_classes$FeatureID <- NULL

usethis::use_data(ST_family_classes, overwrite = TRUE)
