---
title: "Matrix variate Beta distributions"
author: "Stéphane Laurent"
date: "2017-12-12"
output:
  html_document:
    keep_md: no
    toc: yes
  md_document:
    toc: yes
    variant: markdown
    preserve_yaml: true
prettify: yes
linenums: yes
prettifycss: twitter-bootstrap
tags: R, maths, statistics
highlighter: kate
---

-   [Definitions](#definitions)
-   [Hypergeometric matrix function](#hypergeometric-matrix-function)
-   [Densities and identities](#densities-and-identities)
    -   [$\boxed{\mathcal{B}I_p^{(1)}(a, b, \Theta_1, \Theta_2)}$](#boxedmathcalbi_p1a-b-theta_1-theta_2)
    -   [$\boxed{\mathcal{B}I_p^{(2)}(a, b, \Theta_1, \Theta_2)}$](#boxedmathcalbi_p2a-b-theta_1-theta_2)
    -   [$\boxed{\mathcal{B}II_p^{(1)}(a,b,\Theta_1,\Theta_2)}$](#boxedmathcalbii_p1abtheta_1theta_2)
    -   [$\boxed{\mathcal{B}II_p^{(2)}(a,b,\Theta_1,\Theta_2)}$](#boxedmathcalbii_p2abtheta_1theta_2)
-   [Proofs](#proofs)
    -   [$\boxed{\mathcal{B}I_p^{(1)}(a,b,\Theta_1,\Theta_2)}$](#boxedmathcalbi_p1abtheta_1theta_2)
    -   [$\boxed{\mathcal{B}I_p^{(2)}(a,b,\Theta_1,\Theta_2)}$](#boxedmathcalbi_p2abtheta_1theta_2)
    -   [$\boxed{\mathcal{B}II_p^{(1)}(a,b,\Theta_1,\Theta_2)}$](#boxedmathcalbii_p1abtheta_1theta_2-1)
    -   [$\boxed{\mathcal{B}II_p^{(2)}(a,b,\Theta_1,\Theta_2)}$](#boxedmathcalbii_p2abtheta_1theta_2-1)
    -   [Simplifications in the singly noncentral
        case](#simplifications-in-the-singly-noncentral-case)

$\newcommand{\etr}{\textrm{etr}}$

One asked me what are the densities of the matrix variate Beta
distributions in the [`matrixsampling`
package](https://github.com/stla/matrixsampling). I'm going to give them
here.

Definitions
===========

Two definitions of the matrix variate Beta type I distribution were
proposed. We will denote them by
$\mathcal{B}I_p^{(1)}(a,b,\Theta_1,\Theta_2)$ and
$\mathcal{B}I_p^{(2)}(a,b,\Theta_1,\Theta_2)$, where $\Theta_1$ and
$\Theta_2$ are the noncentrality parameters. Take two independent
Wishart random matrices $W_1 \sim \mathcal{W}_p(2a, I_p, \Theta_1)$ and
$W_2 \sim \mathcal{W}_p(2b, I_p, \Theta_2)$. Then
$\mathcal{B}I_p^{(1)}(a,b,\Theta_1,\Theta_2)$ is the distribution of $$
U_1 = {(W_1+W_2)}^{-\frac12}W_1{(W_1+W_2)}^{-\frac12},
$$ while $\mathcal{B}I_p^{(2)}(a,b,\Theta_1,\Theta_2)$ is the
distribution of $$
U_2 = W_1^\frac12{(W_1+W_2)}^{-1}W_1^\frac12.
$$ The condition $a+b > \frac12(p-1)$ is required in order for $W_1+W_2$
to be invertible.

In the central case, i.e. when both $\Theta_1$ and $\Theta_2$ are the
null matrices, these two distributions are the same. More generally, as
we will see, they are the same when $\Theta_1$ and $\Theta_2$ are
scalar.

Similarly, two definitions of the matrix variate Beta type II
distribution were proposed. We will denote them by
$\mathcal{B}II_p^{(1)}(a,b,\Theta_1,\Theta_2)$ and
$\mathcal{B}II_p^{(2)}(a,b,\Theta_1,\Theta_2)$. The first one is the
distribution of $$
V_1 = W_2^{-\frac12} W_1 W_2^{-\frac12},
$$ while the second one is the distribution of $$
V_2 = W_1^\frac12 {W_2}^{-1} W_1^\frac12.
$$ The condition $b > \frac12(p-1)$ is required in order for $W_2$ to be
invertible.

Similarly to the type I, these two distributions are the same in the
central case, and more generally when $\Theta_1$ and $\Theta_2$ are
scalar.

Under the second definition, the Beta type I distribution is related to
the Beta type II distribution by $U_2 \sim V_2{(I_p+V_2)}^{-1}$.

Hypergeometric matrix function
==============================

The densities of the matrix Beta distributions involve the
hypergeometric function of matrix argument ${}_0\!F_1$. We will use the
property ${}_0\!F_1(\alpha, AB)={}_0\!F_1(\alpha, BA)$ (to simplify the
densities when $\Theta_1$ or $\Theta_2$ are scalar).

Densities and identities
========================

We provide the densities here. We will prove these results in the next
section. Note that $a$ and $b$ must satisfy $a,b > \frac12(p+1)$ in
order for each distribution to have a density.

We denote by $\etr$ the function taking the exponential of the trace of
a matrix.

### $\boxed{\mathcal{B}I_p^{(1)}(a, b, \Theta_1, \Theta_2)}$

Recall that $$
U_1 = {(W_1+W_2)}^{-\frac12} W_1 {(W_1+W_2)}^{-\frac12}.
$$ It is clear from this definition that $$
I_p - U_1 \sim \mathcal{B}I_p^{(1)}(b, a, \Theta_2, \Theta_1).
$$ The density of $U_1$ is $$
\begin{split}
& \mathcal{B}I_p^{(1)}(U \mid a, b, \Theta_1, \Theta_2) \propto 
{\det(U)}^{a-\frac12(p+1)} {\det(I_p-U)}^{b-\frac12(p+1)} \\
& \quad \int_{S>0} \etr(-S)
{\det(S)}^{a+b-\frac12(p+1)}
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1S^{\frac12} U S^\frac12\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2S^{\frac12}(I_p-U)S^\frac12\right)
\mathrm{d}S
\end{split}
$$ for $0 < U < I_p$.

If $\Theta_1$ and $\Theta_2$ are scalar, $$
\begin{split}
& \mathcal{B}I_p^{(1)}(U \mid a, b, \Theta_1, \Theta_2) \propto
{\det(U)}^{a-\frac12(p+1)} {\det(I_p-U)}^{b-\frac12(p+1)} \\
& \quad \int_{S>0} \etr(-S)
{\det(S)}^{a+b-\frac12(p+1)}
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1SU\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2S(I_p-U)\right)
\mathrm{d}S.
\end{split}
$$

### $\boxed{\mathcal{B}I_p^{(2)}(a, b, \Theta_1, \Theta_2)}$

Recall that $$
U_2 = W_1^\frac12{(W_1+W_2)}^{-1}W_1^\frac12.
$$

The density of $U_2$ is $$
\begin{split}
& \mathcal{B}I_p^{(2)}(U \mid a, b, \Theta_1, \Theta_2) \propto  
 {\det(U)}^{-b-\frac12(p+1)}
{\det(I_p-U)}^{b-\frac12(p+1)} \\
& \quad \int_{S>0}
\etr(-U^{-1}S)
{\det(S)}^{a+b-\frac12(p+1)} 
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1S\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2 S^\frac12 U^{-1}(I_p-U)S^{\frac12}\right)\mathrm{d}S
\end{split}
$$ for $0 < U < I_p$.

If $\Theta_1$ and $\Theta_2$ are scalar, it is equal to the density of
$\mathcal{B}I_p^{(1)}(a, b, \Theta_1, \Theta_2)$.

### $\boxed{\mathcal{B}II_p^{(1)}(a,b,\Theta_1,\Theta_2)}$

More generally, we give the density of $$
V_1 = {(W_2^{-\frac12})}' W_1 W_2^{-\frac12}
$$ where $W_2^{\frac12}{(W_2^{\frac12})}' = W_2$.

This density of $V_1$ is $$
\begin{split}
& \mathcal{B}II_p^{(1)}(V \mid a, b, \Theta_1, \Theta_2) \propto 
 {\det(V)}^{a-\frac12(p+1)} \\
& \quad
\int_{S>0}
\etr\bigl(-(I_p+V)S\bigr)
{\det(S)}^{a+b-\frac12(p+1)} 
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1{(S^{\frac12})}' V S^{\frac12}\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2S\right) \mathrm{d}S
\end{split}
$$ for $V>0$.

If $\Theta_1$ is scalar, the distribution does not depend on the choice
of $W_2^\frac12$.

### $\boxed{\mathcal{B}II_p^{(2)}(a,b,\Theta_1,\Theta_2)}$

More generally, we give the density of $$
V_2 = W_1^{\frac12} W_2^{-1} {(W_1^{\frac12})}'
$$ where $W_1^{\frac12}{(W_1^{\frac12})}' = W_1$.

Assuming $a > \frac12(p-1)$, it is clear from the definitions that $$
V_2^{-1} \sim \mathcal{B}II_p^{(1)}(b,a,\Theta_2,\Theta_1).
$$

The density of $V_2$ is $$
\begin{split}
& \mathcal{B}II_p^{(2)}(V \mid a, b, \Theta_1, \Theta_2) \propto  
 {\det(V)}^{-b-\frac12(p+1)} \\ 
& \quad \int_{S >0}
\etr\bigl(-(I_p+V^{-1})S\bigr)
{\det(S)}^{a+b-\frac12(p+1)}  
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1S\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2{(S^\frac12)}' V^{-1} S^\frac12\right)
\mathrm{d}S.
\end{split}
$$ for $V >0$.

If $\Theta_2$ is scalar, the distribution does not depend on the choice
of $W_1^\frac12$.

If $\Theta_1$ and $\Theta_2$ are scalar, this is the same distribution
as $\mathcal{B}II_p^{(1)}(a,b,\Theta_1,\Theta_2)$.

If we take $W_1^{\frac12}$ the symmetric square root of $W_1$, then
$V_2{(I_p+V_2)}^{-1} \sim \mathcal{B}I_p^{(2)}(a,b,\Theta_1,\Theta_2)$.

Proofs
======

To derive the densities, we start with the joint density of $W_1$ and
$W_2$ which is $$
C \, \etr\left(-\frac12 W_1\right)\etr\left(-\frac12 W_2\right)
{\det(W_1)}^{a-\frac12(p+1)} {\det(W_2)}^{b-\frac12(p+1)}
{}_0\!F_1\left(a, \frac{1}{4}\Theta_1W_1\right)
{}_0\!F_1\left(b, \frac{1}{4}\Theta_2W_2\right)
$$ where $C$ is a constant.

In our following calculations, we always denote by $C$ a constant not
depending of the variables. The value of $C$ is relative to each
expression in which it is contained: two $C$'s written at two different
places have not the same value.

### $\boxed{\mathcal{B}I_p^{(1)}(a,b,\Theta_1,\Theta_2)}$

Recall that $\mathcal{B}I_p^{(1)}(a,b,\Theta_1,\Theta_2)$ is the
distribution of $$
U = {(W_1+W_2)}^{-\frac12}W_1{(W_1+W_2)}^{-\frac12}.
$$ By applying the transformation $W_1+W_2=S$ and
$W_1 = S^{\frac12} U S^\frac12$, whose Jacobian is
$J(W_1, W_2 \rightarrow U, S) = {\det(S)}^{\frac12(p+1)}$, we get the
pdf of $(U,S)$ as $$
\begin{aligned}
C\, &
{\det(U)}^{a-\frac12(p+1)} {\det(I_p-U)}^{b-\frac12(p+1)} \\ 
& 
\etr\left(-\frac12 S\right)
 {\det(S)}^{a+b-\frac12(p+1)}
{}_0\!F_1\left(a, \frac{1}{4}\Theta_1S^{\frac12} U S^\frac12\right)
{}_0\!F_1\left(b, \frac{1}{4}\Theta_2S^{\frac12}(I_p-U) S^\frac12\right).
\end{aligned}
$$ Thus the density of $U$ is $$
\begin{aligned}
C\, &
{\det(U)}^{a-\frac12(p+1)} {\det(I_p-U)}^{b-\frac12(p+1)} \\
& \int_{S>0} \etr\left(-\frac12 S\right)
 {\det(S)}^{a+b-\frac12(p+1)}
{}_0\!F_1\left(a, \frac{1}{4}\Theta_1S^{\frac12}U{(S^\frac12)}'\right)
{}_0\!F_1\left(b, \frac{1}{4}\Theta_2S^{\frac12}(I_p-U)S^\frac12\right) 
\mathrm{d}S
\\ 
= C\,& 
{\det(U)}^{a-\frac12(p+1)} {\det(I_p-U)}^{b-\frac12(p+1)} \\
& \int_{S>0} \etr(-S)
{\det(S)}^{a+b-\frac12(p+1)}
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1S^{\frac12} U S^\frac12\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2S^{\frac12}(I_p-U)S^\frac12\right)
\mathrm{d}S. 
\end{aligned}
$$

### $\boxed{\mathcal{B}I_p^{(2)}(a,b,\Theta_1,\Theta_2)}$

Recall that $\mathcal{B}I_p^{(2)}(a,b,\Theta_1,\Theta_2)$ is the
distribution of $$
U = W_1^\frac12{(W_1+W_2)}^{-1}W_1^\frac12.
$$

We use the transformation $W_1+W_2 = W_1^{\frac12}U^{-1}W_1^{\frac12}$.
The Jacobian of this transformation is
$J(W_1, W_2 \rightarrow U, W_1) = {\det(W_1)}^{\frac12(p+1)} {\det(U)}^{-(p+1)}$,
and we get the pdf of $(U,W_1)$ as $$
\begin{aligned}
C \, &
{\det(W_1)}^{a+b-\frac12(p+1)} 
{\det(U)}^{-(p+1)}
{\det(U^{-1}-I_p)}^{b-\frac12(p+1)} \\
& \etr\left(-\frac12 W_1U^{-1}\right)
{}_0\!F_1\left(a, \frac{1}{4}\Theta_1W_1\right)
{}_0\!F_1\left(b, \frac{1}{4}\Theta_2W_1^{\frac12}(U^{-1}-I_p)W_1^\frac12\right) 
\\ = 
C \, & 
{\det(W_1)}^{a+b-\frac12(p+1)} 
{\det(U)}^{-b-\frac12(p+1)}
{\det(I_p-U)}^{b-\frac12(p+1)} \\ 
& \etr\left(-\frac12 W_1U^{-1}\right)
{}_0\!F_1\left(a, \frac{1}{4}\Theta_1W_1\right)
{}_0\!F_1\left(b, \frac{1}{4}\Theta_2W_1^{\frac12}U^{-1}(I_p-U)W_1^\frac12\right).
\end{aligned}
$$ Thus the density of $U$ is $$
\begin{aligned}
C\, &
{\det(U)}^{-b-\frac12(p+1)}
{\det(I_p-U)}^{b-\frac12(p+1)} \\ 
& \int_{W_1>0}
\etr\left(-\frac12 W_1U^{-1}\right)
{\det(W_1)}^{a+b-\frac12(p+1)} \\
& \qquad
{}_0\!F_1\left(a, \frac{1}{4}\Theta_1W_1\right)
{}_0\!F_1\left(b, \frac{1}{4}\Theta_2W_1^{\frac12}U^{-1}(I_p-U)W_1^\frac12\right)
\mathrm{d}W_1\\
= C\, &  
{\det\bigl(U{(I_p-U)}^{-1}\bigr)}^{-b-\frac12(p+1)}
{\det(I_p-U)}^{-(p+1)} \\
& \int_{S>0}
\etr(- U^{-1}S)
{\det(S)}^{a+b-\frac12(p+1)} 
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1S\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2S^{\frac12}U^{-1}(I_p-U)S^\frac12\right)
\mathrm{d}S.
\end{aligned}
$$ Let's derive the density of $U{(I_p-U)}^{-1}$. Using the
transformation $U = V{(I_p+V)}^{-1}$ with Jacobian
$J(U \rightarrow V) = {\det(I_p+V)}^{-(p+1)}$, we get the density of $V$
as $$
\begin{aligned}
C\, &
{\det(V)}^{-b-\frac12(p+1)} \\
& \int_{S>0}
\etr\bigl(-(I_p+V^{-1})S\bigr)
{\det(S)}^{a+b-\frac12(p+1)} 
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1S\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2S^{\frac12}V^{-1}S^\frac12\right)
\mathrm{d}S.
\end{aligned}
$$ This is the density of
$\mathcal{B}II_p^{(2)}(a,b,\Theta_1,\Theta_2)$.

### $\boxed{\mathcal{B}II_p^{(1)}(a,b,\Theta_1,\Theta_2)}$

Recall that $\mathcal{B}II_p^{(1)}(a,b,\Theta_1,\Theta_2)$ is the
distribution of $$
V = {(W_2^{-\frac12})}' W_1 W_2^{-\frac12}.
$$

Transforming $W_1 = {(W_2^{\frac12})}' V W_2^{\frac12}$ with Jacobian
$J(W_1, W_2 \rightarrow V, W_2) = {\det(W_2)}^{\frac12(p+1)}$, we get
the density of $(V,W_2)$ as $$
\begin{aligned}
C\, & 
{\det(V)}^{a-\frac12(p+1)} {\det(W_2)}^{a+b-\frac12(p+1)} \\
& 
\etr\left(-\frac12 (I_p+V)W_2\right)
{}_0\!F_1\left(a, \frac{1}{4}\Theta_1 {(W_2^{\frac12})}' V W_2^{\frac12}\right)
{}_0\!F_1\left(b, \frac{1}{4}\Theta_2W_2\right).
\end{aligned}
$$ Thus, the density of $V$ is $$
\begin{aligned}
C\, & 
{\det(V)}^{a-\frac12(p+1)} \\ 
& \int_{S>0}
\etr\bigl(-(I_p+V)S\bigr)
{\det(S)}^{a+b-\frac12(p+1)} 
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1{(S^{\frac12})}' V S^{\frac12}\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2S\right)
\mathrm{d}S.
\end{aligned}
$$

### $\boxed{\mathcal{B}II_p^{(2)}(a,b,\Theta_1,\Theta_2)}$

Recall that $\mathcal{B}II_p^{(2)}(a,b,\Theta_1,\Theta_2)$ is the
distribution of $$
V = W_1^{\frac12} W_2^{-1} {(W_1^{\frac12})}'.
$$

We apply the transformation $W_2 = {(W_1^\frac12)}' V^{-1} W_1^\frac12$.
The Jacobian of this transformation is
$J(W_1, W_2 \rightarrow V, W_1) = {\det(W_1)}^{\frac12(p+1)}{\det(V)}^{-(p+1)}$.
We get the density of $(V,W_1)$ as $$
\begin{aligned}
C\, &
{\det(W_1)}^{a+b-\frac12(p+1)} {\det(V)}^{-b-\frac12(p+1)} \\
&
\etr\left(-\frac12 W_1\right)\etr\left(-\frac12 W_1V^{-1}\right)
{}_0\!F_1\left(a, \frac{1}{4}\Theta_1W_1\right)
{}_0\!F_1\left(b, \frac{1}{4}\Theta_2{(W_1^\frac12)}' V^{-1} W_1^\frac12\right).
\end{aligned}
$$ Thus the density of $V$ is $$
\begin{aligned}
C\, &
{\det(V)}^{-b-\frac12(p+1)} \\ 
& \int_{S >0}
\etr\bigl(-(I_p+V^{-1})S\bigr)
{\det(S)}^{a+b-\frac12(p+1)}  
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1S\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2{(S^\frac12)}' V^{-1} S^\frac12\right)
\mathrm{d}S.
\end{aligned}
$$ Now assume $\Theta_2$ is scalar. Then one has $$
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2{(S^\frac12)}' V^{-1} S^\frac12\right) 
= {}_0\!F_1\left(b, \frac{1}{2}\Theta_2 S V^{-1}\right).
$$ Doing the change of variables $R = S V^{-1}$ in the integral, we get
the density of $V$ as $$
\begin{aligned}
C\, &
{\det(V)}^{a-\frac12(p+1)} \\ 
& \int_{R >0}
\etr\bigl(-(I_p+V)R\bigr)
{\det(R)}^{a+b-\frac12(p+1)}  
{}_0\!F_1\left(a, \frac{1}{2}\Theta_1 R V\right)
{}_0\!F_1\left(b, \frac{1}{2}\Theta_2 R\right)
\mathrm{d}R.
\end{aligned}
$$ If in addition, $\Theta_1$ is scalar, this is the density of
$\mathcal{B}II_p^{(1)}(a,b,\Theta_1,\Theta_2)$.

Simplifications in the singly noncentral case
---------------------------------------------

One has ${}_0\!F_1(\alpha, \mathbf{0}) = 1$. Thus, when $\Theta_1$ or
$\Theta_2$ is the null matrix, we get integrals like $$
\int_{S>0}
\etr(-ZS)
{\det(S)}^{\alpha-\frac12(p+1)} 
{}_0\!F_1\left(\beta, \frac{1}{2}\Theta S T \right)
\mathrm{d}S,
$$ for example in the density of
$\mathcal{B}I_p^{(2)}(a,b,\Theta_1,\Theta_2)$ when $\Theta_2$ is the
null matrix, or in the density of
$\mathcal{B}I_p^{(1)}(a,b,\Theta_1,\Theta_2)$ when $\Theta_1$ is the
null matrix and $\Theta_2$ is scalar.

This integral is equal to $$
\Gamma_p(\alpha){\det(Z)}^{-\alpha} 
{}_1\!F_1\left(\alpha, \beta, \frac{1}{2}\Theta Z^{-1} T \right).
$$
