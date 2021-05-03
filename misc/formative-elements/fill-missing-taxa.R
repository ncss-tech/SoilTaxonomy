library(dplyr, warn=FALSE)
library(tokenizers)

scu <- read.csv("~/workspace/SoilTaxonomy/misc/formative-elements/subgroup_criteria_unexplained.csv", stringsAsFactors = FALSE)

scut <- scu %>% 
  group_by(element, taxon) %>% 
  summarize(element = unique(element), 
            content = paste0(content, collapse = "\n"))

scut$content_tokens <- tokenizers::tokenize_words(scut$content)

fmt_colormatch <- lapply(split(scut, f = scut$element), function(scusub) {
  
  nidx <- 1:nrow(scusub)
  
  # create token comparison sets; n taxa in a element group get compared to n - 1 non-self criteria
  res1 <- lapply(nidx, function(i)
    lapply(nidx[nidx != i], function(j) {
      tokens <- scusub[i, 'content_tokens'][[1]][[1]]
      nonselftokens <- do.call('c', scusub[j, 'content_tokens'][[1]])
      tokens[tokens %in% nonselftokens]
    }))
  
  # take the shortest (most restrictive) set of matches
  res2 <- lapply(res1, function(x) x[[which.min(sapply(x, length))[1]]])
  
  res3 <- lapply(nidx, function(i) {
    foo <- gsub("\xbd|1 /2","1/2", gsub("&nbsp;"," ",scusub$content[i]))
    foo2 <- NULL
    try(foo2 <- tolower(foo[1]), silent = TRUE)
    if (!is.null(foo2)) {
      foo2 <- foo
    } else {
      cat("### ",unique(scusub$element),"\n\n")
    }
    if(is.null(res2[[i]])) return(NULL)
    res <- as.list(apply(stringr::str_locate(foo2[1], res2[[i]]), 1,
                  function(x)
                   if (!is.na(x[1]))# && x[2] - x[1] > 0)
                    list(
                      old = substr(foo, x[1], x[2]),
                      new = substr(foo, x[1], x[2]))#crayon::red(substr(foo, x[1], x[2])))
                    ))
    if(length(res))
      for(j in 1:length(res)) {
        re <- res[[j]]
        if(!is.null(re))
          foo <- gsub(paste0("\\b",re$old,"\\b"), re$new, foo)
      }
    cat(foo)
    cat("\n\n")
    foo
  })
})

foo <- lapply(seq_along(fmt_colormatch)[[6]], function(i) {cat("## ", names(fmt_colormatch)[i], "\n\n")#, 
                                                          # file = "foo.txt", append = TRUE)
                                                         sapply(fmt_colormatch[[i]], cat, "\n\n"#,
                                                                # file = "foo.txt", append = TRUE)
                                                         )})

a_list <- as.list(rep("",93))
names(a_list) <- names(fmt_colormatch)
a_list[["vitrixerandic"]] <- "xeric SMR with significant amount of volcanic glass particles"
a_list[["xereptic"]] <- "duripan strongly or less cemented, SMR borders on xeric"
a_list[["xerertic"]] <- "xeric SMR with cracks 5mm or more wide and slickensides or wedge-shaped peds"
a_list[["xerollic"]] <- "xeric SMR with color and base saturation of mollic epipedon"
