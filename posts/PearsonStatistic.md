---
author: Stéphane Laurent
date: '2019-07-12'
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
tags: 'maths, statistics'
title: 'The chi-square approximation of Pearson''s statistic'
---

Our goal is to derive the asymptotic distribution of Pearson's statistic
for goodness-of-fit testing. We follow the method given in David
Williams's book *Weighing the odds*, but we provide a bit more details.

Let $Y_1$, $\ldots$, $Y_n$ be independent and identically distibuted
random variables in $\{1, \ldots, b\}$ whose common distribution is
given by $$
\Pr(Y_m = k) = p_k
$$ with $\sum_{k=1}^b p_k = 1$.

Denoting by $N_k$ the number of $Y_m$ equal to $k$, and setting $$
W_k = \frac{N_k - np_k}{\sqrt{np_k}},
$$ the *Pearson statistic* is $\sum_{k=1}^b W_k^2$. To derive its
asymptotic distribution, we firstly derive the one of the random vector
${(W_1, \ldots, W_k)}'$.

Define the random variables $$
X_k^{(m)} = \begin{cases}
1 & \text{if } Y_m = k \\
0 & \text{if } Y_m \neq k
\end{cases},
$$ so that $$
N_k = X_k^{(1)} + \cdots + X_k^{(n)}.
$$

For any $m_1$, $m_2$, the random vectors
$(X_1^{(m_1)}, \ldots, X_b^{(m_1)})$ and
$(X_1^{(m_2)}, \ldots, X_b^{(m_2)})$ have the same distribution. It is
easy to see that $$
\mathbb{E}X_k^{(m)} = p_k, \quad
\mathbb{E}X_k^{(m)}X_\ell^{(m)} = \begin{cases} 
p_k & \text{if } k = \ell \\
0 & \text{if } k \neq \ell
\end{cases},
$$ leading to $$
V_{k\ell} := \text{Cov}\bigl(X_k^{(m)},X_\ell^{(m)}\bigr) = \begin{cases}
p_k(1-p_k) & \text{if } k = \ell \\
-p_k p_\ell & \text{if } k \neq \ell
\end{cases}.
$$

One can write $$
\begin{pmatrix}
N_1 \\ \vdots \\ N_b
\end{pmatrix} = 
\begin{pmatrix}
X_1^{(1)} \\ \vdots \\ X_b^{(1)}
\end{pmatrix} 
+ \cdots +
\begin{pmatrix}
X_1^{(n)} \\ \vdots \\ X_b^{(n)}
\end{pmatrix}.
$$ and this is a sum of independent and identically distributed random
vectors. Therefore we have, for large $n$, $$
\begin{pmatrix}
N_1 \\ \vdots \\ N_b
\end{pmatrix} 
\approx \mathcal{M}\mathcal{N}\left(\begin{pmatrix}
n p_1 \\ \vdots \\ n p_b
\end{pmatrix}, n V\right) 
$$ by the multivariate central limit theorem.

Recall that $$
W_k = \frac{N_k - np_k}{\sqrt{np_k}}.
$$ Then one has $$
\begin{pmatrix}
W_1 \\ \vdots \\ W_b
\end{pmatrix} 
\approx \mathcal{M}\mathcal{N}\left(\begin{pmatrix}
0 \\ \vdots \\ 0
\end{pmatrix}, C\right) 
$$ where $$
C_{k\ell} = \begin{cases}
1-p_k & \text{if } k = \ell \\
-\sqrt{p_k p_\ell} & \text{if } k \neq \ell
\end{cases}.
$$

Now we are going to derive the characteristic function of
$\mathcal{M}\mathcal{N}(\mathbf{0}, C)$.

The covariance matrix $C$ is not a strictly positive definite matrix
since $\sum_{k=1}^b \sqrt{np_k} W_k = 0$. But let us firstly give an
expression of $\mathbb{E}\mathbf{e}^{-\alpha \sum_{k=1}^b W_k^2}$ when
${(W_1, \ldots, W_b)}' \sim \mathcal{M}\mathcal{N}(\mathbf{0}, C)$ in
the case of a strictly positive definite covariance matrix $C$. Then we
will argue that this expression still holds for our $C$. In the strictly
positive case, by using the *pdf* of the multivariate normal
distribuion, we get
\begin{align}
\mathbb{E}\mathbf{e}^{-\alpha \sum_{k=1}^b W_k^2} & = 
\frac{1}{{(2\pi)}^\frac{b}{2}\sqrt{\det(C)}}
\int_{\mathbb{R}^b} \mathbf{e}^{-\frac12\mathbf{w}' 
(C^{-1} + 2 \alpha I)
\mathbf{w}}\mathrm{d}\mathbf{w} \\ 
& = \frac{{\bigl(\det(C^{-1} + 2\alpha I)\bigr)}^{-\frac12}}{\sqrt{\det(C)}} \\ 
& = {\bigl(\det(I+2\alpha C)\bigr)}^{-\frac12}.
\end{align}
Now, by a continuity argument, this equality holds when $C$ is
non-negative definite. Let us detail this point. Let
$\mathbf{W} = {(W_1, \ldots, W_b)}' \sim \mathcal{M}\mathcal{N}(\mathbf{0}, C)$
where $C$ is non-negative and not strictly positive. Let
$\mathbf{G} = {(G_1, \ldots, G_b)}'$ be a standard normal distribution
on $\mathbb{R}^b$ and let $\epsilon > 0$. Then $$
\mathbf{W} + \sqrt{\epsilon}\mathbf{G} \sim 
\mathcal{M}\mathcal{N}(\mathbf{0}, C + \epsilon I),
$$ and since $C + \epsilon I$ is strictly positive, we know by the
previous result that $$
\mathbb{E}\mathbf{e}^{-\alpha \sum_{k=1}^b {(W_k + \sqrt{\epsilon}G_k)}^2} 
= {\Bigl(\det\bigl(I+2\alpha (C+\sqrt{\epsilon}I)\bigr)\Bigr)}^{-\frac12},
$$ and we get the announced result by letting $\epsilon \to 0$.

Thus we have to derive $\det(I+2\alpha C)$ now. Observe that $$
I-C = \mathbf{u} \mathbf{u}'
$$ where $\mathbf{u} = {\bigl(\sqrt{p_1}, \ldots, \sqrt{p_b}\bigr)}'$.
Since $\mathbf{u}' \mathbf{u} = 1$, $$
I-C = \mathbf{u} {\bigl(\mathbf{u}'\mathbf{u})}^{-1} \mathbf{u}'
$$ is the matrix of the orthogonal projection on the line directed by
$\mathbf{u}$, therefore $C$ is the matrix of the orthogonal projection
on ${[\mathbf{u}]}^\perp$.

Thus $C$ has one eigenvalue $0$, with associated eigenvector
$\mathbf{u}$, and $b-1$ eigenvalues equal to $1$. Consequently, for
every real number $\alpha$, the matrix $I + 2\alpha C$ has one
eigenvalue $1$ and $b-1$ others $1+2\alpha$. Therefore $$
\det(I+2\alpha C) = {(1+2\alpha)}^{b-1}.
$$ We finally get $$
\mathbb{E}\mathbf{e}^{-\alpha \sum_{k=1}^b W_k^2} 
\approx {(1+2\alpha)}^{-\frac{b-1}{2}}, 
$$ and we recognize the characteristic function of the $\chi^2_{b-1}$
distribution.
