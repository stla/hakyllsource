---
author: Stéphane Laurent
date: '2019-07-15'
highlighter: 'pandoc-solarized'
linenums: True
output:
  html_document:
    highlight: kate
    keep_md: False
  md_document:
    preserve_yaml: True
    variant: markdown
prettify: True
prettifycss: minimal
tags: 'maths, statistics, R'
title: 'Adjusted Dunnett p-values'
---

Consider the ANOVA statistical model $$
y_{ij} = \gamma + \mu_i + \sigma\epsilon_{ij}, \quad 
i = 0, 1, \ldots, m, \quad j = 1, \ldots, n_i
$$ where $\epsilon_{ij} \sim_{\textrm{iid}} \mathcal{N}(0,1)$.

The number $\gamma$ is the overall mean and $\mu_i$ is the effect in
group $i$. Group $0$ is considered to be a control group, and we are
interested in the $m$ hypotheses $$
H_{0i} = \{\mu_0 = \mu_i\} \quad \textit{vs} \quad H_{1i} = \{\mu_0 > \mu_i\}.
$$ Let $H_0 = \bigcap_{i=1}^m H_{0i} = \{\mu_0=\mu_1=\cdots = \mu_m\}$.

Consider the $m$ mean differences $$
\bar{y_i} - \bar{y_0} = 
(\mu_i - \mu_0) + \sigma(\bar{\epsilon_i}-\bar{\epsilon_0})
$$ for $i = 1, \ldots, m$.

Hereafter we assume the null hypothesis $H_0$ is fulfilled, therefore
$\bar{y_i} - \bar{y_0} = \sigma(\bar{\epsilon_i}-\bar{\epsilon_0})$.

We will derive the covariances between the standardized mean
differences. Let's start by deriving the covariances between the
$\bar{\epsilon_i}-\bar{\epsilon_0}$.

The $\bar{\epsilon_i}$ for $i = 0, 1, \ldots, m$ are independent and
$\bar{\epsilon_i} \sim \mathcal{N}\left(0, \frac{1}{n_i}\right)$.
Consequently, for $i = 1, \ldots, m$,\
$$
\bar{\epsilon_i}-\bar{\epsilon_0} \sim 
\mathcal{N}\left(0, \frac{1}{n_i} + \frac{1}{n_0}\right).
$$ Now, let's derive the covariance between the
$\bar{\epsilon_i}-\bar{\epsilon_0}$. One has $$
\begin{align*}
\textrm{Cov}(\bar{\epsilon_i}-\bar{\epsilon_0}, \bar{\epsilon_j}-\bar{\epsilon_0}) 
& = 
E\bigl((\bar{\epsilon_i}-\bar{\epsilon_0})(\bar{\epsilon_j}-\bar{\epsilon_0})\bigr)
\\ & =
E(\bar{\epsilon_i}\bar{\epsilon_j}) + E(\bar{\epsilon_0}\bar{\epsilon_0}) 
- E(\bar{\epsilon_i}\bar{\epsilon_0}) - E(\bar{\epsilon_j}\bar{\epsilon_0}).
\end{align*}
$$ For $i\neq j$, each term is equal to $0$ except the second one: $$
E(\bar{\epsilon_0}\bar{\epsilon_0}) = \frac{1}{n_0}.
$$ Thus $$
\textrm{Cov}(\bar{\epsilon_i}-\bar{\epsilon_0}, \bar{\epsilon_j}-\bar{\epsilon_0}) 
= \frac{1}{n_0}
$$ for every $i,j \in \{1, \ldots, m\}$, when $i \neq j$.

Now, let's introduce the standardized mean differences $$
\delta_i = 
\frac{\bar{y_i} - \bar{y_0}}{\sigma\sqrt{\frac{1}{n_i} + \frac{1}{n_0}}} 
\sim \mathcal{N}(0,1)
$$ for $i = 1, \ldots, m$. For $i \neq j$, the covariances are $$
\begin{align*}
\textrm{Cov}(\delta_i, \delta_j) & = 
\frac{1}{n_0}\frac{1}{\sqrt{\frac{1}{n_i} + \frac{1}{n_0}}}
\frac{1}{\sqrt{\frac{1}{n_j} + \frac{1}{n_0}}} \\
& = \frac{1}{n_0}\sqrt{\frac{n_0n_i}{n_i+n_0}}
\sqrt{\frac{n_0n_j}{n_j+n_0}} \\
& = \sqrt{\frac{n_i}{n_i+n_0}}\sqrt{\frac{n_j}{n_j+n_0}}.
\end{align*}
$$

Now let's introduce the statistics $$
t_i = \frac{\bar{y_i} - \bar{y_0}}{\hat\sigma\sqrt{\frac{1}{n_i} + \frac{1}{n_0}}} 
= \frac{1}{u}\frac{\bar{y_i} - \bar{y_0}}{\sigma\sqrt{\frac{1}{n_i} + \frac{1}{n_0}}}
$$ where $$
\hat\sigma^2 = \frac{\sum_{i=0}^m\sum_{j=1}^{n_i}{(y_{ij}-\bar{y}_i)^2}}{\nu}
$$ with $\nu = \sum_{i=0}^m n_i - (m+1)$, and where we have set
$u = \frac{\hat\sigma}{\sigma}$.

It is known that $$
\nu u^2 = \nu\frac{{\hat{\sigma}}^2}{\sigma^2} \sim \chi^2_\nu.
$$

Denote by $\mathbf{t}$ the vector ${(t_1, \ldots, t_m)}'$. By the above,
one has $$
(\mathbf{t} \mid u) \sim 
\mathcal{M}\mathcal{N}(\mathbf{0}, \Sigma/u^2)
$$ where $$
\Sigma_{ij} = \begin{cases}
1 & \text{if } i = j \\
\sqrt{\frac{n_i}{n_i+n_0}}\sqrt{\frac{n_j}{n_j+n_0}} & \text{if } i \neq j
\end{cases}.
$$

Therefore, $\mathbf{t}$ follows the multivariate Student distribution
with $\nu$ degrees of freedom and scale matrix $\Sigma$ (see the paper
*A short review of multivariate $t$-distribution* by Kibria & Joarder).

-   The *adjusted Dunnett $p$-value* for $H_{0i}$ *vs* the "less"
    alternative hypothesis $H_{1i}$ is $$
    p_i = \Pr\left(\min_{i \in\{1, \ldots m\}}t_i < t_i^{\text{obs}}\right)
    $$

where $\Pr$ is the probability under $H_0$. One has $$
\begin{align*}
\Pr\left(\min_{i \in\{1, \ldots m\}}t_i < q\right) & = 
\Pr\left(-\min_{i \in\{1, \ldots m\}}t_i > -q\right) \\ 
& = \Pr\left(\max_{i \in\{1, \ldots m\}}-t_i > -q\right) \\
& = \Pr\left(\max_{i \in\{1, \ldots m\}}t_i > -q\right),
\end{align*}
$$ the last equality stemming from the symmetry of the (centered)
multivariate Student distribution.

Let's write a R function computing
$\Pr\left(\max_{i \in\{1, \ldots m\}}t_i \leq q \right)$.

``` {.r}
pDunnett <- function(q, n0, ni){
  if(q==Inf){
    return(1)
  }
  if(q==-Inf){
    return(0)
  }
  m <- length(ni) 
  Sigma <- matrix(NA_real_, nrow=m, ncol=m)
  for(i in 1:(m-1)){
    for(j in (i+1):m){
      Sigma[i,j] <- sqrt(ni[i]*ni[j]/(n0+ni[i])/(n0+ni[j]))
    }
  }
  Sigma[lower.tri(Sigma)] <- Sigma[upper.tri(Sigma)]
  diag(Sigma) <- 1
  nu <- n0 + sum(ni) - m - 1
  mnormt::pmt(rep(q,m), mean=rep(0,m), S=Sigma, df=nu, maxpts=2000*m)
}
```

Now let's try an example.

``` {.r}
data("recovery", package = "multcomp")
recovery
##    blanket minutes
## 1       b0      15
## 2       b0      13
## 3       b0      12
## 4       b0      16
## 5       b0      16
## 6       b0      17
## 7       b0      13
## 8       b0      13
## 9       b0      16
## 10      b0      17
## 11      b0      17
## 12      b0      19
## 13      b0      17
## 14      b0      15
## 15      b0      13
## 16      b0      12
## 17      b0      16
## 18      b0      10
## 19      b0      17
## 20      b0      12
## 21      b1      13
## 22      b1      16
## 23      b1       9
## 24      b2       5
## 25      b2       8
## 26      b2       9
## 27      b3      14
## 28      b3      16
## 29      b3      16
## 30      b3      12
## 31      b3       7
## 32      b3      12
## 33      b3      13
## 34      b3      13
## 35      b3       9
## 36      b3      16
## 37      b3      13
## 38      b3      18
## 39      b3      13
## 40      b3      12
## 41      b3      13
# samples
ys <- lapply(split(recovery, recovery$blanket), function(df){
  df$minutes
})
# sample sizes
sizes <- lengths(ys)
ni <- sizes[-1]
# degrees of freedom
nu <- sum(sizes) - length(ni) - 1
# pooled variance estimate
s2 <- sum(sapply(ys, function(y){
  sum((y - mean(y))^2)
})) / nu
# Student statistics
n0 <- sizes[1]
y0bar <- mean(ys[[1]])
yi <- ys[-1]
ti <- sapply(yi, function(y){
  (mean(y) - y0bar) / sqrt(1/length(y)+1/n0) / sqrt(s2)
})
# adjusted p-values
sapply(ti, function(t) 1 - pDunnett(q = -t, n0, ni))
##        b1.b0        b2.b0        b3.b0 
## 0.2411790515 0.0000585819 0.0924376838
```

Let's compare with the `multcomp` package:

``` {.r}
fit <- lm(minutes ~ blanket, data = recovery)
library(multcomp)
multcomps <- glht(fit, linfct = mcp(blanket = "Dunnett"), 
                  alternative = "less")
summary(multcomps)
## 
##   Simultaneous Tests for General Linear Hypotheses
## 
## Multiple Comparisons of Means: Dunnett Contrasts
## 
## 
## Fit: lm(formula = minutes ~ blanket, data = recovery)
## 
## Linear Hypotheses:
##              Estimate Std. Error t value Pr(<t)    
## b1 - b0 >= 0  -2.1333     1.6038  -1.330 0.2411    
## b2 - b0 >= 0  -7.4667     1.6038  -4.656 <0.001 ***
## b3 - b0 >= 0  -1.6667     0.8848  -1.884 0.0924 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## (Adjusted p values reported -- single-step method)
```

-   The *adjusted Dunnett $p$-value* for $H_{0i}$ *vs* the "greater"
    alternative hypothesis $\{\mu_0 < \mu_i\}$ is $$
    p_i = \Pr\left(\max_{i \in\{1, \ldots m\}}t_i > t_i^{\text{obs}}\right).
    $$

Let's compare with `glht`:

``` {.r}
sapply(ti, function(t) 1 - pDunnett(q = t, n0, ni))
##     b1.b0     b2.b0     b3.b0 
## 0.9958029 1.0000000 0.9995174
multcomps <- glht(fit, linfct = mcp(blanket = "Dunnett"), 
                  alternative = "greater")
summary(multcomps)
## 
##   Simultaneous Tests for General Linear Hypotheses
## 
## Multiple Comparisons of Means: Dunnett Contrasts
## 
## 
## Fit: lm(formula = minutes ~ blanket, data = recovery)
## 
## Linear Hypotheses:
##              Estimate Std. Error t value Pr(>t)
## b1 - b0 <= 0  -2.1333     1.6038  -1.330  0.996
## b2 - b0 <= 0  -7.4667     1.6038  -4.656  1.000
## b3 - b0 <= 0  -1.6667     0.8848  -1.884  1.000
## (Adjusted p values reported -- single-step method)
```

-   The *adjusted Dunnett $p$-value* for $H_{0i}$ *vs* the "two-sided"
    alternative hypothesis $\{\mu_0 \neq \mu_i\}$ is $$
    p_i = \Pr\left(\max_{i \in\{1, \ldots m\}}|t_i| > |t_i^{\text{obs}}|\right).
    $$

Let's write a R function computing
$\Pr\left(\max_{i \in\{1, \ldots m\}}|t_i| \leq q\right)$:

``` {.r}
pDunnett2 <- function(q, n0, ni){
  if(q == Inf){
    return(1)
  }
  if(q <= 0){
    return(0)
  }
  m <- length(ni) 
  Sigma <- matrix(NA_real_, nrow=m, ncol=m)
  for(i in 1:(m-1)){
    for(j in (i+1):m){
      Sigma[i,j] <- sqrt(ni[i]*ni[j]/(n0+ni[i])/(n0+ni[j]))
    }
  }
  Sigma[lower.tri(Sigma)] <- Sigma[upper.tri(Sigma)]
  diag(Sigma) <- 1
  nu <- n0 + sum(ni) - m - 1
  mnormt::sadmvt(lower=rep(-q,m), upper = rep(q,m), mean=rep(0,m), 
                 S=Sigma, df=nu, maxpts=2000*m)
}
```

Again, we get the same results as the ones of `glht`:

``` {.r}
sapply(ti, function(t) 1 - pDunnett2(q = abs(t), n0, ni))
##        b1.b0        b2.b0        b3.b0 
## 0.4559168545 0.0001198394 0.1819800049
multcomps <- glht(fit, linfct = mcp(blanket = "Dunnett"), 
                  alternative = "two.sided")
summary(multcomps)
## 
##   Simultaneous Tests for General Linear Hypotheses
## 
## Multiple Comparisons of Means: Dunnett Contrasts
## 
## 
## Fit: lm(formula = minutes ~ blanket, data = recovery)
## 
## Linear Hypotheses:
##              Estimate Std. Error t value Pr(>|t|)    
## b1 - b0 == 0  -2.1333     1.6038  -1.330 0.455909    
## b2 - b0 == 0  -7.4667     1.6038  -4.656 0.000124 ***
## b3 - b0 == 0  -1.6667     0.8848  -1.884 0.181886    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## (Adjusted p values reported -- single-step method)
```

One also gets these results with `DescTools::DunnettTest`:

``` {.r}
library(DescTools)
DunnettTest(minutes ~ blanket, data = recovery)
## 
##   Dunnett's test for comparing several treatments with a control :  
##     95% family-wise confidence level
## 
## $b0
##            diff     lwr.ci     upr.ci    pval    
## b1-b0 -2.133333  -6.126872  1.8602056 0.45594    
## b2-b0 -7.466667 -11.460206 -3.4731277 0.00012 ***
## b3-b0 -1.666667  -3.869811  0.5364781 0.18192    
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

-   The *adjusted confidence interval* of $\mu_i - \mu_0$ at the
    $(1-\alpha)$-level is $$
    (\bar{y_i} - \bar{y_0}) \pm 
    q_{1-\frac{\alpha}{2}}\times\frac{\hat\sigma}{\sqrt{\frac{1}{n_i}+\frac{1}{n_0}}}
    $$

where $q_p$ is the equicoordinate $p$-quantile of $\mathbf{t}$: $$
\Pr(t_1 \leq q_p, \ldots, t_m \leq q_p) = p.
$$ Let's use R to compute the family-wise $95\%$-confidence intervals:

``` {.r}
m <- length(ni) 
Sigma <- matrix(NA_real_, nrow=m, ncol=m)
for(i in 1:(m-1)){
  for(j in (i+1):m){
    Sigma[i,j] <- sqrt(ni[i]*ni[j]/(n0+ni[i])/(n0+ni[j]))
  }
}
Sigma[lower.tri(Sigma)] <- Sigma[upper.tri(Sigma)]
diag(Sigma) <- 1
# mean differences
meandiffs <- sapply(yi, mean) - y0bar
# standard errors
stderrs <- sqrt(s2) * sqrt(1/ni + 1/n0)
# quantile
q <- mvtnorm::qmvt((1 - (1 - 0.95)/2), df = nu, 
                   sigma = Sigma, tail = "lower.tail")$quantile
# lower bounds
meandiffs - q * stderrs 
##         b1         b2         b3 
##  -6.126240 -11.459573  -3.869463
# upper bounds
meandiffs + q * stderrs 
##         b1         b2         b3 
##  1.8595735 -3.4737599  0.5361293
```
