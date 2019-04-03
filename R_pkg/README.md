# SoilTaxonomy

## Installation

Install dependencies from CRAN

```r
install.packages(c('stringdist', 'purrr', 'stringi', 'data.tree'), dep=TRUE)
```

Get the development version from Github. The latest this will require the latest version of `remotes`.

```r
remotes::install_github("ncss-tech/SoilTaxonomy/R_pkg", dependencies=FALSE, upgrade=FALSE, build=FALSE)
```

Give it a try.
```r
library(SoilTaxonomy)

# label formative elements in the hierarchy with brief explanations
cat(explainST('typic endoaqualfs'))

cat(explainST('abruptic haplic durixeralfs'))
```

```
typic endoaqualfs
|     |   |  |                                                                                      
central theme of subgroup concept                                                                   
      |   |  |                                                                                      
      ground water table                                                                            
          |  |                                                                                      
          characteristics associated with wetness                                                   
             |                                                                                      
             soils with an argillic, kandic, or natric horizon
             
abruptic haplic durixeralfs
|        |      |   |  |                                                                            
abrupt textural change                                                                              
         |      |   |  |                                                                            
         central theme of subgroup concept                                                          
                |   |  |                                                                            
                presence of a duripan                                                               
                    |  |                                                                            
                    xeric SMR                                                                       
                       |                                                                            
                       soils with an argillic, kandic, or natric horizon                            
```


Using `data.tree` to work with the hierarchy.
<pre style="font-size: 10em;">
                                  levelName       ac
1  xeralfs                                     16554816
2   ¦--durixeralfs                              1704451
3   ¦   ¦--abruptic durixeralfs                  923662
4   ¦   ¦--abruptic haplic durixeralfs            30118
5   ¦   ¦--aquic durixeralfs                       7267
6   ¦   ¦--haplic durixeralfs                     49027
7   ¦   ¦--natric durixeralfs                    158112
8   ¦   ¦--typic durixeralfs                     536265
9   ¦   °--vertic durixeralfs                         0
10  ¦--fragixeralfs                              141400
11  ¦   ¦--andic fragixeralfs                         0
12  ¦   ¦--aquic fragixeralfs                       924
13  ¦   ¦--inceptic fragixeralfs                      0
14  ¦   ¦--mollic fragixeralfs                    31906
15  ¦   ¦--typic fragixeralfs                         0
16  ¦   °--vitrandic fragixeralfs                108570
17  ¦--haploxeralfs                            11721233
18  ¦   ¦--andic haploxeralfs                    316458
19  ¦   ¦--aquandic haploxeralfs                  27437
20  ¦   ¦--aquic haploxeralfs                     88948
21  ¦   ¦--aquultic haploxeralfs                 160574
22  ¦   ¦--calcic haploxeralfs                   131105
23  ¦   ¦--fragiaquic haploxeralfs                 1350
24  ¦   ¦--fragic haploxeralfs                     1431
25  ¦   ¦--inceptic haploxeralfs                   1392
26  ¦   ¦--lamellic haploxeralfs                  15241
27  ¦   ¦--lithic haploxeralfs                   236502
28  ¦   ¦--lithic mollic haploxeralfs            597510
29  ¦   ¦--lithic ruptic-inceptic haploxeralfs   190796
30  ¦   ¦--mollic haploxeralfs                  2339766
31  ¦   ¦--natric haploxeralfs                    96027
32  ¦   ¦--plinthic haploxeralfs                      0
33  ¦   ¦--psammentic haploxeralfs                16987
34  ¦   ¦--typic haploxeralfs                   2033127
35  ¦   ¦--ultic haploxeralfs                   4827155
36  ¦   ¦--vertic haploxeralfs                     9889
37  ¦   °--vitrandic haploxeralfs                629538
38  ¦--palexeralfs                              2393894
39  ¦   ¦--andic palexeralfs                      43332
40  ¦   ¦--aquandic palexeralfs                   21924
41  ¦   ¦--aquic palexeralfs                     201617
42  ¦   ¦--arenic palexeralfs                         0
43  ¦   ¦--calcic palexeralfs                        41
44  ¦   ¦--fragiaquic palexeralfs                     0
45  ¦   ¦--fragic palexeralfs                         0
46  ¦   ¦--haplic palexeralfs                     28882
47  ¦   ¦--lamellic palexeralfs                       0
48  ¦   ¦--mollic palexeralfs                    549189
49  ¦   ¦--natric palexeralfs                     33585
50  ¦   ¦--petrocalcic palexeralfs                 3221
51  ¦   ¦--plinthic palexeralfs                       0
52  ¦   ¦--psammentic palexeralfs                     0
53  ¦   ¦--typic palexeralfs                     491630
54  ¦   ¦--ultic palexeralfs                     812194
55  ¦   ¦--vertic palexeralfs                     11073
56  ¦   °--vitrandic palexeralfs                 197206
57  ¦--natrixeralfs                              418472
58  ¦   ¦--aquic natrixeralfs                     53619
59  ¦   ¦--typic natrixeralfs                    358187
60  ¦   °--vertic natrixeralfs                     6666
61  ¦--rhodoxeralfs                              175366
62  ¦   ¦--calcic rhodoxeralfs                        0
63  ¦   ¦--inceptic rhodoxeralfs                      0
64  ¦   ¦--lithic rhodoxeralfs                        0
65  ¦   ¦--petrocalcic rhodoxeralfs                   0
66  ¦   ¦--typic rhodoxeralfs                    172935
67  ¦   °--vertic rhodoxeralfs                     2431
68  °--plinthoxeralfs                                 0
69      °--typic plinthoxeralfs                       0
</pre>


