---
title: "Passing a function from R to C++"
author: "Stéphane Laurent"
date: '2023-02-06'
tags: R, Rcpp, C++
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

The `algebraicMesh` function of my package
[**cgalMeshes**](https://github.com/stla/cgalMeshes) takes as inputs a
trivariate polynomial $P(x,y,z)$, a number $\ell$ and some other
parameters, and it returns a mesh of the isosurface defined by
$P(x,y,z) = \ell$. The computation of this mesh is done in C++ with the
help of the **Rcpp** package and the **CGAL** library.

Each term of the polynomial is represented by a number, its coefficient,
and a vector of three integers, the exponents of the three variables. So
there is no difficulty to pass this polynomial from R to C++ with
**Rcpp**.

I was wondering how one could pass the body of an arbitrary function
$f(x,y,z)$ from R to C++, and not only a polynomial, to compute a mesh
of an isosurface $f(x,y,z) = \ell$. I mean a simple function, whose body
is given by an elementary mathematical expression. I know it is possible
to pass a R function with **Rcpp**, as explained in the quick reference
guide, but the evaluation of this function is not efficient enough for
this situation.

Then I googled, and I discovered the C++ library [**Function
Parser**](http://warp.povusers.org/FunctionParser/), written by Juha
Nieminen and Joel Yliluoma. I gave it a try today; it works fine and it
is easy to use.

Here is how to use it with **Rcpp**. First, download the **zip** file
given in the above link. Unzip it and then, in the ***src*** folder of
your package, put the files **fparser.cc**, **fparser.hh**,
**fpconfig.hh**, **fpoptimizer.cc**, and the folder **extrasrc**. Now
you're ready to use **Function Parser**. Here is simple example:

``` cpp
// [[Rcpp::export]]
void helloWorld() {
  FunctionParser fp;
  fp.Parse("sqrt(x*x + y*y)", "x,y");
  double variables[2] = { 3.0, 4.0 };
  double result = fp.Eval(variables);
  Rcpp::Rcout << result << "\n";
}
```

Build the package and run `helloWorld()` in R. Then `5` will be printed
in the console. Of course this example has no interest. Here is a more
interesting one:

``` cpp
// [[Rcpp::export]]
double funeval(
  const std::string&        functionBody, 
  const std::string&        variableNames, 
  const Rcpp::NumericVector variableValues
) {
  FunctionParser fp;
  fp.Parse(functionBody, variableNames);
  const int nvariables = variableValues.size();
  double values[nvariables];
  for(int i = 0; i < nvariables; i++) {
    values[i] = variableValues(i);
  }
  const double result = fp.Eval(values);
  return result;
}
```

Build and run `funeval("sqrt(x*x + y*y)", "x,y", c(3, 4))`, you'll get
`5`.
