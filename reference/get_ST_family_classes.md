# Get soil family / series differentiae and class names

All parameters to this function are optional (default `NULL`). If
specified, they are used as filters.

## Usage

``` r
get_ST_family_classes(
  classname = NULL,
  group = NULL,
  name = NULL,
  chapter = NULL,
  page = NULL,
  multiline_sep = "\n",
  multiline_col = "criteria"
)
```

## Arguments

- classname:

  optional filtering vector; levels of `ChoiceName` column from NASIS
  metadata

- group:

  optional filtering vector; one or more of: `"Mineral Family"`,
  `"Organic Family"`, `"Mineral or Organic"`

- name:

  optional filtering vector; one or more of: `"Mineralogy Classes"`,
  `"Mineralogy Classes Applied Only to Limnic Subgroups"`,
  `"Mineralogy Classes Applied Only to Terric Subgroups"`,
  `"Key to the Particle-Size and Substitute Classes of Mineral Soils"`,
  `"Calcareous and Reaction Classes of Mineral Soils"`,
  `"Reaction Classes for Organic Soils"`, `"Soil Moisture Subclasses"`,
  `"Other Family Classes"`, `"Soil Temperature Classes"`,
  `"Soil Moisture Regimes"`, `"Cation-Exchange Activity Classes"`,
  `"Use of Human-Altered and Human-Transported Material Classes"`

- chapter:

  optional filtering vector for chapter number

- page:

  optional filtering vector; page number (12th Edition Keys to Soil
  Taxonomy)

- multiline_sep:

  default `"\n"` returns `multiline_col` column as a character vector
  concatenated with `"\n"`. Use `NULL` for list

- multiline_col:

  character. vector of "multi-line" column names to concatenate.
  Default: `"criteria"`; use `NULL` for no concatenation.

## Value

a *data.frame*

a subset of `ST_family_classes` *data.frame*

## Details

This is a wrapper method around the package data set
`ST_family_classes`.

## See also

`ST_family_classes` `ST_features`
[`get_ST_features()`](http://ncss-tech.github.io/SoilTaxonomy/reference/get_ST_features.md)

## Examples

``` r

# get classes in chapter 17
str(get_ST_family_classes(chapter = 17))
#> 'data.frame':    169 obs. of  8 variables:
#>  $ DomainID   : int  126 126 126 126 126 126 126 126 126 126 ...
#>  $ classname  : chr  "glauconitic" "allitic" "amorphic" "carbonatic" ...
#>  $ group      : chr  "Mineral Family" "Mineral Family" "Mineral Family" "Mineral Family" ...
#>  $ name       : chr  "Mineralogy Classes" "Mineralogy Classes" "Mineralogy Classes" "Mineralogy Classes" ...
#>  $ chapter    : int  17 17 17 17 17 17 17 17 17 17 ...
#>  $ page       : int  325 325 325 325 325 325 325 325 325 325 ...
#>  $ description: chr  "The mineralogy of soils is known to be useful in making predictions about soil behavior and responses to manage"| __truncated__ "The mineralogy of soils is known to be useful in making predictions about soil behavior and responses to manage"| __truncated__ "The mineralogy of soils is known to be useful in making predictions about soil behavior and responses to manage"| __truncated__ "The mineralogy of soils is known to be useful in making predictions about soil behavior and responses to manage"| __truncated__ ...
#>  $ criteria   : chr  "" "" "" "" ...

# get classes on page 323
get_ST_family_classes(page = 323)
#>     DomainID       classname          group
#> 180     5247          araric Mineral Family
#> 181     5247      artifactic Mineral Family
#> 182     5247      ashifactic Mineral Family
#> 183     5247       asphaltic Mineral Family
#> 184     5247       combustic Mineral Family
#> 185     5247       concretic Mineral Family
#> 186     5247         dredgic Mineral Family
#> 187     5247     gypsifactic Mineral Family
#> 188     5247    methanogenic Mineral Family
#> 189     5247 pauciartifactic Mineral Family
#> 190     5247    pyrocarbonic Mineral Family
#> 191     5247          spolic Mineral Family
#> 192     5247        not used Mineral Family
#>                                                            name chapter page
#> 180 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 181 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 182 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 183 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 184 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 185 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 186 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 187 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 188 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 189 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 190 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 191 Use of Human-Altered and Human-Transported Material Classes      17  323
#> 192 Use of Human-Altered and Human-Transported Material Classes      17  323
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            description
#> 180 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 181 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 182 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 183 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 184 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 185 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 186 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 187 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 188 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 189 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 190 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 191 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#> 192 Human-altered and human-transported material classes are only used in taxa of mineral soils where one of the following occurs: (1) human-altered or human-transported material extends from the soil surface to a depth of 50 cm or to a root-limiting layer, whichever is shallower; or (2) the soil classifies in an Anthraltic, Anthraquic, Anthrodensic, Anthropic, Anthroportic, Haploplaggic, or Plaggic extragrade subgroup (defined in chapter 3). In other taxa, the class is omitted from the family name and the parent material is identified at the soil series level. Examples of soils that use human-altered and human- transported material classes and formed in human-transported material are a fine, methanogenic, mixed, active, nonacid, thermic Anthrodensic Ustorthent, which was compacted during construction of a sanitary landfill, and a fine-loamy, spolic, mixed, active, calcareous, mesic Anthroportic Udorthent, which resulted from reclamation of a surface coal mine. An example of a soil using a human-altered and human-transported material class, which formed in human-altered material as a result of mechanical displacement of a preexisting natric horizon, is a fine, araric, smectitic, calcareous, thermic Anthraltic Sodic Xerorthent. Key to the Control Section for Human-Altered and Human-Transported Material Classes  The control section for the human-altered and human- transported material classes is from the soil surface to one of the following depths, whichever is shallower:
#>                                                                                                                                                      criteria
#> 180 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 181 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 182 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 183 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 184 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 185 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 186 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 187 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 188 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 189 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 190 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 191 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.
#> 192 A. 200 cm; or\nB. The lower boundary of the deepest horizon formed in human-altered or human-transported material; or\nC. A lithic or paralithic contact.

# get the description for the mesic temperature class from list column
str(get_ST_family_classes(classname = "mesic")$description)
#>  chr "Soil temperature classes, as named and defined here, are used as part of the family name in both mineral and or"| __truncated__
```
