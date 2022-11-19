---
title: "The missing lazy numbers: implementation"
author: "Stéphane Laurent"
date: '2022-11-19'
tags: R, C++, Rcpp, maths, haskell
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

In Haskell, for any type `T` (for example `Double`), there is a
corresponding type `Maybe T`. An object of this type either has form
`Just x`, where `x` is of type `T`, or is `Nothing`. Thus one can use
the `Maybe T` type to extend the type `T` to a type allowing missing
values. One can test whether a `Maybe T` object `y` is not "missing"
with `isJust y`, and, if so, one can extract its `T` value with
`fromJust y`, which returns the object `x` of type `T` such that `y`
equals `Just x`. There is also the function `isNothing`, whose name is
explicit.

There is something similar in C++, available since C++ 17: the type
`std::optional<T>`. I used it with **Rcpp** to allow missing values in
vectors of [lazy
numbers](https://laustep.github.io/stlahblog/posts/lazyNumbers.html).

The `lazyNumber` type is defined as follows in C++:

``` cpp
typedef CGAL::Quotient<CGAL::MP_Float> Quotient;
typedef CGAL::Lazy_exact_nt<Quotient>  lazyNumber;
```

Then one can define the `maybeLazyNumber` type:

``` cpp
typedef std::optional<lazyNumber>      maybeLazyNumber;
```

and the type `lazyVector` to deals with vectors of (maybe) lazy numbers:

``` cpp
typedef std::vector<maybeLazyNumber>   lazyVector;
```

Now, what is the equivalent of the Haskell elements `Just x` and
`Nothing` and the functions `isJust`, `isNothing`, and `fromJust`?

Well, `Nothing` corresponds to `std::nullopt`. The equivalent of
`isJust y` is obtained as follows. A `maybeLazyNumber` object `y` is
either `std::nullopt` or a pointer to a `lazyNumber` object. To test
whether `y` points to a `lazyNumber` object `x`, one simply does
`if(y)`. And if so, the `lazyNumber` object `x` is nothing but `*y`.
Thus the equivalent of the Haskell command `fromJust y` in C++ is `*y`.

For example, here is the implementation of the C++ function which
converts a vector of double numbers with possible missing values to a
vector of (maybe) lazy numbers:

``` cpp
lazyVector doubleVector_to_lazyVector(Rcpp::NumericVector dvector) {
  int n = dvector.size();
  lazyVector lvector;
  lvector.reserve(n);
  for(int i = 0; i < n; i++) {
    if(Rcpp::NumericVector::is_na(dvector(i))) {
      lvector.emplace_back(std::nullopt);
    } else {
      lvector.emplace_back(lazyNumber(dvector(i)));
    }
  }
  return lvector;
}
```

And here is the function performing the conversion in the other
direction:

``` cpp
Rcpp::NumericVector lazyVector_to_doubleVector(lazyVector lvector) {
  int n = lvector.size();
  Rcpp::NumericVector dvector(n);
  for(int i = 0; i < n; i++) {
    maybeLazyNumber y = lvector[i];
    if(y) {
      dvector(i) = Rcpp::NumericVector::get_na();
    } else {
      dvector(i) = CGAL::to_double<Quotient>((*y).exact());
    }
  }
  return dvector;
}
```
