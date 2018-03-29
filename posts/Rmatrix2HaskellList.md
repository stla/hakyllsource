---
author: Stéphane Laurent
date: '2018-03-13'
editor_options:
  chunk_output_type: console
highlighter: kate
linenums: True
output:
  html_document:
    keep_md: False
  md_document:
    preserve_yaml: True
    variant: markdown
prettify: True
prettifycss: 'twitter-bootstrap'
tags: 'R, haskell'
title: 'A R matrix to a Haskell list, with the `clipr` package'
---

Assume you have a matrix in R, and you want to use it in Haskell as a
list. Here is a way to go.

I will take a small matrix for the illustration.

``` {.r}
M <- rbind(
  c(1,2,1.5),
  c(0.5,2,3),
  c(5,4.3,7)
)
M
##      [,1] [,2] [,3]
## [1,]  1.0  2.0  1.5
## [2,]  0.5  2.0  3.0
## [3,]  5.0  4.3  7.0
```

So, for Haskell, you want:

``` {.haskell}
[ [1.0,  2.0,  1.5]
 ,[0.5,  2.0,  3.0]
 ,[5.0,  4.3,  7.0] ]
```

It would be very painful to do it by hands. But the `clipr` package is
your friend. First, write the matrix in the clipboard, like this:

``` {.r}
library(clipr)
write_clip(M, breaks="],\n", sep=", ")
```

No we will use `cat` to write the output to a file.

``` {.r}
library(magrittr)
myfile <- "matrix.txt"
paste0("[", read_clip()) %>% 
  cat(sep="\n", file=myfile) %>% 
    cat("]", sep="", file=myfile, append=TRUE)
```

And then, here is the content of `matrix.txt`:

``` {.txt}
[1, 2, 1.5],
[0.5, 2, 3],
[5, 4.3, 7

]
```

Well, not totally perfect. But now it's a child game to complete the
output before copying it to Haskell:

``` {.txt}
[
[1, 2, 1.5],
[0.5, 2, 3],
[5, 4.3, 7]
]
```

### Update 2018-03-29

I've written a function which gives a better result:

``` {.r}
library(clipr)
library(magrittr)
matrix2list <- function(M, outfile="haskell.txt"){
  write_clip(M, sep=", ") 
  clipboard <- c(sprintf("%s],", head(read_clip(),-1)), 
                 sprintf("%s]", tail(read_clip(),1)))
  paste0(c("[", paste0(" [", clipboard))) %>% 
    cat(sep="\n", file=outfile) %>% 
    cat("]", sep="", file=outfile, append=TRUE)
}
```

For example, `matrix2list(M)` generates the text file

``` {.txt}
[
 [1, 2, 1.5],
 [0.5, 2, 3],
 [5, 4.3, 7]
]
```

Nothing to change manually now. Just copy-paste.
