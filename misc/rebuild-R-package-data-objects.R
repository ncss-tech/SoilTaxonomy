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
save(ST_features, file='data/ST_features.rda')

## get NASIS class names (family-level taxonomy)
ST_family_classes <- read.csv('misc/ST-data/ST-family-classes.csv', stringsAsFactors = FALSE)

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
ST_family_classes <- subset(ST_family_classes, DomainID != 188)

ST_family_classes$FeatureID <- c(
  "mineralogy class" = 112,
  "particle-size class" = 106,
  "reaction class" = 117,
  "organic soil reaction class" = 132,
  "limnic subgroup mineralogy class" = 127,
  "terric subgroup mineralogy class" = 129,
  # "soil moisture subclass" = TODO,
  # "other family class" = MULTIPLE LOCATIONS,
  "temperature class" = 118,
  "moisture regime" = 85,
  # "temperature regime" = TODO,
  "activity class" = 115,
  "human-altered and human transported class" = 108
)[as.character(ST_family_classes$group)]

ST_family_classes$FeatureID[ST_family_classes$DomainID == 131] <- 901
ST_family_classes$FeatureID[ST_family_classes$DomainID == 184] <- 902

# > ST_feature_SKB$name
# [1] "Mineral Soil Material"                                                                                 
# [2] "Organic Soil Material"                                                                                 
# [3] "Distinction Between Mineral Soils and Organic"                                                         
# [4] "Soil Surface"                                                                                          
# [5] "Mineral Soil Surface"                                                                                  
# [6] "Definition of Mineral Soils"                                                                           
# [7] "Definition of Organic Soils"                                                                           
# [8] "Diagnostic Surface Horizons:"                                                                          
# [9] "Anthropic Epipedon"                                                                                    
# [10] "Folistic Epipedon"                                                                                     
# [11] "Histic Epipedon"                                                                                       
# [12] "Melanic Epipedon"                                                                                      
# [13] "Mollic Epipedon"                                                                                       
# [14] "Ochric Epipedon"                                                                                       
# [15] "Plaggen Epipedon"                                                                                      
# [16] "Umbric Epipedon"                                                                                       
# [17] "Diagnostic Subsurface Horizons"                                                                        
# [18] "Agric Horizon"                                                                                         
# [19] "Albic Horizon"                                                                                         
# [20] "Anhydritic Horizon"                                                                                    
# [21] "Argillic Horizon"                                                                                      
# [22] "Calcic Horizon"                                                                                        
# [23] "Cambic Horizon"                                                                                        
# [24] "Duripan"                                                                                               
# [25] "Fragipan"                                                                                              
# [26] "Glossic Horizon"                                                                                       
# [27] "Gypsic Horizon"                                                                                        
# [28] "Kandic Horizon"                                                                                        
# [29] "Natric Horizon"                                                                                        
# [30] "Ortstein"                                                                                              
# [31] "Oxic Horizon"                                                                                          
# [32] "Petrocalcic Horizon"                                                                                   
# [33] "Petrogypsic Horizon"                                                                                   
# [34] "Placic Horizon"                                                                                        
# [35] "Salic Horizon"                                                                                         
# [36] "Sombric Horizon"                                                                                       
# [37] "Spodic Horizon"                                                                                        
# [38] "Diagnostic Soil Characteristics for Mineral"                                                           
# [39] "Abrupt Textural Change"                                                                                
# [40] "Albic Materials"                                                                                       
# [41] "Andic Soil Properties"                                                                                 
# [42] "Anhydrous Conditions"                                                                                  
# [43] "Coefficient of Linear Extensibility (COLE)"                                                            
# [44] "Fragic Soil Properties"                                                                                
# [45] "Free Carbonates"                                                                                       
# [46] "Identifiable Secondary Carbonates"                                                                     
# [47] "Interfingering of Albic Materials"                                                                     
# [48] "Lamellae"                                                                                              
# [49] "Linear Extensibility (LE)"                                                                             
# [50] "Lithologic Discontinuities"                                                                            
# [51] "n Value"                                                                                               
# [52] "Petroferric Contact"                                                                                   
# [53] "Plinthite"                                                                                             
# [54] "Resistant Minerals"                                                                                    
# [55] "Slickensides"                                                                                          
# [56] "Spodic Materials"                                                                                      
# [57] "Volcanic Glass"                                                                                        
# [58] "Weatherable Minerals"                                                                                  
# [59] "Characteristics Diagnostic for Organic Soils"                                                          
# [60] "Kinds of Organic Soil Materials"                                                                       
# [61] "Fibers"                                                                                                
# [62] "Fibric Soil Materials"                                                                                 
# [63] "Hemic Soil Materials"                                                                                  
# [64] "Sapric Soil Materials"                                                                                 
# [65] "Humilluvic Material"                                                                                   
# [66] "Kinds of Limnic Materials"                                                                             
# [67] "Coprogenous Earth"                                                                                     
# [68] "Diatomaceous Earth"                                                                                    
# [69] "Marl"                                                                                                  
# [70] "Thickness of Organic Soil Materials"                                                                   
# [71] "Surface Tier"                                                                                          
# [72] "Subsurface Tier"                                                                                       
# [73] "Bottom Tier"                                                                                           
# [74] "Horizons and Characteristics"                                                                          
# [75] "Aquic Conditions"                                                                                      
# [76] "Cryoturbation"                                                                                         
# [77] "Densic Contact"                                                                                        
# [78] "Densic Materials"                                                                                      
# [79] "Gelic Materials"                                                                                       
# [80] "Glacic Layer"                                                                                          
# [81] "Lithic Contact"                                                                                        
# [82] "Paralithic Contact"                                                                                    
# [83] "Paralithic Materials"                                                                                  
# [84] "Permafrost"                                                                                            
# [85] "Soil Moisture Regimes"                                                                                 
# [86] "Soil Moisture Control Section"                                                                         
# [87] "Classes of Soil Moisture Regimes"                                                                      
# [88] "Sulfidic Materials"                                                                                    
# [89] "Sulfuric Horizon"                                                                                      
# [90] "Characteristics Diagnostic for Human-Altered and Human-Transported Soils"                              
# [91] "Anthropogenic Landforms and Microfeatures"                                                             
# [92] "Anthropogenic Landforms"                                                                               
# [93] "Constructional Anthropogenic Landforms"                                                                
# [94] "Destructional Anthropogenic Landforms"                                                                 
# [95] "Anthropogenic Microfeatures"                                                                           
# [96] "Constructional Anthropogenic Microfeatures"                                                            
# [97] "Destructional Anthropogenic Microfeatures"                                                             
# [98] "Artifacts"                                                                                             
# [99] "Human-Altered Material"                                                                                
# [100] "Human-Transported Material"                                                                            
# [101] "Manufactured Layer"                                                                                    
# [102] "Manufactured Layer Contact"                                                                            
# [103] "Subgroups for Human-Altered and Human-Transported Soils"                                               
# [104] "Family Differentiae for Mineral Soils and Mineral Layers of Some Organic Soils"                        
# [105] "Control Section for Particle-Size Classes and Their Substitutes in Mineral Soils"                      
# [106] "Key to the Particle-Size and Substitute Classes of Mineral Soils"                                      
# [107] "Strongly Contrasting Particle-Size Classes"                                                            
# [108] "Use of Human-Altered and Human-Transported Material Classes"                                           
# [109] "Key to Human-Altered and Human-Transported Material Classes"                                           
# [110] "Key to the Control Section for Human-Altered and Human-Transported Material Classes"                   
# [111] "Key to Human-Altered and Human-Transported Material Classes"                                           
# [112] "Mineralogy Classes"                                                                                    
# [113] "Control Section for Mineralogy Classes"                                                                
# [114] "Key to Mineralogy Classes"                                                                             
# [115] "Cation-Exchange Activity Classes"                                                                      
# [116] "Key to Cation-Exchange Activity Classes"                                                               
# [117] "Calcareous and Reaction Classes of Mineral Soils"                                                      
# [118] "Soil Temperature Classes"                                                                              
# [119] "Soil Depth Classes"                                                                                    
# [120] "Rupture-Resistance Classes"                                                                            
# [121] "Classes of Coatings on Sands"                                                                          
# [122] "Classes of Permanent Cracks"                                                                           
# [123] "Family Differentiae for Organic Soils"                                                                 
# [124] "Particle-Size Classes"                                                                                 
# [125] "Control Section for Particle-Size Classes"                                                             
# [126] "Key to Particle-Size Classes of Organic Soils"                                                         
# [127] "Mineralogy Classes Applied Only to Limnic Subgroups"                                                   
# [128] "Control Section for the Ferrihumic Mineralogy Class and Mineralogy Classes Applied to Limnic Subgroups"
# [129] "Mineralogy Classes Applied Only to Terric Subgroups"                                                   
# [130] "Control Section for Mineralogy Classes Applied Only to Terric Subgroups"                               
# [131] "Key to Mineralogy Classes"                                                                             
# [132] "Reaction Classes"                                                                                      
# [133] "Soil Temperature Classes"                                                                              
# [134] "Soil Depth Classes"                                                                                    
# [135] "Series Differentiae Within a Family"                                                                   
# [136] "Control Section for the Differentiation of Series" 

feature_data <- ST_feature_SKB[na.omit(unique(ST_family_classes$FeatureID)),]
feature_data[6, 'name'] <- "Reaction Classes for Organic Soils"

feature_data$FeatureID <- c(
  "Mineralogy Classes" = 112,
  "Key to the Particle-Size and Substitute Classes of Mineral Soils" = 106,
  "Calcareous and Reaction Classes of Mineral Soils" = 117,
  "Reaction Classes for Organic Soils" = 132,
  "Mineralogy Classes Applied Only to Limnic Subgroups" = 127,
  "Mineralogy Classes Applied Only to Terric Subgroups" = 129,
  "soil moisture subclass" = 901, #custom
  "other family class" = 902, #custom
  "Soil Temperature Classes" = 118,
  "Soil Moisture Regimes" = 85,
  "Cation-Exchange Activity Classes" = 115,
  "Use of Human-Altered and Human-Transported Material Classes" = 108
)[as.character(feature_data$name)]

# custom feature definitions (not in 12th edition or defs not yet mappable to single domain)
smsubcl <- data.frame(group = "Mineral or Organic", name = "Soil Moisture Subclasses", 
                      chapter = NA, page = NA, description = "Soil moisture subclasses are used to depict intragrades between Soil Moisture Regimes.", criteria = "", FeatureID = 901)

fmsubcl <- data.frame(group = "Mineral or Organic", name = "Other Family Classes", 
                      chapter = NA, page = NA, description = "These are 'other' family-level differentia as described in Soil Taxonomy.", criteria = "", FeatureID = 902)

feature_data <- rbind(feature_data, smsubcl, fmsubcl)

ST_family_classes_before <- ST_family_classes
ST_family_classes <- merge(ST_family_classes[,!colnames(ST_family_classes) %in% c("group","name")],
                           feature_data, by="FeatureID", all.x=TRUE, sort=FALSE, incomparables = NA)

# remove NASIS domain ID? and internal "feature ID" referencing list from SKB
ST_family_classes$FeatureID <- NULL
ST_family_classes$DomainID <- NULL

save(ST_family_classes, file='data/ST_family_classes.rda')
