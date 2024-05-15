---
title: "Jack polynomials in Python"
author: "Stéphane Laurent"
date: '2024-05-15'
tags: python, maths
output:
  md_document:
    variant: markdown
    preserve_yaml: true
  html_document:
    highlight: kate
    keep_md: no
highlighter: pandoc-solarized
---

In my [previous post about the Jack
polynomials](https://laustep.github.io/stlahblog/posts/JackSymbolicParameter.html "Jack polynomials with symbolic parameter"),
I said that I thought it would not be difficult to modify the code of my
[Python package
**jackpy**](https://github.com/stla/jackpy "the 'jackpy' package on Github")
in order to make it able to compute Jack polynomials with a symbolic
parameter. I was right. I managed to do this modification and it
sufficed to set a **SymPy** symbol as the Jack parameter instead of a
number. So now Jack polynomials with a symbolic parameter are available
in **jackpy**:

``` python
>>> from jackpy.jack import JackSymbolicPol
>>>
>>> poly = JackSymbolicPol(3, [2, 2])
>>> print(poly)
Poly((2*alpha**2 + 6*alpha + 4)*x_1**2*x_2**2 
 + (4*alpha + 8)*x_1**2*x_2*x_3 
 + (2*alpha**2 + 6*alpha + 4)*x_1**2*x_3**2 
 + (4*alpha + 8)*x_1*x_2**2*x_3 
 + (4*alpha + 8)*x_1*x_2*x_3**2 
 + (2*alpha**2 + 6*alpha + 4)*x_2**2*x_3**2, 
 x_1, x_2, x_3, domain='QQ(alpha)')
```

For some reason, this new version of **jackpy** is not available on
'PyPi' yet. So if you want to use it, you have to install the package
hosted on the Github repository. I have not tried, but maybe this can be
achieved by running the following command:

    pip install git+https://github.com/stla/jackpy.git

I have not benchmarked so I don't know how the speed compares with my
implementations in other languages. By the way I improved the Haskell
implementation, and it seems to be faster than the Julia implementation
now.

```{=html}
<!-- links -->
```
