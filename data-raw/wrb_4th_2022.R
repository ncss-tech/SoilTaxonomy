## code to prepare `wrb_4th_2022` dataset goes here
library(pdftools)

## SETUP
## 
# dir.create("misc/WRB2022")
# download.file("https://wrb.isric.org/files/WRB_fourth_edition_2022-12-18.pdf",
#               destfile = "misc/WRB2022/WRB_fourth_edition_2022-12-18.pdf")

## does not work for RSG/qualifiers; tables used in formatting
## can be used for definitions of diagnostics and qualifiers
# x <- pdf_text("misc/WRB2022/WRB_fourth_edition_2022-12-18.pdf")
# x <- unlist(strsplit(x, "\n"))
# ldx <- cumsum(grepl("Key to the Reference Soil Groups", x))
# y <- split(x, ldx)
# data.frame(y[[11]]) |> View()

## nope
# x <- pdf_data("misc/WRB2022/WRB_fourth_edition_2022-12-18.pdf")
# y <- do.call('rbind', x)
# 

x <- readLines("misc/WRB2022/WRB_RSG.txt")
x <- gsub("\u003c", "<", gsub("\u003E", ">", gsub("\u2264", "<=", gsub("\u2265", ">=", x))))
n <- grep("^[A-Z]+$", x)
z.names <- x[n]
x <- x[-n]
idx <- grep("^(Soils having|Other soils)", x)
ldx <- rep(FALSE, length(x))
ldx[idx] <- TRUE
xx <- split(x, cumsum(ldx))
z <- lapply(xx, function(y) {
  i <- grep("(; (and|or)|\\.|:)$", y) + 1
  i <- i[i < length(y)]
  l <- rep(FALSE, length(y))
  l[i] <- TRUE
  sapply(split(y, cumsum(l)), paste0, collapse = " ")
})
names(z) <- z.names

wrb_rsg <- do.call('rbind', lapply(seq(z), function(i) {
  data.frame(code = i, reference_soil_group = z.names[i], criteria = z[[z.names[i]]])
}))
rownames(wrb_rsg) <- NULL
# View(wrb_rsg)

x <- readLines("misc/WRB2022/WRB_PQ.txt")
n <- grep("^[A-Z]+$", x)
z.names <- x[n]
x <- x[-n]
idx <- grep("Principal qualifiers", x)
ldx <- rep(FALSE, length(x))
ldx[idx] <- TRUE
xx <- split(x, cumsum(ldx))
z <- lapply(xx, function(y) {
  y <- trimws(gsub("([^ ])/ ", "\\1 / ", y))
  y[y != "Principal qualifiers"]
})
names(z) <- z.names

wrb_pq <- do.call('rbind', lapply(seq(z), function(i) {
  data.frame(code = i, reference_soil_group = z.names[i], principal_qualifiers = z[[z.names[i]]])
}))
rownames(wrb_pq) <- NULL
# View(wrb_pq)

x <- readLines("misc/WRB2022/WRB_SQ.txt")
n <- grep("^[A-Z]+$", x)
z.names <- x[n]
x <- x[-n]
idx <- grep("Supplementary qualifiers", x)
ldx <- rep(FALSE, length(x))
ldx[idx] <- TRUE
xx <- split(x, cumsum(ldx))
z <- lapply(xx, function(y) {
  y <- trimws(gsub("([^ ])/ ", "\\1 / ", y))
  y[y != "Supplementary qualifiers"]
})
names(z) <- z.names

wrb_sq <- do.call('rbind', lapply(seq(z), function(i) {
  data.frame(code = i, reference_soil_group = z.names[i], supplementary_qualifiers = z[[z.names[i]]])
}))
rownames(wrb_sq) <- NULL
# View(wrb_sq)

wrb_4th_2022 <- list(
  rsg = wrb_rsg,
  pq  = wrb_pq,
  sq  = wrb_sq
)

usethis::use_data(wrb_4th_2022, overwrite = TRUE)
