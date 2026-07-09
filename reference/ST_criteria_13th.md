# Keys to Soil Taxonomy Criteria (13th Edition)

A lookup table relating taxon codes to specific criteria from the Keys
to Soil Taxonomy (13th Edition)

## Usage

``` r
data(ST_criteria_13th)
```

## Format

An object of class `list` of length 3153.

## Details

A `list` containing one element per taxon code at order to subgroup
level. Each element contains a `data.frame` with 1 row per criterion,
and 8 columns:

Each `data.frame` contains the following columns:

- `content` (text content of criterion)

- `chapter` (chapter number)

- `page` (page number)

- `key` (key name or level)

- `taxon` (taxon name)

- `code` (taxon code)

- `clause` (sequence number of criterion within taxon)

- `logic` (logical meaning of criterion)

  - One of:

    - `FIRST` (first)

    - `OR` (either this criterion OR the next criterion at same level)

    - `END` (end of hierarchical key)

    - `NEW` (go to new page/taxon specified)

    - `AND` (this criterion AND the next criterion at same level)

    - `HAVE` (criteria that must be met)

    - `LAST` (end of subgroup key)

## References

Soil Survey Staff. 2022. Keys to Soil Taxonomy, 13th ed. USDA-Natural
Resources Conservation Service.
<https://www.nrcs.usda.gov/resources/guides-and-instructions/keys-to-soil-taxonomy>
