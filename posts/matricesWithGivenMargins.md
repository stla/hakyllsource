---
title: "Matrices with fixed row and column sums"
author: "Stéphane Laurent"
date: '2024-06-07'
tags: R, maths
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

Given two vectors $p$ and $q$ of non-negative integer numbers, denote by
$A(p, q)$ the number of matrices with non-negative integer entries whose
row sum and column sum respectively are $p$ and $q$, and denote by
$B(p, q)$ the number of matrices with entries in $\{0, 1\}$ whose row
sum and column sum respectively are $p$ and $q$.

The problem of determining $A(p,q)$ and $B(p,q)$ has a solution in the
theory of symmetric polynomials. Denote by $\lambda$ the vector obtained
by sorting $p$ in decreasing order and dropping the zero elements, and
similarly, denote by $\mu$ the vector obtained by sorting $q$ in
decreasing order and dropping the zero elements. Then $\lambda$ and
$\mu$ are two [integer
partitions](https://en.wikipedia.org/wiki/Integer_partition). In order
for the two numbers $A(p,q)$ and $B(p,q)$ to be non-zero, an obvious
necessary condition is that the sum of $p$ is equal to the sum of $q$.
Let's assume this condition holds true and denote by $n$ this common
sum. Of course, $n$ is also the sum of $\lambda$ and the sum of $\mu$.

Then it is known in the theory of symmetric polynomials that $$
A(p, q) = \sum_{\kappa \vdash n} K(\kappa, \lambda)K(\kappa, \mu)
$$ where the notation $\kappa \vdash n$ means that $\kappa$ is an
integer partition of $n$ and where $K(\kappa, \nu)$ denotes the [Kostka
number](https://en.wikipedia.org/wiki/Kostka_number) associated to two
integer partitions $\kappa$ and $\nu$.

It is also known that $$
B(p, q) = \sum_{\kappa \vdash n} K(\kappa, \lambda) K(\kappa', \mu)
$$ where $\kappa'$ denotes the [conjugate
partition](https://en.wikipedia.org/wiki/Integer_partition#Conjugate_and_self-conjugate_partitions)
(or dual partition) of the partition $\kappa$.

One also has $A(p,q) = \langle h_\lambda, h_\mu \rangle$ where
$h_\kappa$ denotes the [complete homogeneous symmetric
function](https://www.symmetricfunctions.com/standardSymmetricFunctions.htm#completeH)
associated to an integer partition $\kappa$ and
$\langle \cdot, \cdot \rangle$ denotes the [Hall inner
product](https://www.symmetricfunctions.com/schur.htm#schurInnerProduct),
and one has $B(p,q) = \langle h_\lambda, e_\mu \rangle$ where $e_\kappa$
denotes the [elementary symmetric
function](https://www.symmetricfunctions.com/standardSymmetricFunctions.htm#elementaryE)
associated to an integer partition $\kappa$.

All these results can be found in Macdonald's book *Symmetric functions
and Hall polynomials*.

Now let's turn to the implementation of $A(p,q)$ and $B(p,q)$ in R.
Enumerating the partitions of an integer is one of the features of the
[**partitions** package](https://github.com/RobinHankin/partitions) (the
`parts` function). This package also allows to get the conjugate
partition of an integer partition (the `conjugate` function). The Kostka
numbers can be obtained with the [**syt**
package](https://github.com/stla/syt) (the `KostkaNumber` function). So
we use these two packages.

``` r
library(partitions)
library(syt)

Apq <- function(p, q) {
  n <- sum(p)
  if(sum(q) != n) {
    return(0L)
  }
  lambda <- Filter(\(i) {i > 0}, sort(p, decreasing = TRUE))
  mu <- Filter(\(i) {i > 0}, sort(q, decreasing = TRUE))
  partitions <- parts(n)
  sum(apply(partitions, 2L, function(kappa) {
    KostkaNumber(kappa, lambda) * KostkaNumber(kappa, mu)
  }))
}

Bpq <- function(p, q) {
  n <- sum(p)
  if(sum(q) != n) {
    return(0L)
  }
  lambda <- Filter(\(i) {i > 0}, sort(p, decreasing = TRUE))
  mu <- Filter(\(i) {i > 0}, sort(q, decreasing = TRUE))
  muprime <- conjugate(mu)
  partitions <- parts(n)
  sum(apply(partitions, 2L, function(kappa) {
    KostkaNumber(kappa, lambda) * KostkaNumber(kappa, muprime)
  }))
}
```
