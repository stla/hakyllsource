---
title: "Expanding a polynomial with 'caracas', part 2"
author: "Stéphane Laurent"
date: '2022-07-16'
tags: R, povray, graphics, maths, python
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

Last month, I posted an
[article](https://laustep.github.io/stlahblog/posts/caracas01.html)
showing a way to expand a polynomial in R when the coefficients of the
polynomial contain some literal values, with the help of the **caracas**
package. Today I wanted to apply it with a polynomial expression having
about 500 characters, and highly factorized. The method took more than
30 minutes, so I looked for a more efficient one.

Thanks to some help on StackOverflow, I came to the following method
which is more efficient. It consists in splitting the expression
according to its additive terms and to work on each term, instead of
expanding the whole polynomial. In the example below I take the
polynomial expression defining the isosurface equation of a Solid Möbius
strip.

``` {.r .numberLines}
library(caracas)
sympy <- get_sympy()
# define the variables x,y,z and the constants a,b
def_sym(x, y, z, a, b)
# define expression 
expr <- sympy$parse_expr(
  "((x*x+y*y+1)*(a*x*x+b*y*y)+z*z*(b*x*x+a*y*y)-2*(a-b)*x*y*z-a*b*(x*x+y*y))**2-4*(x*x+y*y)*(a*x*x+b*y*y-x*y*z*(a-b))**2"
) 
# extraction of monomials in the 'povray' list
povray <- list()
terms <- sympy$Add$make_args(expr)
for(term in terms){
  f <- term$expand()
  fterms <- sympy$Add$make_args(f)
  for(fterm in fterms){
    decomp  <- fterm$as_coeff_mul(x$pyobj, y$pyobj, z$pyobj)
    coef    <- decomp[[1]]
    mono    <- decomp[[2]]
    polexpr <- sympy$Mul$fromiter(mono)
    poly    <- polexpr$as_poly(x$pyobj, y$pyobj, z$pyobj)
    degree  <- toString(poly$monoms()[[1]])
    if(degree %in% names(povray)){
      povray[[degree]] <- sympy$Add(povray[[degree]], coef)
    }else{
      povray[[degree]] <- coef
    }
  }
}
polynomial <- vapply(names(povray), function(degree){
  coeff <- povray[[degree]] |>
    gsub("([ab])\\*\\*(\\d+)", "pow(\\1,\\2)", x = _)
  sprintf("xyz(%s): %s,", degree, coeff)
}, character(1L))
cat(polynomial, sep = "\n", file = "SolidMobiusStrip.txt")
```

At the last step I use `gsub` to replace the powers like `a**2` to their
POV-Ray syntax `pow(a,2)`. The above code writes this POV-Ray code:

``` povray
xyz(4, 0, 0): pow(a,2)*pow(b,2) - 2*pow(a,2)*b + pow(a,2),
xyz(8, 0, 0): pow(a,2),
xyz(0, 4, 0): pow(a,2)*pow(b,2) - 2*a*pow(b,2) + pow(b,2),
xyz(0, 8, 0): pow(b,2),
xyz(6, 0, 0): -2*pow(a,2)*b - 2*pow(a,2),
xyz(0, 6, 0): -2*a*pow(b,2) - 2*pow(b,2),
xyz(4, 4, 0): pow(a,2) + 4*a*b + pow(b,2),
xyz(0, 4, 4): pow(a,2),
xyz(4, 0, 4): pow(b,2),
xyz(4, 2, 0): -4*pow(a,2)*b - 2*pow(a,2) - 2*a*pow(b,2) - 4*a*b,
xyz(6, 2, 0): 2*pow(a,2) + 2*a*b,
xyz(2, 4, 0): -2*pow(a,2)*b - 4*a*pow(b,2) - 4*a*b - 2*pow(b,2),
xyz(2, 6, 0): 2*a*b + 2*pow(b,2),
xyz(1, 3, 3): -4*pow(a,2) + 4*a*b,
xyz(3, 1, 1): 4*pow(a,2)*b - 4*pow(a,2) - 4*a*pow(b,2) + 4*a*b,
xyz(5, 1, 1): 4*pow(a,2) - 4*a*b,
xyz(3, 3, 1): 4*pow(a,2) - 4*pow(b,2),
xyz(2, 2, 0): 2*pow(a,2)*pow(b,2) - 2*pow(a,2)*b - 2*a*pow(b,2) + 2*a*b,
xyz(4, 0, 2): -2*a*pow(b,2) + 2*a*b,
xyz(0, 4, 2): -2*pow(a,2)*b + 2*a*b,
xyz(6, 0, 2): 2*a*b,
xyz(0, 6, 2): 2*a*b,
xyz(2, 4, 2): -2*pow(a,2) + 10*a*b - 2*pow(b,2),
xyz(4, 2, 2): -2*pow(a,2) + 10*a*b - 2*pow(b,2),
xyz(1, 3, 1): 4*pow(a,2)*b - 4*a*pow(b,2) - 4*a*b + 4*pow(b,2),
xyz(1, 5, 1): 4*a*b - 4*pow(b,2),
xyz(3, 1, 3): -4*a*b + 4*pow(b,2),
xyz(2, 2, 2): -2*pow(a,2)*b + 6*pow(a,2) - 2*a*pow(b,2) - 8*a*b + 6*pow(b,2),
xyz(2, 2, 4): 2*a*b,
```

This is very fast for this example, but it still took 20 minutes with my
case, which is a slight modification of an animation by 'ICN5D'; here it
is:

![](./figures/ICN5D_02.gif)

The difference with the original animation is that this one uses an
[isoclinic
rotation](https://laustep.github.io/stlahblog/posts/slicedImplicitHypersurface.html)
for the animation.
