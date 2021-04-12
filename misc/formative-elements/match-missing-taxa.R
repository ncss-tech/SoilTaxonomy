

.match_taxa <- function(pattern) {
  
  # for R CMD check
  ST_higher_taxa_codes_12th <- NULL
  
  # load local copy of taxon code lookup table
  load(system.file("data/ST_higher_taxa_codes_12th.rda", package = "SoilTaxonomy")[1])
  
  # subset by pattern
  ST_higher_taxa_codes_12th[grep(pattern, ST_higher_taxa_codes_12th$taxon, ignore.case = TRUE),]
}

# missing explanations for these subgroups
subgroup_elements <- read.table(
  text = "acraquoxic
          acrudoxic
          acrustoxic
          albaquultic
          andic
          anhydritic
          anthraltic
          anthrodensic
          anthroportic
          aqualfic
          aquandic
          aquentic
          aqueptic
          aquertic
          aquicambidic
          aquodic
          aquollic
          aquultic
          argiaquic
          argidic
          argiduridic
          calciargidic
          calcidic
          cambidic
          duridic
          fluventic
          folistic
          grossic
          haplargidic
          haplocalcidic
          haploduridic
          haploplaggic
          haploxeralfic
          haploxerandic
          haploxerollic
          haplustandic
          histic
          humaqueptic
          hydraquentic
          inceptic
          kandiudalfic
          kandiustalfic
          kanhaplic
          lithic-ruptic-entic
          mollic
          natrargidic
          natrixeralfic
          oxic
          paleargidic
          palexerollic
          petrocalcidic
          plinthaquic
          psammentic
          rendollic
          ruptic-alfic
          ruptic-entic
          ruptic-histic
          ruptic-inceptic
          ruptic-lithic
          ruptic-ultic
          salidic
          spodic
          sulfaqueptic
          sulfuric
          thapto-histic
          torrertic
          torrifluventic
          torriorthentic
          torripsammentic
          torroxic
          udandic
          udertic
          udifluventic
          udollic
          udorthentic
          udoxic
          ultic
          ustalfic
          ustandic
          ustertic
          ustifluventic
          ustivitrandic
          ustollic
          ustoxic
          vertic
          vitrandic
          vitritorrandic
          vitrixerandic
          xeralfic
          xereptic
          xerertic
          xerofluventic
          xerollic"
        )

# helper method to use KSTLookup plumber API endpoint / equivalent lookup table
.taxon_criteria <- function(st_db12_html, code, language = "EN") {
  # slow but works anywhere with internet
  # response <- httr::GET(sprintf("http://138.68.55.88/kstl?code=%s&language=%s", code, language))
  # r.content <- httr::content(response, as = "text", encoding = "UTF-8")
  # jsonlite::fromJSON(r.content, simplifyDataFrame = TRUE)[[1]]
  # 
  st_db12_html[[code]]
}

library(magrittr)

load("E:/workspace/ncss-standards/KST/Plumber/plumber/soiltaxonomy_12th_db_HTML_EN.Rda")

res <- do.call('rbind', lapply(paste0('^', subgroup_elements$V1), function(y) {
    res2 <- do.call('rbind', lapply(.match_taxa(y)$code, function(x) {
        if(length(x) == 0) return(NULL)
        res3 <- .taxon_criteria(st_db12_html, x) %>% subset(crit == x & logic != "LAST")
        if (nrow(res3) == 0) return(NULL)
        data.frame(taxon = as.character(SoilTaxonomy::taxon_code_to_taxon(x)), res3)
      }))
    if (is.null(res2)) return(NULL)
    data.frame(element = y, res2)
  }))

write.csv(res, 
          file = "E:/workspace/SoilTaxonomy/misc/formative-elements/subgroup_criteria_unexplained.csv", 
          row.names = FALSE)

knitr::kable(res, row.names = FALSE)
