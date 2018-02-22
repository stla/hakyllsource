---
title: "Calling a Haskell function in R - a float expansion example"
author: "StÃ©phane Laurent"
date: '2017-06-03'
output:
  pdf_document: default
  html_document:
    highlight: zenburn
    keep_md: yes
---



### Call in R

We firstly load the library with:


```r
dyn.load("FloatExpansion1.dll")
.C("HsStart")
## list()
```

And we invoke the function with the help of the `.C` function, as follows:


```r
.C("floatExpansion", base=2L, x=0.125, result="")$result
## [1] "[0,0,1]"
```


```r
dyn.unload("FloatExpansion1.dll")
```



## Second dynamic linker: vector output


```r
dyn.load("FloatExpansion2.dll")
.C("HsStart")
## list()
```


And we invoke the function with the help of the `.C` function, as follows:


```r
.C("floatExpansion", base=2L, x=0.125, result=list(0L))$result
## [[1]]
## [1] 0 0 1
```


Let's write a user-friendly function:


```r
floatExpand <- function(x, base=2L){
  .C("floatExpansion", base=as.integer(base), x=as.double(x), result=list(integer(1)))$result[[1]]  
}
```


```r
floatExpand(1/3+1/27, base=3)
## [1] 1 0 1
```


```r
dyn.unload("FloatExpansion2.dll")
```
