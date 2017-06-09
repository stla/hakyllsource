---
author: Stéphane Laurent
date: '2017-06-01'
highlighter: hscolour
output:
  html_document: default
  md_document:
    variant: markdown
prettify: True
title: The `owen` library for Haskell
---

The `owen` library is available [on
Github](https://github.com/stla/owen). The functions it provides are
described and illustrated in this post.

Owen $T$-function
-----------------

The Owen $T$-function is defined by $$
T(h,a) = \frac{1}{2\pi}\int_0^a \frac{e^{-\frac12 h^2(1+x^2)}}{1+x^2}\mathrm{d}x
$$ for $a, h \in \mathbb{R}$. It corresponds to a certain probability
and then its value always lies between $0$ and $1$.

Below we compare some obtained values of $T(h, a)$ to the ones given by
Wolfram up to $20$ digits:

<div class="sourceCode">

<pre class='scriptHaskell'><code class='scriptHaskell'><span class='prompt'>></span> <span class='hs-keyword'>import</span> <span class='hs-conid'>OwenT</span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-num'>0.1</span> <span class='hs-num'>0.1</span>   <span class='hs-varop'>-</span> <span class='hs-num'>0.01578338051718359918</span>
<span class='output'>3.469446951953614e-18</span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-num'>1</span> <span class='hs-num'>0.5</span>     <span class='hs-varop'>-</span> <span class='hs-num'>0.04306469112078536563</span>
<span class='output'>6.938893903907228e-18</span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-num'>0.5</span> <span class='hs-num'>0.1</span>   <span class='hs-varop'>-</span> <span class='hs-num'>0.01399302023628015424</span>
<span class='output'>1.734723475976807e-18</span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-num'>0.5</span> <span class='hs-num'>0.9</span>   <span class='hs-varop'>-</span> <span class='hs-num'>0.10007270175061385845</span>
<span class='output'>0.0</span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-num'>5</span> <span class='hs-num'>0.5</span>     <span class='hs-varop'>-</span> <span class='hs-num'>0.00000014192549621069</span>
<span class='output'>-2.6903883987164715e-18</span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-num'>2</span> <span class='hs-num'>0.99999</span> <span class='hs-varop'>-</span> <span class='hs-num'>0.01111626714677311317</span>
<span class='output'>-4.683753385137379e-17</span>
</code></pre>

</div>

<br/>

The `owenT` function allows infinite values of $h$ and $a$:

<div class="sourceCode">

<pre class='scriptHaskell'><code class='scriptHaskell'><span class='prompt'>></span> <span class='hs-keyword'>import</span> <span class='hs-conid'>OwenT</span>
<span class='prompt'>></span> <span class='hs-keyword'>import</span> <span class='hs-conid'>Data</span><span class='hs-varop'>.</span><span class='hs-conid'>Number</span><span class='hs-varop'>.</span><span class='hs-conid'>Erf</span> 
<span class='prompt'>></span> <span class='hs-comment'>-- zero: </span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-layout'>(</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span> <span class='hs-num'>3</span>
<span class='output'>0.0</span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-layout'>(</span><span class='hs-varop'>-</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span> <span class='hs-num'>3</span>
<span class='output'>0.0</span>
<span class='prompt'>></span> <span class='hs-comment'>-- equality:</span>
<span class='prompt'>></span> <span class='hs-definition'>owenT</span> <span class='hs-num'>1</span> <span class='hs-layout'>(</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span>
<span class='output'>7.932762696572854e-2</span>
<span class='prompt'>></span> <span class='hs-layout'>(</span><span class='hs-num'>1</span> <span class='hs-varop'>-</span> <span class='hs-varid'>normcdf</span> <span class='hs-num'>1</span><span class='hs-layout'>)</span><span class='hs-varop'>/</span><span class='hs-num'>2</span>
<span class='output'>7.932762696572854e-2</span>
</code></pre>

</div>

<br/>

The algorithm runs as follows. If $0 \leq a \leq 1$, and
$0 \leq h \leq 8$, a series expansion is used, the one given by Owen
(1956). The series is truncated after the $50$-th term. If
$0\leq a \leq 1$, and $h \geq 8$, an asymptotic approximation is used.
Otherwise, the properties of the Owen $T$-function are exploited to come
down to the case $0 \leq a \leq 1$. The main property involves the
Gaussian cumulative function.

As shown by Owen (1956), the Owen $T$-function can be used to evaluate
the cumulative distribution function of the bivariate Gaussian
distribution.

Non-central Student distribution
--------------------------------

The `pStudent` function of the `owen` library evaluates the cumulative
distribution function of the non-central Student distribution with an
*integer* number of degrees of freedom. For odd values, the algorithm
resorts to the Owen $T$-function. This algorithm is the one given by
Owen (1965).

Below we compare some values to the ones given by R:

<div class="sourceCode">

<pre class='scriptHaskell'><code class='scriptHaskell'><span class='prompt'>></span> <span class='hs-keyword'>import</span> <span class='hs-conid'>Student</span>
<span class='prompt'>></span> <span class='hs-definition'>pStudent</span> <span class='hs-num'>0.5</span> <span class='hs-num'>2</span> <span class='hs-num'>2.5</span> <span class='hs-varop'>-</span> <span class='hs-num'>0.022741814853305026</span>
<span class='output'>6.259229246019515e-14</span>
<span class='prompt'>></span> <span class='hs-definition'>pStudent</span> <span class='hs-num'>0.5</span> <span class='hs-num'>3</span> <span class='hs-num'>2.5</span> <span class='hs-varop'>-</span> <span class='hs-num'>0.022741355255468675</span>
<span class='output'>1.8677767665842282e-13</span>
</code></pre>

</div>

Owen Q-function
---------------

The first Owen $Q$-function is defined by $$
Q_1(\nu, t, \delta, R) = \frac{1}{\Gamma\left(\frac{\nu}{2}\right)2^{\frac12(\nu-2)}}
\int_0^R \Phi\left(\frac{tx}{\sqrt{\nu}}-\delta\right)
x^{\nu-1} e^{-\frac{x^2}{2}} \mathrm{d}x
$$ for $\nu >0$, $t, \delta \in \mathbb{R}$ and $R>0$.

Its value always lies between $0$ and $1$.

It is implemented in the `owen` library for *integer* values of $\nu$,
under the name `owenQ1`. The algorithm used is the one given by Owen
(1965).

The results are theoretically exact for even values of $\nu$, up to the
fact that the function resorts to the Gaussian cumulative function. For
odd values of $\nu$, it also resorts to the Owen $T$-function.

Below we compare some obtained values of $Q_1(\nu, t, \delta, R)$ to the
ones given by Wolfram up to $20$ digits:

<div class="sourceCode">

<pre class='scriptHaskell'><code class='scriptHaskell'><span class='prompt'>></span> <span class='hs-keyword'>import</span> <span class='hs-conid'>OwenQ</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>1</span> <span class='hs-num'>3</span> <span class='hs-num'>2</span> <span class='hs-num'>5</span>  <span class='hs-varop'>-</span> <span class='hs-num'>0.52485658843054409291</span>
<span class='output'>2.220446049250313e-16</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>2</span> <span class='hs-num'>3</span> <span class='hs-num'>2</span> <span class='hs-num'>5</span>  <span class='hs-varop'>-</span> <span class='hs-num'>0.62938193306526904118</span>
<span class='output'>-1.1102230246251565e-16</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>9</span> <span class='hs-num'>3</span> <span class='hs-num'>2</span> <span class='hs-num'>5</span>  <span class='hs-varop'>-</span> <span class='hs-num'>0.77030437685878389173</span>
<span class='output'>-1.1102230246251565e-16</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>10</span> <span class='hs-num'>3</span> <span class='hs-num'>2</span> <span class='hs-num'>5</span> <span class='hs-varop'>-</span> <span class='hs-num'>0.77383547873740988537</span>
<span class='output'>1.1102230246251565e-16</span>
</code></pre>

</div>

<br/>

The `owenQ1` function also returns a value for $t,\delta=\pm \infty$:

<div class="sourceCode">

<pre class='scriptHaskell'><code class='scriptHaskell'><span class='prompt'>></span> <span class='hs-keyword'>import</span> <span class='hs-conid'>OwenQ</span>
<span class='prompt'>></span> <span class='hs-keyword'>import</span> <span class='hs-conid'>Math</span><span class='hs-varop'>.</span><span class='hs-conid'>Gamma</span> <span class='hs-keyword'>as</span> <span class='hs-conid'>G</span>
<span class='prompt'>></span> <span class='hs-comment'>-- zero:</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>3</span> <span class='hs-layout'>(</span><span class='hs-varop'>-</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span> <span class='hs-num'>2</span> <span class='hs-num'>2</span> 
<span class='output'>0.0</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>3</span> <span class='hs-num'>2</span> <span class='hs-layout'>(</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span> <span class='hs-num'>2</span>  
<span class='output'>0.0</span>
<span class='prompt'>></span> <span class='hs-comment'>-- equalities:</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>5</span> <span class='hs-layout'>(</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span> <span class='hs-num'>9</span> <span class='hs-num'>3</span>
<span class='output'>0.8909358420502276</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>5</span> <span class='hs-layout'>(</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span> <span class='hs-num'>99</span> <span class='hs-num'>3</span>
<span class='output'>0.8909358420502276</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>5</span> <span class='hs-num'>99</span> <span class='hs-layout'>(</span><span class='hs-varop'>-</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span> <span class='hs-num'>3</span>
<span class='output'>0.8909358420502276</span>
<span class='prompt'>></span> <span class='hs-definition'>owenQ1</span> <span class='hs-num'>5</span> <span class='hs-num'>9</span> <span class='hs-layout'>(</span><span class='hs-varop'>-</span><span class='hs-num'>1</span><span class='hs-varop'>/</span><span class='hs-num'>0</span><span class='hs-layout'>)</span> <span class='hs-num'>3</span>
<span class='output'>0.8909358420502276</span>
<span class='prompt'>></span> <span class='hs-conid'>G</span><span class='hs-varop'>.</span><span class='hs-varid'>p</span> <span class='hs-layout'>(</span><span class='hs-num'>5</span><span class='hs-varop'>/</span><span class='hs-num'>2</span><span class='hs-layout'>)</span> <span class='hs-layout'>(</span><span class='hs-num'>3</span><span class='hs-varop'>^</span><span class='hs-num'>2</span><span class='hs-varop'>/</span><span class='hs-num'>2</span><span class='hs-layout'>)</span>
<span class='output'>0.8909358420502276</span>
</code></pre>

</div>

References
----------

-   Owen, D. B. (1956). Tables for computing bivariate normal
    probabilities. *Ann. Math. Statist.* **27**, 1075-90.

-   Owen, D. B. (1965). A Special Case of a Bivariate Non-Central
    $t$-Distribution. *Biometrika* **52**, 437-446.
