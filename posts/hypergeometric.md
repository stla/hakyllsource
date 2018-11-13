---
author: Stéphane Laurent
date: '2017-06-04'
editor_options:
  chunk_output_type: console
highlighter: kate
output:
  html_document: default
  md_document:
    preserve_yaml: True
    toc: True
    variant: markdown
prettify: True
prettifycss: 'twitter-bootstrap'
tags: 'R, special-functions'
title: |
    The binary splitting with the R `gmp` package - Application to the Gauss
    hypergeometric function
---

-   [Introductory example: Euler's approximation of
    $\pi$](#introductory-example-eulers-approximation-of-pi)
-   [Second example: exponential of a rational
    number](#second-example-exponential-of-a-rational-number)
-   [The `gmp` package comes to our
    rescue](#the-gmp-package-comes-to-our-rescue)
-   [A general function for the binary splitting
    algorithm](#a-general-function-for-the-binary-splitting-algorithm)
-   [The Gauss hypergeometric
    function](#the-gauss-hypergeometric-function)
-   [Update 2018-11-13](#update-2018-11-13)

In this article you will firstly see how to get rational numbers
arbitrary close to $\pi$ by performing the *binary splitting algorithm*
with the `gmp` package.

The *binary splitting algorithm* fastly calculates the partial sums of a
rational hypergeometric series by manipulating only integer numbers. But
these integer numbers are generally gigantic hence they cannot be
handled by ordinary arithmetic computing. After describing the binary
splitting algorithm we will show how to implement it in R with the `gmp`
package which allows *arithmetic without limitation*. Our main
application is the evaluation of the Gauss hypergeometric function.

Introductory example: Euler's approximation of $\pi$
----------------------------------------------------

The following formula is due to Euler
$$\frac{\pi}{2} = 1 + \frac{1}{3} + \frac{1\times 2}{3\times 5} + \frac{1\times 2 \times 3}{3\times 5 \times 7} + \cdots + \frac{n!}{3\times 5 \times 7 \times \cdots \times (2n+1)} + \cdots,$$
that is, $\frac{\pi}{2} = \lim S_n$ where $$\begin{aligned}
S_n & = 1 + \frac{u_1}{v_1} + \frac{u_1 u_2}{v_1v_2} +
\frac{u_1u_2 u_3}{v_1v_2v_3} + \cdots +
\frac{u_1u_2\ldots u_{n-1}u_n}{v_1v_2\ldots v_{n-1}v_n} \\
& = 1 + \sum_{k=1}^n \prod_{i=1}^k\frac{u_i}{v_i} \\
\end{aligned}$$ with $u_i=i$ and $v_i=2i+1$.

Using new notations $\alpha_i = \delta_i = u_i$ and $\beta_i=v_i$ and
then writing $$
S_n -1 =  \frac{\alpha_1}{\beta_1} + \frac{\delta_1 \alpha_2}{\beta_1\beta_2} +
\frac{\delta_1\delta_2 \alpha_3}{\beta_1\beta_2\beta_3} + \cdots +
\frac{\delta_1\delta_2\ldots\delta_{n-1}\alpha_n}{\beta_1\beta_2\ldots\beta_{n-1}\beta_n}
$$ could sound silly at first glance. But now assume $\boxed{n=2^m}$.
Then, by summing each $(2i-1)$-st term with the $(2i)$-th term, we can
write $S_n-1$ as a sum of $n/2$ terms with a similar expression: $$
S_n - 1 =  \frac{\alpha'_1}{\beta'_1} + \frac{\delta'_1 \alpha'_2}{\beta'_1\beta'_2} +
\frac{\delta'_1\delta'_2 \alpha'_3}{\beta'_1\beta'_2\beta'_3} + \cdots +
\frac{\delta'_1\delta'_2\ldots\delta'_{\frac{n}{2}-1}\alpha'_\frac{n}{2}}{\beta'_1\beta'_2\ldots\beta'_{\frac{n}{2}-1}\beta'_{\frac{n}{2}}}
$$ where $\alpha'_i$, $\delta'_i$ and $\beta'_i$ are given by $$
\begin{aligned}
\alpha'_i = \alpha_{2i-1}\beta_{2_i} + \alpha_{2i}\delta_{2i-1}, \quad
\delta'_i = \delta_{2i-1}\delta_{2i}
\qquad \text{and } \quad
\beta'_i = \beta_{2i-1}\beta_{2i}
\end{aligned}
$$ for all $i \in \{1, \ldots, n/2\}$.

Continuing so on, after $m$ steps we obtain $$
S_n - 1 = \frac{\alpha^{(m)}}{\beta^{(m)}}
$$ where $\alpha^{(m)}$ and $\beta^{(m)}$ are integer numbers obtained
by applying above formulas

The above method is the *binary splitting algorithm* for evaluating
$S_n$ with $n=2^m$, summarized as follows:

1.  Initialization: put $\alpha^{(0)}_i = \delta^{(0)}_i = u_i$ and
    $\beta^{(0)}_i=v_i$ for $i \in \{1,n\}$;

2.  Compute recursively for $k$ going from $1$ to $m$ $$
    \begin{aligned}
    \alpha^{(k)}_i = \alpha^{(k-1)}_{2i-1}\beta^{(k-1)}_{2_i} + \alpha^{(k-1)}_{2i}\delta^{(k-1)}_{2i-1}, \quad
    \delta^{(k)}_i = \delta^{(k-1)}_{2i-1}\delta^{(k-1)}_{2i}
    \qquad \text{and } \quad
    \beta^{(k)}_i = \beta^{(k-1)}_{2i-1}\beta^{(k-1)}_{2i}
    \end{aligned}
    $$ for $i \in \{1,n/2^k\}$;

3.  Evaluate $S_n = 1 + \frac{\alpha^{(m)}}{\beta^{(m)}}$.

The advantage of the binary splitting as compared to a direct evaluation
of $S_n$ by summing its $2^m$ terms is twofold:

-   the binary splitting only performs operations on integer numbers;
-   it returns an exact expression of $S_n$ as a ratio of two integer
    numbers.

``` {.r}
## example: rational approximation of pi ##
bs.pi <- function(m){
  u <- function(i) as.numeric(i)
  v <- function(i) 2*i+1
  n <- 2^m
  indexes <- c(1:n)
  delta <- alpha <- u(indexes)
  beta <- v(indexes)
  j <- 1; l <- n
  while(j<n){
    l <- l/2
    odd <- 2*c(1:l); even <- odd-1
    alpha <- beta[odd]*alpha[even] + delta[even]*alpha[odd]
    j <- 2*j
    beta <- beta[odd]*beta[even]
    delta <- delta[even]*delta[odd]
  }
  Sn <- alpha/beta + 1
  out <- list(alpha=alpha, beta=beta, Sn=Sn)
  return(out)
}
```

The method very well performs while $m\leq 7$ :

``` {.r}
print(bs.pi(7),digits=22)
```

    ## $alpha
    ## [1] 9.589805429639700552285e+254
    ## 
    ## $beta
    ## [1] 1.680074832206408008727e+255
    ## 
    ## $Sn
    ## [1] 1.570796326794896557999

``` {.r}
print(pi/2,digits=22)
```

    ## [1] 1.570796326794896557999

But the numerator and the denominator become too gigantic when $m=8$:

``` {.r}
bs.pi(8)
```

    ## $alpha
    ## [1] Inf
    ## 
    ## $beta
    ## [1] Inf
    ## 
    ## $Sn
    ## [1] NaN

Second example: exponential of a rational number
------------------------------------------------

It is well known that $\exp(x)=\lim S_n(x)$ where
$S_n(x)=\sum_{k=0}^n\frac{x^n}{n!}$. Thus, when $x=p/q$ for some
integers $p$ and $q$, we can write as before $$
S_n(x) = 1 + \sum_{k=1}^n \prod_{i=1}^k\frac{u_i}{v_i}
$$ where $u_i \equiv p$ and $v_i= i q$ are integer numbers. Thus, we can
use the binary splitting algorithm to compute $S_{2^m}$:

``` {.r}
## example: rational approximation of exp(p/q) ##
bs.exp <- function(p,q,m){
  v <- function(i) i*q
  n <- 2^m
  indexes <- 1:n
  delta <- alpha <- rep(p,n)
  beta <- v(indexes)
  j <- 1; l <- n
  while(j<n){
    l <- l/2
    odd <- 2*c(1:l); even <- odd-1
    alpha <- beta[odd]*alpha[even] + delta[even]*alpha[odd]
    j <- 2*j
    beta <- beta[odd]*beta[even]
    delta <- delta[even]*delta[odd]
  }
  Sn <- alpha/beta + 1
  out <- list(alpha=alpha, beta=beta, Sn=Sn)
  return(out)
}
```

Let us try to evaluate $\exp(1)$. For $m=7$, the approximation is not
entirely satisfactory:

``` {.r}
print(bs.exp(1,1,7), digits=22)
```

    ## $alpha
    ## [1] 6.626046675252336548016e+215
    ## 
    ## $beta
    ## [1] 3.856204823625804071551e+215
    ## 
    ## $Sn
    ## [1] 2.718281828459045534885

``` {.r}
print(exp(1), digits=22)
```

    ## [1] 2.718281828459045090796

And for $m=8$, it crashes:

``` {.r}
bs.exp(1,1,8)
```

    ## $alpha
    ## [1] Inf
    ## 
    ## $beta
    ## [1] Inf
    ## 
    ## $Sn
    ## [1] NaN

The `gmp` package comes to our rescue
-------------------------------------

As we noted above, the binary splitting manipulates only *integer*
numbers. The evaluation of $\exp(1)$ has crashed because the numerator
and the denominator were too big integers. The crantastic
[`gmp`](http://www.inside-r.org/packages/cran/gmp) package overcomes
this problem because it allows arithmetic without limitations using the
[C library GMP (GNU Multiple Precision Arithmetic)](http://gmplib.org/).

Let us show how the `gmp` works on the $\pi$ example. This is very easy:
we only have to convert the two input sequences of integers $(u_i)$ and
$(v_i)$ to sequences of `bigz` integers:

``` {.r}
library(gmp)
## rational approximation of pi with gmp ##
bs.pi.gmp <- function(m){
  u <- function(i) as.numeric(i)
  v <- function(i) 2*i+1
  n <- 2^m
  indexes <- 1:n
  delta <- alpha <- as.bigz(u(indexes))
  beta <- as.bigz(v(indexes))
  j <- 1; l <- n
  while(j<n){
    l <- l/2
    odd <- 2*c(1:l); even <- odd-1
    alpha <- beta[odd]*alpha[even] + delta[even]*alpha[odd]
    j <- 2*j
    beta <- beta[odd]*beta[even]
    delta <- delta[even]*delta[odd]
  }
  Sn <- alpha/beta + 1
  out <- list(Sn=Sn, eval.Sn=format(as.numeric(Sn),digits=22))
  return(out)
}
```

The evaluation of $S_n$ with $n=2^3$ illustrates the first advantage of
the `gmp` package:

``` {.r}
bs.pi.gmp(3)
```

    ## $Sn
    ## Big Rational ('bigq') :
    ## [1] 1202048/765765
    ## 
    ## $eval.Sn
    ## [1] "1.569734840323075530932"

``` {.r}
bs.pi(3)
```

    ## $alpha
    ## [1] 19632735
    ## 
    ## $beta
    ## [1] 34459425
    ## 
    ## $Sn
    ## [1] 1.569735

As you can see, $S_n$ is written as an irreducible fraction with the
`gmp` approach. But this is not the main strength of the `gmp` package.
Now we have (almost) no limitation on $m$ for evaluating $S_{2^m}$:

``` {.r}
bs.pi.gmp(8)
```

    ## $Sn
    ## Big Rational ('bigq') :
    ## [1] 115056663317199981372832786803399641133848259535718238578854114440177847232763528127119686643465544336537363974090559640151844992619459739337642897335661405374200830442503779326745081494631228217510085926896107230240702464/73247346810369298651903071099557979072216039642432949710389234675732768750102001285974817825809831148661290123993641325086924401900965008305646606428886048721946203288377842830920059623434101646117412656625454480462852875
    ## 
    ## $eval.Sn
    ## [1] "1.570796326794896557999"

Obviously the first limitation is the width of your screen. The more
serious limitations of the `gmp` package are beyond the scope of this
article.

Let us come back to the exponential example:

``` {.r}
## rational approximation of exp(p/q) with gmp ##
bs.exp.gmp <- function(p,q,m){
  v <- function(i) i*q
  n <- 2^m
  indexes <- 1:n
  delta <- alpha <- as.bigz(rep(p,n))
  beta <- as.bigz(v(indexes))
  j <- 1; l <- n
  while(j<n){
    l <- l/2
    odd <- 2*c(1:l); even <- odd-1
    alpha <- beta[odd]*alpha[even] + delta[even]*alpha[odd]
    j <- 2*j
    beta <- beta[odd]*beta[even]
    delta <- delta[even]*delta[odd]
  }
  Sn <- alpha/beta + 1
  out <- list(Sn=Sn, eval.Sn=format(as.numeric(Sn),digits=22))
  return(out)
}
```

``` {.r}
bs.exp.gmp(1,1,8)
```

    ## $Sn
    ## Big Rational ('bigq') :
    ## [1] 63021364076854400517126597190157042974914655085470311494152999074896589361987361775329179623527760806690590676400388872831695705790559736341994225392293021235691155101792729596391087505487119686065032680426816409018591609682896947897581062232056198801713371950662092427153111247485380584396839593243205795931189046725531379112787311119506517584752693953099433873873085939642331053890371322719954788883613838912023544946108979472116077229049863887551154910123100635718060217444974605564852221865532212127661/23184264198455206868083304640033314193453554602148259996206909469655931150085069983174061928660848877037186090333421197463708022559289093927629440229660162856206414393604561795747978584507961086161320755987057927235191284503958147694842900705427915576370346458939828967066328925689811313743116731571304256245141968042147553432082017992236165926654195533967789698937870367867112218743295876678624370999142239502871990876622238944437605633097728000000000000000000000000000000000000000000000000000000000000000
    ## 
    ## $eval.Sn
    ## [1] "2.718281828459045090796"

Very well.

A general function for the binary splitting algorithm
-----------------------------------------------------

Before turning to the Gauss hypergeometric function we write a general
function for the binary splitting taking as arguments the two sequences
$(u_i)$ and $(v_i)$:

``` {.r}
bs.gmp <- function(u,v,m=7,value="eval"){
  n <- 2^m
  indexes <- 1:n
  delta <- alpha <- as.bigz(u(indexes))
  beta <- as.bigz(v(indexes))
  j <- 1; l <- n
  while(j<n){
    l <- l/2
    odd <- 2*c(1:l); even <- odd-1
    alpha <- beta[odd]*alpha[even] + delta[even]*alpha[odd]
    j <- 2*j
    beta <- beta[odd]*beta[even]
    delta <- delta[even]*delta[odd]
  }
  Sn <- alpha/beta + 1
  eval.Sn <- format(as.numeric(Sn) ,digits=22)
  out <- switch(value, 
                "eval"=eval.Sn, 
                "exact"=Sn, 
                "both"=list(Sn=Sn, eval.Sn=eval.Sn))
  return(out)
}
```

The Gauss hypergeometric function
---------------------------------

Now consider the *Gauss hypergeometric function* ${}_2\!F_1$. This is
the function ${}_2\!F_1(\alpha,\beta,\gamma; \cdot)$\
with complex parameters $\alpha$, $\beta$, $\gamma \not\in \mathbb{Z}^-$
and complex variable $z$ defined for $|z|<1$ as the sum of an absolute
convergent series
$${}_2\!F_1(\alpha,\beta,\gamma; z) = \sum_{n=0}^{\infty}\frac{ {(\alpha)}_{n}{(\beta)}_n}{ {(\gamma)}_{n}}\frac{z^n}{n!},$$
and extended by analytical continuation in the complex plane with the
cut along $(1,+\infty)$. Here ${(a)}_n:=a(a+1)\cdots(a+n-1)$ denotes the
Pochhammer symbol used to represent the $n$-th ascending factorial of
$a$.

The binary splitting allows to evaluate
${}_2\!F_1(\alpha,\beta,\gamma; z)$ for rational values of
$\alpha,\beta,\gamma, z$ by manipulating only integer numbers. This is
performed by the R function below

``` {.r}
## rational approximation of  2F1(a1/a2, b1/b2, c1/c2; p/q) with gmp ##
hypergeo_bs <- function(a1,a2, b1,b2, c1,c2, p,q, m){
  u <- function(i) c2*(a1+(i-1)*a2)*(b1+(i-1)*b2)*p
  v <- function(i) a2*b2*i*(c1+(i-1)*c2)*q
  bs.gmp(u,v,m)
}
```

For more convenience I have firstly written the function below which
returns the irreducible rational notation of a given number $x$. The
user can also specify a rounding order for $x$.

``` {.r}
n.decimals <- function(x, tol=.Machine$double.eps){
  sapply(x, function(x) {
        i <- 0
        while(abs(x-round(x,i))>tol){i <- i+1}
    return(i)
    })
}
irred.frac <- function(x, rnd=n.decimals(x)){
  b <- 10^rnd
  a <- as.bigz(b*round(x,rnd))
  num <- a/gcd.bigz(a,b)
  den <- b/gcd.bigz(a,b)
  return(list(num=num, den=den))
}
```

For example:

``` {.r}
irred.frac(pi)
```

    ## $num
    ## Big Rational ('bigq') :
    ## [1] 3141592653589793
    ## 
    ## $den
    ## Big Rational ('bigq') :
    ## [1] 1000000000000000

``` {.r}
irred.frac(pi, rnd=7)
```

    ## $num
    ## Big Rational ('bigq') :
    ## [1] 31415927
    ## 
    ## $den
    ## Big Rational ('bigq') :
    ## [1] 10000000

Finally, here is a user-friendly function for evaluating ${}_2\!F_1$
with the binary splitting:

``` {.r}
Hypergeometric2F1 <- function(a, b, c, z, m=7,
                              rnd.params=max(n.decimals(c(a,b,c))), 
                              rnd.z=n.decimals(z),
                              check.cv=FALSE){
  frac.a <- irred.frac(a,rnd.params)
  frac.b <- irred.frac(b,rnd.params)
  frac.c <- irred.frac(c,rnd.params)
  a1 <- frac.a$num; a2 <- frac.a$den
  b1 <- frac.b$num; b2 <- frac.b$den
  c1 <- frac.c$num; c2 <- frac.c$den
  frac.z <- irred.frac(z,rnd.z)
  p <- frac.z$num; q <- frac.z$den
  out <- hypergeo_bs(a1,a2, b1,b2, c1,c2, p,q, m)
  if(check.cv){
    x <- hypergeo_bs(a1,a2, b1,b2, c1,c2, p,q, m+1)
    cv <- x==out
    out <- list(result=out, convergence=cv)
    if(!cv){
      out$convergence <- paste(out$convergence, " - m=", m, " need to be increased", sep="")
    }
  }
  return(out)
}
```

For example:

``` {.r}
a <- 20.5; b <- 11.92; c <- 19
z <- 0.5
Hypergeometric2F1(a,b,c,z)
```

    ## [1] "8057.994139606238604756"

``` {.r}
Hypergeometric2F1(a,b,c,z, m=3, check.cv=TRUE)
```

    ## $result
    ## [1] "1522.06880440136683319"
    ## 
    ## $convergence
    ## [1] "FALSE - m=3 need to be increased"

``` {.r}
Hypergeometric2F1(a,b,c,z, m=7, check.cv=TRUE)
```

    ## $result
    ## [1] "8057.994139606238604756"
    ## 
    ## $convergence
    ## [1] TRUE

Note that Robin Hankin's `gsl` package does an excellent job:

``` {.r}
library(gsl)
hyperg_2F1(a,b,c,z)
```

    ## [1] 8057.994

Update 2018-11-13
=================

-   Converting a `bigq` rational number to a decimal number with
    `as.numeric` is not a good idea. It is better to use the `mpfr`
    function of the `Rmpfr` package, or the `q2d` function of the
    package `rcdd`:

``` {.r}
halfpi_bigq <- bs.pi.gmp(8)$Sn
library(Rmpfr)
mpfr(halfpi_bigq, 128)
```

    ## 1 'mpfr' number of precision  128   bits 
    ## [1] 1.5707963267948966192313216916397514421

``` {.r}
library(rcdd)
q2d(as.character(halfpi_bigq))
```

    ## [1] 1.570796

-   My function `irred.frac` is not good. To convert a decimal number to
    a `bigq` rational number, it is better to use the `d2q` function of
    the `rcdd` package:

``` {.r}
as.bigq(d2q(pi))
```

    ## Big Rational ('bigq') :
    ## [1] 884279719003555/281474976710656
