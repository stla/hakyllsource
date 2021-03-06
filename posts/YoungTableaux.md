---
author: Stéphane Laurent
date: '2017-09-09'
highlighter: 'pandoc-solarized'
output:
  html_document:
    highlight: zenburn
    keep_md: yes
  md_document:
    preserve_yaml: True
    toc: yes
    variant: markdown
rbloggers: yes
tags: 'haskell, R'
title: Young Tableaux from Haskell to R
---

The goal of this article is to show how to do a Haskell DLL for R with
functions returning an arbitrary number of vectors (atomic vectors or
lists). For the basics of exporting a Haskell function to R with the
help of a DLL, we refer the reader to [the previous
article](https://laustep.github.io/stlahblog/posts/FloatExpansionHaskell.html).

For the illustration, we will deal with Young tableaux with the help of
the
[combinat](https://hackage.haskell.org/package/combinat-0.2.8.2/docs/Math-Combinat-Tableaux.html)
library.

``` {.haskell}
Prelude> import Math.Combinat.Tableaux as T
Prelude T> tableau = [[1,2,5],[3,4]]
Prelude T> asciiTableau tableau
1 2 5 
3 4
```

We will firstly port the `dualTableau` function to R.

``` {.haskell}
Prelude T> dualTableau tableau
[[1,3],[2,4],[5]]
```

Thus, we want a R function that takes as input
`list(c(1L,2L,5L),c(3L,4L))` and returns `list(c(1L,3L),c(2L,4L),5L)`.

Below is a first way to do so. To import the input list in Haskell, we
use `peekArray`, which requires to enter the length of the input list.
To export the output list, we use `pokeArray`.

``` {.haskell .numberLines}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE DataKinds #-}
module Lib where
import Foreign
import Foreign.C
import Foreign.R (SEXP)
import qualified Foreign.R.Type as R
import qualified Data.Vector.SEXP as VS
import Math.Combinat.Tableaux

foreign export ccall dualTableauR1 :: Ptr (SEXP s R.Int) -> Ptr CInt ->
                                                     Ptr (SEXP s R.Int) -> IO ()
dualTableauR1 :: Ptr (SEXP s R.Int) -> Ptr CInt -> Ptr (SEXP s R.Int) -> IO ()
dualTableauR1 _tableau l result = do
  l <- peek l
  _tableau <- peekArray (fromIntegral l :: Int) _tableau
  let tableau = map (VS.toList . VS.fromSEXP) _tableau
  let dtableau = dualTableau tableau
  pokeArray result $ map (VS.toSEXP . VS.fromList) dtableau
```

This way has an inconvenient: in order to use the function in R, we need
to give the length of the output list. But this is not a problem for
this example: the length of the output list is the length of the first
vector (the first "row") of the input list.

``` {.r}
> tableau <- list(c(1L, 2L, 5L), c(3L, 4L))
> .C("dualTableauR1", tableau=tableau, l=length(tableau), 
+           result=as.list(integer(length(tableau[[1]]))))$result
[[1]]
[1] 1 3

[[2]]
[1] 2 4

[[3]]
[1] 5
```

The second way we give below overcomes this inconvenient:

``` {.haskell .numberLines}
...
import Language.R.Literal (mkProtectedSEXPVector)
import Data.Singletons (sing)

foreign export ccall dualTableauR2 :: Ptr (SEXP s R.Int) -> Ptr CInt ->
                                                  Ptr (SEXP s R.Vector) -> IO ()
dualTableauR2 :: Ptr (SEXP s R.Int) -> Ptr CInt -> Ptr (SEXP s R.Vector) -> IO ()
dualTableauR2 _tableau l result = do
  l <- peek l
  _tableau <- peekArray (fromIntegral l :: Int) _tableau
  let tableau = map (VS.toList . VS.fromSEXP) _tableau
  poke result $ mkProtectedSEXPVector sing $
    (map (VS.toSEXP . VS.fromList) (dualTableau tableau) :: [SEXP s R.Int])
```

Indeed, we don't need to enter the length of the output list:

``` {.r}
> tableau <- list(c(1L, 2L, 5L), c(3L, 4L))
> .C("dualTableauR2", tableau=tableau, l=length(tableau), 
+           result=list(0L))$result[[1]]
[[1]]
[1] 1 3

[[2]]
[1] 2 4

[[3]]
[1] 5
```

These two ways to export the `dualTableau` function achieve a comparable
performance:

``` {.r}
> tableau <- list(c(1L, 3L, 4L, 6L, 7L), c(2L, 5L, 8L, 10L), 9L)
> library(microbenchmark)
> microbenchmark(
+   R1 = .C("dualTableauR1", tableau=tableau, l=length(tableau), 
+           result=as.list(integer(length(tableau[[1]]))))$result,
+   R2 = .C("dualTableauR2", tableau=tableau, l=length(tableau), 
+           result=list(0L))$result[[1]]
+ ) 
Unit: microseconds
 expr    min      lq     mean  median      uq      max neval
   R1 35.253 51.5410 256.2568 58.9040 74.2990 9919.870   100
   R2 30.791 36.1455 351.1271 41.5005 48.8635 8978.753   100
```

Thus, using the second way, we are able to get an arbitrary number of
atomic vectors, without knowing in advance this number.

Now, in order to show how to get an arbitrary number of lists, we will
export the `standardYoungTableaux` functions, which returns the list of
standard Young tableaux whose shape is a given partition.

``` {.haskell .numberLines}
...
import Math.Combinat.Partitions.Integer

foreign export ccall standardYoungTableauxR :: Ptr CInt -> Ptr CInt ->
                                                   Ptr (SEXP s R.Vector) -> IO()
standardYoungTableauxR :: Ptr CInt -> Ptr CInt -> Ptr (SEXP s R.Vector) -> IO()
standardYoungTableauxR partition l result = do
  l <- peek l
  partition <- peekArray (fromIntegral l :: Int) partition
  let tableaux = standardYoungTableaux (mkPartition $ map fromIntegral partition)
  let tableaux32 = map (map (map fromIntegral)) tableaux :: [[[Int32]]]
  let tableauxAsSEXP = map (\x -> (mkProtectedSEXPVector sing $
                            (map (VS.toSEXP . VS.fromList) x :: [SEXP s R.Int]))
                              :: SEXP s R.Vector) tableaux32
  poke result $ mkProtectedSEXPVector sing tableauxAsSEXP
```

Here is an example of a call:

``` {.r}
> shape <- c(3L, 2L)
> .C("standardYoungTableauxR", partition=shape, l=length(partition), 
+    result=list(0L))$result[[1]]
[[1]]
[[1]][[1]]
[1] 1 3 5

[[1]][[2]]
[1] 2 4


[[2]]
[[2]][[1]]
[1] 1 2 5

[[2]][[2]]
[1] 3 4


[[3]]
[[3]][[1]]
[1] 1 3 4

[[3]][[2]]
[1] 2 5


[[4]]
[[4]][[1]]
[1] 1 2 4

[[4]][[2]]
[1] 3 5


[[5]]
[[5]][[1]]
[1] 1 2 3

[[5]][[2]]
[1] 4 5
```

I've included these functions and more in a R package. It will soon be
available in [my drat repo](https://stlarepo.github.io/drat/), and the
source code is available in [my Github
repo](https://github.com/stla/tableaux).
