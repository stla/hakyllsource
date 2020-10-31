---
author: Stéphane Laurent
date: '2017-10-24'
highlighter: 'pandoc-solarized'
output:
  html_document:
    keep_md: no
  md_document:
    preserve_yaml: True
    variant: markdown
tags: R
title: File encoding detection in R
---

There is a Java port of `universalchardet`, the encoding detector
library of Mozilla. It is called `juniversalchardet`. I'm going to show
how to use it with the `rJava` package.

Firstly, download the `jar` file here:
<https://code.google.com/archive/p/juniversalchardet/downloads>. Then,
proceed as follows:

``` {.r}
library(rJava)
.jinit()
.jaddClassPath("path/to/juniversalchardet-1.0.3.jar")
detector <- new(J("org/mozilla/universalchardet/UniversalDetector"), NULL)
f <- "juniversalchardet.Rmd" # file whose encoding you want to know
flength <- as.integer(file.size(f))
.jcall(detector, "V", "handleData",
       readBin(f, what="raw", n=flength), 0L, flength)
.jcall(detector, "V", "dataEnd")
.jcall(detector, "S", "getDetectedCharset")
## [1] "UTF-8"
.jcall(detector, "V", "reset")
```

Update 2020
===========

Nowadays one can achieve the same result with the R package `uchardet`
(which does not use Java).
