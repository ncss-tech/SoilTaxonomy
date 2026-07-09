# Generate Newick Tree Format Parenthetic Strings

This function generates [Newick tree
format](https://en.wikipedia.org/wiki/Newick_format) strings for a
single tree. Taxa are assigned relative positions within their parent to
indicate the order that they "key out."

## Usage

``` r
newick_string(
  x = NULL,
  level = c("suborder", "greatgroup", "subgroup"),
  what = c("taxon", "code")
)
```

## Arguments

- x:

  Optional: a taxon name to get children of.

- level:

  Level to build the tree at. One of `"suborder"`, `"greatgroup"`,
  `"subgroup"`. Defaults to `"suborder"` when `x` is not specified. When
  `x` is specified but `level` is not specified, `level` is calculated
  from `taxon_to_level(x)`.

- what:

  Either `"taxon"` (default; for taxon names (quoted for subgroups)) or
  `"code"`

## Value

character. A single tree in parenthetical Newick or New Hampshire
format.

## Details

The output from this function is a character string with parenthetical
format encoding a single tree suitable for input into functions such as
[`ape::read.tree()`](https://rdrr.io/pkg/ape/man/read.tree.html).
Multiple trees can be combined together in the file or text string
supplied to your tree-parsing function of choice.

## Examples

``` r
if (requireNamespace("ape")) {
  par(mar = c(0, 0, 0, 0))

  # "fan"
  mytr <- ape::read.tree(text = newick_string(level = "suborder"))
  plot(mytr, "f", rotate.tree = 180, cex = 0.75)

  # "cladogram"
  mytr <- ape::read.tree(text = newick_string("durixeralfs", level = "subgroup"))
  plot(mytr, "c")

  # "cladogram" (using taxon codes instead of subgroups)
  mytr <- ape::read.tree(text = newick_string("xeralfs", level = "subgroup", what = "code"))
  plot(mytr, "c")

  dev.off()
}
#> Loading required namespace: ape


#> null device 
#>           1 
```
