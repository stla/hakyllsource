---
title: "The Cantor expansion revisited"
author: "Stéphane Laurent"
date: '2023-09-15'
tags: R, Rcpp, maths
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

On my former blog, I wrote [a
post](https://stla.github.io/stlapblog/posts/Greedy.html) about the
*Cantor expansion* of a natural integer. This is a generalization of the
well-known binary expansion. For example, the Cantor $(3,4,5)$-expansion
of a natural integer $N$ is a triplet $$
(\epsilon_0, \epsilon_1, \epsilon_2) \in 
\{0,1,2\} \times \{0,1,2,3\} \times \{0,1,2,3,4\}
$$ such that $$
N = \epsilon_0 + \epsilon_1 \times 3 + \epsilon_2 \times (3\times 4).
$$ It exists for every natural number $N$ lower than or equal to
$3 \times 4 \times 5 - 1 = 59$.

A binary expansion is a Cantor $(2, 2, \ldots, 2)$-expansion.

In the article of my former blog, I explain how that can be used to
transform a nested loop to a single loop.

To get a Cantor expansion, I described the *greedy algorithm* on my
former blog. It is implemented as follows:

``` r
Cantor_greedy <- function(n, sizes) {
  l <- c(1, cumprod(sizes))
  epsilon <- numeric(length(sizes))
  while(n > 0){
    k <- which.min(l <= n)
    e <- floor(n / l[k-1])
    epsilon[k-1] <- e
    n <- n - e * l[k-1]
  }
  epsilon
}
```

Later, on StackOverflow, a user opened a
[question](https://stackoverflow.com/q/74563284/1100107) entitled
*Efficiently create random sample from `expand.grid` output without
using `expand.grid`*. I immediately replied and suggested to use a
Cantor expansion.

But another user, Robert Hacken, replied too, and he gave an answer
seemingly different of mine at first glance, but in fact *it was the
same*. Actually this user provided another way to derive a Cantor
expansion of an integer:

``` r
mod2 <- function(x, y) {
  (x-1) %% y
}
Cantor_Hacken <- function(n, sizes) {
  p <- cumprod(c(1, head(sizes, -1)))
  mod2(ceiling((n + 1) / p), sizes)
}
```

We can check these two ways give the same result:

``` r
Cantor_greedy(n = 29, sizes = c(3, 4, 5))
## [1] 2 1 2
Cantor_Hacken(n = 29, sizes = c(3, 4, 5))
## [1] 2 1 2
```

On StackOverflow, I compared the speed of the two R functions, and
Hacken's one is faster. I also compared the speed of Hacken's R function
and the Rcpp implementation of the greedy algorithm given in my former
blog, and this one is faster. It is now time to compare two Rcpp
implementations.

``` r
library(inline)

# greedy 
src <- 'int n = as<int>(N);
std::vector<int> s = as<std::vector<int>>(sizes);
std::vector<int> epsilon(s.size());
std::vector<int>::iterator it;
it = s.begin();
it = s.insert(it, 1);
int G[s.size()];
std::partial_sum(s.begin(), s.end(), G, std::multiplies<int>());
int k;
while(n > 0) {
  k = 1;
  while(G[k] <= n) {
    k++;
  }
  epsilon[k-1] = (int)n / G[k-1];
  n = n % G[k-1];
}
return wrap(epsilon);'

greedy_Rcpp <- cxxfunction(
  signature(N = "integer", sizes = "integer"), body = src, plugin = "Rcpp"
)

# Hacken 
src <- 'int n = as<int>(N);
std::vector<int> s = as<std::vector<int>>(sizes);
int l = s.size();
std::vector<int> epsilon(l);
int p = 1;
double t = n + 1;
for(int i = 0; i < l; i++) {
  epsilon[i] = ((int)ceil(t / p) - 1) % s[i];
  p *= s[i];
}
return wrap(epsilon);'

Hacken_Rcpp <- cxxfunction(
  signature(N = "integer", sizes = "integer"), body = src, plugin = "Rcpp"
)

# check
greedy_Rcpp(N = 29L, sizes = c(3L, 4L, 5L))
## [1] 2 1 2
Hacken_Rcpp(N = 29L, sizes = c(3L, 4L, 5L))
## [1] 2 1 2

# benchmark
library(microbenchmark)

sizes <- 2L:10L

greedy <- function() {
  L <- vector("list", length = prod(sizes))
  for(n in seq_len(prod(sizes))) {
    L[[n]] <- greedy_Rcpp(n, sizes)
  }
}

Hacken <- function() {
  L <- vector("list", length = prod(sizes))
  for(n in seq_len(prod(sizes))) {
    L[[n]] <- Hacken_Rcpp(n, sizes)
  }
}

print(
  microbenchmark(
    greedy = greedy(),
    Hacken = Hacken(),
    times = 20L
  ),
  signif = 5
)
## Unit: seconds
##    expr    min     lq   mean median     uq    max neval
##  greedy 7.4789 8.8480 10.022  9.784 10.478 16.557    20
##  Hacken 7.5696 8.8942 10.689 10.011 12.404 15.998    20
```

Well, the speeds are rather similar.
But that could depend on the values of `sizes`; we could perform finer
comparisons.
