---
author: Stéphane Laurent
date: '2017-06-05'
highlighter: hscolour
output:
  html_document: default
  md_document:
    variant: markdown
prettify: True
tags: 'haskell, special-functions, maths'
title: The binary splitting with Haskell
---

At the first line of each script in this article, we'll load the
following small Haskell module:

<div class="sourceCode">

<pre class='scriptHaskell'><code class='scriptHaskell'><span class='hs-comment'>-- BinarySplitting.hs</span>
<span class='hs-keyword'>module</span> <span class='hs-conid'>BinarySplitting</span>
  <span class='hs-keyword'>where</span>
<span class='hs-keyword'>import</span> <span class='hs-conid'>Data</span><span class='hs-varop'>.</span><span class='hs-conid'>Ratio</span> <span class='hs-layout'>(</span><span class='hs-layout'>(</span><span class='hs-varop'>%</span><span class='hs-layout'>)</span><span class='hs-layout'>)</span>
 
<span class='hs-definition'>split0</span> <span class='hs-keyglyph'>::</span> <span class='hs-layout'>(</span><span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span>
<span class='hs-definition'>split0</span> <span class='hs-varid'>u_v</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>map</span> <span class='hs-layout'>(</span><span class='hs-keyglyph'>\</span><span class='hs-varid'>i</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-layout'>(</span><span class='hs-varid'>u</span> <span class='hs-varop'>!!</span> <span class='hs-layout'>(</span><span class='hs-num'>2</span><span class='hs-varop'>*</span><span class='hs-varid'>i</span><span class='hs-layout'>)</span><span class='hs-layout'>)</span> <span class='hs-varop'>*</span> <span class='hs-layout'>(</span><span class='hs-varid'>v</span> <span class='hs-varop'>!!</span> <span class='hs-layout'>(</span><span class='hs-num'>2</span><span class='hs-varop'>*</span><span class='hs-varid'>i</span><span class='hs-varop'>+</span><span class='hs-num'>1</span><span class='hs-layout'>)</span><span class='hs-layout'>)</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>[</span><span class='hs-num'>0</span> <span class='hs-keyglyph'>..</span> <span class='hs-varid'>m</span><span class='hs-keyglyph'>]</span>
  <span class='hs-keyword'>where</span> <span class='hs-layout'>(</span><span class='hs-varid'>u</span><span class='hs-layout'>,</span> <span class='hs-varid'>v</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>u_v</span>
        <span class='hs-varid'>m</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>div</span> <span class='hs-layout'>(</span><span class='hs-varid'>length</span> <span class='hs-varid'>u</span><span class='hs-layout'>)</span> <span class='hs-num'>2</span> <span class='hs-comment'>-</span> <span class='hs-num'>1</span>
 
<span class='hs-definition'>split1</span> <span class='hs-keyglyph'>::</span> <span class='hs-layout'>(</span><span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>-&gt;</span>
               <span class='hs-layout'>(</span><span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>)</span>
<span class='hs-definition'>split1</span> <span class='hs-varid'>adb</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>split</span> <span class='hs-varid'>adb</span> <span class='hs-layout'>(</span><span class='hs-varid'>length</span> <span class='hs-varid'>alpha</span><span class='hs-layout'>)</span>
  <span class='hs-keyword'>where</span> <span class='hs-layout'>(</span><span class='hs-varid'>alpha</span><span class='hs-layout'>,</span> <span class='hs-keyword'>_</span><span class='hs-layout'>,</span> <span class='hs-keyword'>_</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>adb</span>
        <span class='hs-varid'>split</span> <span class='hs-keyglyph'>::</span> <span class='hs-layout'>(</span><span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-conid'>Int</span> <span class='hs-keyglyph'>-&gt;</span>
                             <span class='hs-layout'>(</span><span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>)</span>
        <span class='hs-varid'>split</span> <span class='hs-varid'>u_v_w</span> <span class='hs-varid'>n</span> <span class='hs-keyglyph'>=</span>
          <span class='hs-keyword'>if</span> <span class='hs-varid'>n</span> <span class='hs-varop'>==</span> <span class='hs-num'>1</span>
            <span class='hs-keyword'>then</span> <span class='hs-varid'>u_v_w</span>
            <span class='hs-keyword'>else</span> <span class='hs-varid'>split</span> <span class='hs-layout'>(</span><span class='hs-varid'>x</span><span class='hs-layout'>,</span> <span class='hs-varid'>split0</span> <span class='hs-layout'>(</span><span class='hs-varid'>v</span><span class='hs-layout'>,</span><span class='hs-varid'>v</span><span class='hs-layout'>)</span><span class='hs-layout'>,</span> <span class='hs-varid'>split0</span> <span class='hs-layout'>(</span><span class='hs-varid'>w</span><span class='hs-layout'>,</span><span class='hs-varid'>w</span><span class='hs-layout'>)</span><span class='hs-layout'>)</span> <span class='hs-layout'>(</span><span class='hs-varid'>div</span> <span class='hs-varid'>n</span> <span class='hs-num'>2</span><span class='hs-layout'>)</span>
          <span class='hs-keyword'>where</span> <span class='hs-layout'>(</span><span class='hs-varid'>u</span><span class='hs-layout'>,</span> <span class='hs-varid'>v</span><span class='hs-layout'>,</span> <span class='hs-varid'>w</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>u_v_w</span>
                <span class='hs-varid'>x</span>  <span class='hs-keyglyph'>=</span> <span class='hs-varid'>zipWith</span> <span class='hs-layout'>(</span><span class='hs-varop'>+</span><span class='hs-layout'>)</span> <span class='hs-layout'>(</span><span class='hs-varid'>split0</span> <span class='hs-layout'>(</span><span class='hs-varid'>u</span><span class='hs-layout'>,</span> <span class='hs-varid'>w</span><span class='hs-layout'>)</span><span class='hs-layout'>)</span> <span class='hs-layout'>(</span><span class='hs-varid'>split0</span> <span class='hs-layout'>(</span><span class='hs-varid'>v</span><span class='hs-layout'>,</span> <span class='hs-varid'>u</span><span class='hs-layout'>)</span><span class='hs-layout'>)</span>
 
<span class='hs-definition'>bsplitting</span> <span class='hs-keyglyph'>::</span> <span class='hs-conid'>Int</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-keyglyph'>[</span><span class='hs-conid'>Rational</span><span class='hs-keyglyph'>]</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-conid'>Rational</span>
<span class='hs-definition'>bsplitting</span> <span class='hs-varid'>m</span> <span class='hs-varid'>u</span> <span class='hs-varid'>v</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>num</span> <span class='hs-varop'>/</span> <span class='hs-varid'>den</span> <span class='hs-varop'>+</span> <span class='hs-num'>1</span>
  <span class='hs-keyword'>where</span> <span class='hs-layout'>(</span><span class='hs-keyglyph'>[</span><span class='hs-varid'>num</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>,</span> <span class='hs-keyword'>_</span><span class='hs-layout'>,</span> <span class='hs-keyglyph'>[</span><span class='hs-varid'>den</span><span class='hs-keyglyph'>]</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>split1</span> <span class='hs-layout'>(</span><span class='hs-varid'>take</span> <span class='hs-layout'>(</span><span class='hs-num'>2</span><span class='hs-varop'>^</span><span class='hs-varid'>m</span><span class='hs-layout'>)</span> <span class='hs-varid'>u</span><span class='hs-layout'>,</span> <span class='hs-varid'>take</span> <span class='hs-layout'>(</span><span class='hs-num'>2</span><span class='hs-varop'>^</span><span class='hs-varid'>m</span><span class='hs-layout'>)</span> <span class='hs-varid'>u</span><span class='hs-layout'>,</span> <span class='hs-varid'>take</span> <span class='hs-layout'>(</span><span class='hs-num'>2</span><span class='hs-varop'>^</span><span class='hs-varid'>m</span><span class='hs-layout'>)</span> <span class='hs-varid'>v</span><span class='hs-layout'>)</span>
</code></pre>

</div>

The `bsplitting` function performs the [binary splitting
algorithm](https://laustep.github.io/stlahblog/posts/hypergeometric.html).

Given an integer $m \geq 0$ and two sequences $(u_i)$ and $(v_i)$ of
rational numbers, it calculates the sum $$
A_m = 1 + \sum_{k=1}^{2^m} \prod_{i=1}^k\frac{u_i}{v_i}.  
$$

Approximation of $\pi$
----------------------

For example, $A_m \to \frac{\pi}{2}$ when $u_i = i$ and $v_i = 2i+1$. So
we get a rational approximate of $\pi$ as follows:

<div class="sourceCode">

<pre class='scriptHaskell'><code class='scriptHaskell'><span class='prompt'>></span> <span class='command'>:load</span> <span class='hs-conid'>BinarySplitting</span><span class='hs-varop'>.</span><span class='hs-varid'>hs</span>
<span class='prompt'>></span> 
<span class='prompt'>></span> <span class='m'>:{</span>
<span class='prompt'>></span> <span class='hs-definition'>approxPi</span> <span class='hs-keyglyph'>::</span> <span class='hs-conid'>Int</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-conid'>Rational</span>
<span class='prompt'>></span> <span class='hs-definition'>approxPi</span> <span class='hs-varid'>m</span> <span class='hs-keyglyph'>=</span> <span class='hs-num'>2</span> <span class='hs-varop'>*</span> <span class='hs-varid'>bsplitting</span> <span class='hs-varid'>m</span> <span class='hs-varid'>u</span> <span class='hs-varid'>v</span>
<span class='prompt'>></span>   <span class='hs-keyword'>where</span> <span class='hs-varid'>u</span> <span class='hs-keyglyph'>=</span> <span class='hs-keyglyph'>[</span><span class='hs-varid'>i</span> <span class='hs-keyglyph'>|</span> <span class='hs-varid'>i</span> <span class='hs-keyglyph'>&lt;-</span> <span class='hs-keyglyph'>[</span><span class='hs-num'>1</span> <span class='hs-keyglyph'>..</span><span class='hs-keyglyph'>]</span><span class='hs-keyglyph'>]</span>
<span class='prompt'>></span>         <span class='hs-varid'>v</span> <span class='hs-keyglyph'>=</span> <span class='hs-keyglyph'>[</span><span class='hs-num'>2</span><span class='hs-varop'>*</span><span class='hs-varid'>i</span><span class='hs-varop'>+</span><span class='hs-num'>1</span> <span class='hs-keyglyph'>|</span> <span class='hs-varid'>i</span> <span class='hs-keyglyph'>&lt;-</span> <span class='hs-keyglyph'>[</span><span class='hs-num'>1</span> <span class='hs-keyglyph'>..</span><span class='hs-keyglyph'>]</span><span class='hs-keyglyph'>]</span>
<span class='prompt'>></span> <span class='m'>:}</span>
<span class='prompt'>></span> 
<span class='prompt'>></span> <span class='hs-keyword'>let</span> <span class='hs-varid'>x</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>approxPi</span> <span class='hs-num'>5</span>
<span class='prompt'>></span> <span class='hs-definition'>x</span>
<span class='output'>12774464002301303455744 % 4066238182722121490175</span>
<span class='prompt'>></span> <span class='hs-definition'>fromRational</span> <span class='hs-varid'>x</span>
<span class='output'>3.141592653519747</span>
</code></pre>

</div>

Kummer hypergeometric function
------------------------------

Consider the confluent hypergeometric series $$
{}_1\!F_1(a, b; x) = \sum_{n=0}^{\infty}\frac{{(a)}_{n}}{{(b)}_{n}}\frac{x^n}{n!} = 1 + \sum_{n=1}^{\infty}\frac{{(a)}_{n}}{{(b)}_{n}}\frac{x^n}{n!}.
$$ Here ${(a)}_n:=a(a+1)\cdots(a+n-1)$ is the Pocchammer symbol denoting
the ascending factorial. The sum from $n=0$ to $n=2^m$ is evaluated by
the `bsplitting` function by taking the sequences\
$u_i = (a+i-1)x$ and $v_i = (b+i-1)i$.

Below we evaluate this sum for $a=8.1$, $b=10.1$ and $x=100$. We compare
the result to the value of ${}_1\!F_1(a, b; x)$ given by Wolfram.

<div class="sourceCode">

<pre class='scriptHaskell'><code class='scriptHaskell'><span class='prompt'>></span> <span class='command'>:load</span> <span class='hs-conid'>BinarySplitting</span><span class='hs-varop'>.</span><span class='hs-varid'>hs</span>
<span class='prompt'>></span> 
<span class='prompt'>></span> <span class='m'>:{</span>
<span class='prompt'>></span> <span class='hs-definition'>hypergeo1F1</span> <span class='hs-keyglyph'>::</span> <span class='hs-conid'>Int</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-conid'>Rational</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-conid'>Rational</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-conid'>Rational</span> <span class='hs-keyglyph'>-&gt;</span> <span class='hs-conid'>Double</span>
<span class='prompt'>></span> <span class='hs-definition'>hypergeo1F1</span> <span class='hs-varid'>m</span> <span class='hs-varid'>a</span> <span class='hs-varid'>b</span> <span class='hs-varid'>x</span> <span class='hs-keyglyph'>=</span> <span class='hs-varid'>fromRational</span> <span class='hs-varop'>$</span> <span class='hs-varid'>bsplitting</span> <span class='hs-varid'>m</span> <span class='hs-varid'>u</span> <span class='hs-varid'>v</span>
<span class='prompt'>></span>   <span class='hs-keyword'>where</span> <span class='hs-varid'>u</span> <span class='hs-keyglyph'>=</span> <span class='hs-keyglyph'>[</span><span class='hs-layout'>(</span><span class='hs-varid'>a</span><span class='hs-varop'>+</span><span class='hs-varid'>i</span><span class='hs-layout'>)</span><span class='hs-varop'>*</span><span class='hs-varid'>x</span> <span class='hs-keyglyph'>|</span> <span class='hs-varid'>i</span> <span class='hs-keyglyph'>&lt;-</span> <span class='hs-keyglyph'>[</span><span class='hs-num'>0</span> <span class='hs-keyglyph'>..</span><span class='hs-keyglyph'>]</span><span class='hs-keyglyph'>]</span>
<span class='prompt'>></span>         <span class='hs-varid'>v</span> <span class='hs-keyglyph'>=</span> <span class='hs-keyglyph'>[</span><span class='hs-layout'>(</span><span class='hs-varid'>b</span><span class='hs-varop'>+</span><span class='hs-varid'>i</span><span class='hs-layout'>)</span><span class='hs-varop'>*</span><span class='hs-layout'>(</span><span class='hs-varid'>i</span><span class='hs-varop'>+</span><span class='hs-num'>1</span><span class='hs-layout'>)</span> <span class='hs-keyglyph'>|</span> <span class='hs-varid'>i</span> <span class='hs-keyglyph'>&lt;-</span> <span class='hs-keyglyph'>[</span><span class='hs-num'>0</span> <span class='hs-keyglyph'>..</span><span class='hs-keyglyph'>]</span><span class='hs-keyglyph'>]</span>
<span class='prompt'>></span> <span class='m'>:}</span>
<span class='prompt'>></span> 
<span class='prompt'>></span> <span class='hs-keyword'>let</span> <span class='hs-varid'>wolfram</span> <span class='hs-keyglyph'>=</span> <span class='hs-num'>1.7241310759926883216143646e41</span>
<span class='prompt'>></span> 
<span class='prompt'>></span> <span class='hs-definition'>wolfram</span> <span class='hs-varop'>-</span> <span class='hs-varid'>hypergeo1F1</span> <span class='hs-num'>6</span> <span class='hs-layout'>(</span><span class='hs-num'>81</span><span class='hs-varop'>%</span><span class='hs-num'>10</span><span class='hs-layout'>)</span> <span class='hs-layout'>(</span><span class='hs-num'>101</span><span class='hs-varop'>%</span><span class='hs-num'>10</span><span class='hs-layout'>)</span> <span class='hs-num'>100</span>
<span class='output'>1.7238238908740056e41</span>
<span class='prompt'>></span> <span class='hs-definition'>wolfram</span> <span class='hs-varop'>-</span> <span class='hs-varid'>hypergeo1F1</span> <span class='hs-num'>7</span> <span class='hs-layout'>(</span><span class='hs-num'>81</span><span class='hs-varop'>%</span><span class='hs-num'>10</span><span class='hs-layout'>)</span> <span class='hs-layout'>(</span><span class='hs-num'>101</span><span class='hs-varop'>%</span><span class='hs-num'>10</span><span class='hs-layout'>)</span> <span class='hs-num'>100</span>
<span class='output'>3.0481841873624932e38</span>
<span class='prompt'>></span> <span class='hs-definition'>wolfram</span> <span class='hs-varop'>-</span> <span class='hs-varid'>hypergeo1F1</span> <span class='hs-num'>8</span> <span class='hs-layout'>(</span><span class='hs-num'>81</span><span class='hs-varop'>%</span><span class='hs-num'>10</span><span class='hs-layout'>)</span> <span class='hs-layout'>(</span><span class='hs-num'>101</span><span class='hs-varop'>%</span><span class='hs-num'>10</span><span class='hs-layout'>)</span> <span class='hs-num'>100</span>
<span class='output'>0.0</span>
</code></pre>

</div>

We find a good approximate for $m=8$ (so $2^m=256$), and the evaluation
is really fast.
