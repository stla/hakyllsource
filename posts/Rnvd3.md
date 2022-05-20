---
title: "Animated multibarchart with (R)nvd3"
author: "Stéphane Laurent"
date: '2022-05-20'
tags: R, graphics, JavaScript
rbloggers: yes
output:
  md_document:
    variant: markdown
    preserve_yaml: true
  html_document:
    highlight: kate
    keep_md: no
highlighter: pandoc-solarized
---

I really like the animated multibarchart of the JavaScript library
[NVD3](https://nvd3.org/). That's why I did the 'Rnvd3' package.

``` r
library(Rnvd3)

dat <- reshape2::melt(
  apply(HairEyeColor, c(1, 2), sum), value.name = "Count"
)

# style axis titles with CSS ####
library(htmltools)
CSS <- HTML(
  ".nvd3 .nv-axis.nv-x text.nv-axislabel,
   .nvd3 .nv-axis.nv-y text.nv-axislabel {
     font-size: 2rem;
     fill: red;
  }"
)

widget <- multiBarChart(
  dat, Count ~ Eye, "Hair", palette = "turbo"
)
prependContent(
  widget,
  tags$style(CSS)
)
```

![](./figures/Rnvd3.gif)

This chart is also available in the 'rCharts' package, but this package
is not maintained.
