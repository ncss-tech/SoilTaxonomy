## 2019-04-02
## D.E. Beaudette
##
## Rebuild copies of data used within the SoilTaxonomy R package


## ST to the subgroup level, simple data.frame
ST <- read.csv('misc/ST-data/ST-full.csv', stringsAsFactors = FALSE)

save(ST, file='data/ST.rda')

## extract unique levels and save to a list
ST_unique_list <- list()
ST_unique_list$order <- unique(ST$order)
ST_unique_list$suborder <- unique(ST$suborder)
ST_unique_list$greatgroup <- unique(ST$greatgroup)
ST_unique_list$subgroup <- unique(ST$subgroup)

save(ST_unique_list, file='data/ST_unique_list.rda')

## formative element dictionaries
# TODO: streamline this
load('misc/formative-elements/formative-elements.rda')
ST_formative_elements <- ST.formative_elements
names(ST_formative_elements) <- c("order","suborder","greatgroup","subgroup")

save(ST_formative_elements, file='data/ST_formative_elements.rda')

ST_feature_SKB <- jsonlite::read_json("https://github.com/ncss-tech/SoilKnowledgeBase/raw/main/inst/extdata/KST/2014_KST_EN_featurelist.json",
                                   simplifyVector = TRUE)

# there are headers and some explanatory sections in this chapter
epipedons <- ST_feature_SKB[2:9,]
# c("Anthropic Epipedon", "Folistic Epipedon", "Histic Epipedon", 
#   "Melanic Epipedon", "Mollic Epipedon", "Ochric Epipedon", "Plaggen Epipedon", 
#   "Umbric Epipedon")

diagnostic_horizons <- ST_feature_SKB[11:30,]
# c("Agric Horizon", "Albic Horizon", "Anhydritic Horizon", "Argillic Horizon", 
#   "Calcic Horizon", "Cambic Horizon", "Duripan", "Fragipan", "Glossic Horizon", 
#   "Gypsic Horizon", "Kandic Horizon", "Natric Horizon", "Ortstein", 
#   "Oxic Horizon", "Petrocalcic Horizon", "Petrogypsic Horizon", 
#   "Placic Horizon", "Salic Horizon", "Sombric Horizon", "Spodic Horizon")

characteristics_mineral <- ST_feature_SKB[32:41,]
# c("Abrupt Textural Change", "Albic Materials", "Andic Soil Properties", 
#   "Anhydrous Conditions", "Coefficient of Linear Extensibility (COLE)", 
#   "Fragic Soil Properties", "Free Carbonates", "Identifiable Secondary Carbonates", 
#   "Interfingering of Albic Materials", "Lamellae")

characteristics_organic <- ST_feature_SKB[53:66,]
# c("Kinds of Organic Soil Materials", "Fibers", "Fibric Soil Materials", 
#   "Hemic Soil Materials", "Sapric Soil Materials", "Humilluvic Material", 
#   "Kinds of Limnic Materials", "Coprogenous Earth", "Diatomaceous Earth", 
#   "Marl", "Thickness of Organic Soil Materials", "Surface Tier", 
#   "Subsurface Tier", "Bottom Tier")

characteristics_all <- ST_feature_SKB[68:81,]
# c("Aquic Conditions", "Cryoturbation", "Densic Contact", "Densic Materials", 
#   "Gelic Materials", "Glacic Layer", "Lithic Contact", "Paralithic Contact", 
#   "Permafrost", "Soil Moisture Regimes", "Soil Moisture Control Section", 
#   "Classes of Soil Moisture Regimes", "Sulfidic Materials", "Sulfuric Horizon")

characteristics_anthro <- ST_feature_SKB[83:93,]
# c("Anthropogenic Landforms", "Constructional Anthropogenic Landforms", 
#   "Destructional Anthropogenic Landforms", "Anthropogenic Microfeatures", 
#   "Constructional Anthropogenic Microfeatures", "Destructional Anthropogenic Microfeatures", 
#   "Artifacts", "Human-Altered Material", "Human-Transported Material", 
#   "Manufactured Layer", "Manufactured Layer Contact")

ST_features <- list(
  epipedons = epipedons,
  diagnostic_horizons = diagnostic_horizons,
  characteristics_mineral = characteristics_mineral,
  characteristics_organic = characteristics_organic,
  characteristics_all = characteristics_all
)
ST_features <- do.call('rbind',ST_features)
rownames(ST_features) <- NULL
save(ST_features, file='data/ST_features.rda')
