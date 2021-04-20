## 2021-04-15
## D.E. Beaudette, A.G. Brown
##
## Rebuild /data directory of SoilTaxonomy R package from flat files/products from NASIS in /misc

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
load('misc/formative-elements/formative-elements.rda')
ST_formative_elements <- ST.formative_elements
names(ST_formative_elements) <- c("order","suborder","greatgroup","subgroup")

# find formative elements in order names and add to table
y <- ST_formative_elements[["order"]]
yi <- y[grep(x, y$order),]
res <- data.frame(y$order, stringr::str_locate(y$order, gsub("(.*)s$","\\1", y$element)))
colnames(res) <- c("order","element_start","element_end")
ST_formative_elements[["order"]] <- merge(ST_formative_elements[["order"]], res, by = "order")

save(ST_formative_elements, file='data/ST_formative_elements.rda')

ST_feature_SKB <- jsonlite::read_json("https://github.com/ncss-tech/SoilKnowledgeBase/raw/main/inst/extdata/KST/2014_KST_EN_featurelist.json",
                                   simplifyVector = TRUE)

# handle marked UTF8 strings
ST_feature_SKB$description <- sapply(ST_feature_SKB$description, stringi::stri_enc_toascii)
ST_feature_SKB$criteria <- lapply(ST_feature_SKB$criteria, stringi::stri_enc_toascii)

# check
sapply(ST_feature_SKB$criteria, function(x) all(stringi::stri_enc_isascii(x)))

# types of soil materials and their differentia
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

characteristics_all <- ST_feature_SKB[75:88,]
# c("Aquic Conditions", "Cryoturbation", "Densic Contact", "Densic Materials", 
#   "Gelic Materials", "Glacic Layer", "Lithic Contact", "Paralithic Contact", 
#   "Permafrost", "Soil Moisture Regimes", "Soil Moisture Control Section", 
#   "Classes of Soil Moisture Regimes", "Sulfidic Materials", "Sulfuric Horizon")

characteristics_anthro <- ST_feature_SKB[90:100,]
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
save(ST_features, file='data/ST_features.rda')


## get NASIS class names (family-level taxonomy)
ST_family_classes <- read.csv('misc/ST-data/ST-family-classes.csv', 
                              stringsAsFactors = FALSE)

# Join in chapter and page information from latest Keys

ST_family_classes$FeatureID <- c(
  "mineralogy class" = 109,
  "particle-size class" = 104,
  "reaction class" = 113,
  # "soil moisture subclass" = TODO,
  # "other family class" = MULTIPLE LOCATIONS,
  "temperature class" = 114,
  # "moisture regime" = TODO,
  # "temperature regime" = TODO,
  "activity class" = 111,
  "human-altered and human transported class" = 106
)[as.character(ST_family_classes$group)]

# [101] "Subgroups for Human-Altered and Human-"                    
# [102] "Family Differentiae for Mineral Soils and"                 
# [103] "Control Section for Particle-Size Classes and Their"       
# [104] "Key to the Particle-Size and Substitute Classes of Mineral"
# [105] "Strongly Contrasting Particle-Size Classes"                
# [106] "Use of Human-Altered and Human-Transported Material"       
# [107] "Key to Human-Altered and Human-Transported Material"       
# [108] "Key to the Control Section for Human-Altered and Human-"   
# [109] "Mineralogy Classes"                                        
# [110] "Key to Mineralogy Classes"                                 
# [111] "Cation-Exchange Activity Classes"                          
# [112] "Key to Cation-Exchange Activity Classes"                   
# [113] "Reaction Classes"                                          
# [114] "Soil Temperature Classes"                                  
# [115] "Soil Depth Classes"                                        
# [116] "Family Differentiae for Organic Soils"                     
# [117] "Particle-Size Classes"                                     
# [118] "Control Section for Particle-Size Classes"                 
# [119] "Key to Particle-Size Classes of Organic Soils"             
# [120] "Mineralogy Classes Applied Only to Limnic Subgroups"       
# [121] "Control Section for the Ferrihumic Mineralogy Class and"   
# [122] "Mineralogy Classes Applied Only to Terric Subgroups"       
# [123] "Control Section for Mineralogy Classes Applied Only to"    
# [124] "Key to Mineralogy Classes"                                 
# [125] "Reaction Classes"                                          
# [126] "Soil Temperature Classes"                                  
# [127] "Soil Depth Classes"                                        
# [128] "Series Differentiae Within a Family"                       
# [129] "Control Section for the Differentiation of Series" 

feature_data <- ST_feature_SKB[na.omit(unique(ST_family_classes$FeatureID)),]
feature_data$FeatureID <- c(
  "Mineralogy Classes" = 109,
  "Key to the Particle-Size and Substitute Classes of Mineral" = 104,
  "Reaction Classes" = 113,
  # "soil moisture subclass" = TODO,
  # "other family class" = MULTIPLE LOCATIONS,
  "Soil Temperature Classes" = 114,
  # "moisture regime" = TODO,
  # "temperature regime" = 114,
  "Cation-Exchange Activity Classes" = 111,
  "Use of Human-Altered and Human-Transported Material" = 106
)[as.character(feature_data$name)]

ST_family_classes_before <- ST_family_classes
ST_family_classes <- merge(ST_family_classes[,!colnames(ST_family_classes) %in% c("group","name")],
                           feature_data, by="FeatureID", all.x=TRUE, sort=FALSE, incomparables = NA)

# remove NASIS domain ID? and internal "feature ID" referencing list from SKB
ST_family_classes$FeatureID <- NULL
ST_family_classes$DomainID <- NULL

save(ST_family_classes, file='data/ST_family_classes.rda')
