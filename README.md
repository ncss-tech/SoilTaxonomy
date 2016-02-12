## Code related to Soil Taxonomy Task Force

## Visualization

![alt.text](xeralfs-graph.png)


## Examples for storing a digital version of the keys

### `data.tree`
<pre>
                                     levelName       ac
1  xeralfs                                     15406814
2   ¦--durixeralfs                              1684855
3   ¦   ¦--typic durixeralfs                     536264
4   ¦   ¦--vertic durixeralfs                         0
5   ¦   ¦--haplic durixeralfs                     49009
6   ¦   ¦--natric durixeralfs                    158112
7   ¦   ¦--abruptic durixeralfs                  904387
8   ¦   ¦--abruptic haplic durixeralfs            29816
9   ¦   °--aquic durixeralfs                       7267
10  ¦--fragixeralfs                              139096
11  ¦   ¦--typic fragixeralfs                         0
12  ¦   ¦--vitrandic fragixeralfs                108570
13  ¦   ¦--mollic fragixeralfs                    30021
14  ¦   ¦--aquic fragixeralfs                       505
15  ¦   ¦--inceptic fragixeralfs                      0
16  ¦   °--andic fragixeralfs                         0
17  ¦--haploxeralfs                            10728500
18  ¦   ¦--typic haploxeralfs                   1977587
19  ¦   ¦--ultic haploxeralfs                   4194840
20  ¦   ¦--vertic haploxeralfs                     5921
21  ¦   ¦--vitrandic haploxeralfs                588744
22  ¦   ¦--lithic haploxeralfs                   222443
23  ¦   ¦--lithic mollic haploxeralfs            580959
24  ¦   ¦--lithic ruptic-inceptic haploxeralfs   152066
25  ¦   ¦--mollic haploxeralfs                  2299134
26  ¦   ¦--natric haploxeralfs                    96026
27  ¦   ¦--plinthic haploxeralfs                      0
28  ¦   ¦--psammentic haploxeralfs                16987
29  ¦   ¦--aquic haploxeralfs                     78388
30  ¦   ¦--aquultic haploxeralfs                 143091
31  ¦   ¦--calcic haploxeralfs                    22991
32  ¦   ¦--fragiaquic haploxeralfs                 1350
33  ¦   ¦--fragic haploxeralfs                     1431
34  ¦   ¦--inceptic haploxeralfs                   1392
35  ¦   ¦--lamellic haploxeralfs                  13177
36  ¦   ¦--andic haploxeralfs                    304536
37  ¦   °--aquandic haploxeralfs                  27437
38  ¦--natrixeralfs                              420702
39  ¦   ¦--typic natrixeralfs                    355846
40  ¦   ¦--vertic natrixeralfs                        0
41  ¦   °--aquic natrixeralfs                     64856
42  ¦--palexeralfs                              2260906
43  ¦   ¦--typic palexeralfs                     488880
44  ¦   ¦--ultic palexeralfs                     712918
45  ¦   ¦--vertic palexeralfs                     10045
46  ¦   ¦--vitrandic palexeralfs                 192545
47  ¦   ¦--mollic palexeralfs                    534669
48  ¦   ¦--natric palexeralfs                     32698
49  ¦   ¦--petrocalcic palexeralfs                 2065
50  ¦   ¦--plinthic palexeralfs                       0
51  ¦   ¦--psammentic palexeralfs                     0
52  ¦   ¦--aquic palexeralfs                     198722
53  ¦   ¦--arenic palexeralfs                         0
54  ¦   ¦--calcic palexeralfs                        41
55  ¦   ¦--fragiaquic palexeralfs                     0
56  ¦   ¦--fragic palexeralfs                         0
57  ¦   ¦--haplic palexeralfs                     24847
58  ¦   ¦--lamellic palexeralfs                       0
59  ¦   ¦--andic palexeralfs                      41552
60  ¦   °--aquandic palexeralfs                   21924
61  ¦--plinthoxeralfs                                 0
62  ¦   °--typic plinthoxeralfs                       0
63  °--rhodoxeralfs                              172755
64      ¦--typic rhodoxeralfs                    170324
65      ¦--vertic rhodoxeralfs                     2431
66      ¦--lithic rhodoxeralfs                        0
67      ¦--petrocalcic rhodoxeralfs                   0
68      ¦--calcic rhodoxeralfs                        0
69      °--inceptic rhodoxeralfs                      0
</pre>


### JSON
<pre>
{
  "taxon": "haploxeralfs",
  "children": [
    {
      "taxon": "typic haploxeralfs",
      "ac": 1977393,
      "n_polygons": 34229,
      "tax_greatgroup": "haploxeralfs",
      "tax_order": "alfisols",
      "tax_subgroup": "typic haploxeralfs",
      "tax_suborder": "xeralfs"
    },
    {
      "taxon": "ultic haploxeralfs",
      "ac": 4193577,
      "n_polygons": 47116,
      "tax_greatgroup": "haploxeralfs",
      "tax_order": "alfisols",
      "tax_subgroup": "ultic haploxeralfs",
      "tax_suborder": "xeralfs"
    },
    {
      "taxon": "vertic haploxeralfs",
      "ac": 5921,
      "n_polygons": 76,
      "tax_greatgroup": "haploxeralfs",
      "tax_order": "alfisols",
      "tax_subgroup": "vertic haploxeralfs",
      "tax_suborder": "xeralfs"
    },
    ...
  ]
}
</pre>