---
title: "The lazy numbers in R: correction"
author: "Stéphane Laurent"
date: '2022-11-15'
tags: R, C++, Rcpp, maths
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

Because of a change I did in the **lazyNumbers** package, I have to post
a correction to [my previous
post](https://laustep.github.io/stlahblog/posts/lazyNumbers.html).

The `as.double` function, called on a lazy number, was not stable. Now
it is. In the previous post, the following equality was true:

``` r
library(lazyNumbers)
x <- 1 - lazynb(7) * 0.1
as.double(x) == 0.3
## [1] FALSE
```

It is not true anymore. This is expected actually. Indeed, the double
numbers `0.1` and `0.3` do not exactly represent the numbers $0.1$ and
$0.3$:

``` r
print(0.1, digits = 17L)
## [1] 0.10000000000000001
print(0.3, digits = 17L)
## [1] 0.29999999999999999
```

The double representation of whole numbers is exact. The following
equality is true:

``` r
library(lazyNumbers)
x <- 1 - lazynb(7) / 10
as.double(x) == 0.3
## [1] TRUE
```

No other change, and nothing else to correct. It is time to submit the
package to CRAN. See the [Github
repository](https://github.com/stla/lazyNumbers) for another short
presentation of this package.
