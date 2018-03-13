---
author: Stéphane Laurent
date: '2018-03-14'
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
title: 'A R list to a Haskell list, with the `clipr` package'
---

In the [previous
post](https://laustep.github.io/stlahblog/posts/Rmatrix2HaskellList.html),
I have shown how to convert a R matrix to a Haskell list. Now I will
show how to convert a R list to a Haskell list.

Let's take this list for illustration:

``` {.r}
L <- list(c(1,2,3), c(1,2,3,4), c(1,2))
L
## [[1]]
## [1] 1 2 3
## 
## [[2]]
## [1] 1 2 3 4
## 
## [[3]]
## [1] 1 2
```

So, for Haskell, you want:

``` {.haskell}
[ [1, 2, 3]
 ,[1, 2, 3, 4]
 ,[1, 2] 
]
```

Again, the `clipr` package is your friend. First, write the matrix in
the clipboard, like this:

``` {.r}
library(clipr)
write_clip(L, breaks="],\n", sep=", ")
## Warning in flat_str(content, breaks): Coercing content to character
```

No we will deal with `gsub`, `sub` and finally `cat` to write the output
to a file.

``` {.r}
myfile <- "list.txt"
cat("[",
    sub("\\)", "]\n]", gsub("\\)]", "]", gsub("c\\(", "[" ,read_clip()))), 
    sep="\n", file=myfile)
```

And then, here is the content of `list.txt`:

``` {.txt}
[
[1, 2, 3],
[1, 2, 3, 4],
[1, 2]
]
```

Now copy-paste to Haskell, it is ready.
