---
author: Stéphane Laurent
date: '2022-02-03'
highlighter: 'pandoc-solarized'
output:
  html_document:
    keep_md: no
  md_document:
    preserve_yaml: True
    variant: markdown
rbloggers: yes
tags: 'R, misc'
title: Some simple RStudio addins
---

In this blog post I introduce three small **RStudio** addins I did.

'bracketify'
------------

I prefer subsetting with the double brackets than with the dollar in R,
because this is more readable in **RStudio** thanks to the syntax
highlighting. That's why I did
[bracketify](https://github.com/stla/bracketify). This addin replaces
all occurrences of `foo$bar` with `foo[["bar"]]`, either in a whole file
or only in the current selection.

![](https://raw.githubusercontent.com/stla/bracketify/main/inst/screenshots/bracketify.gif)

To use carefully: if you have some dollar symbols in your code which are
not used for subsetting (e.g. in a regular expression), they can be
transformed by **bracketify**.

'pasteAsComment'
----------------

Originally, I made
[pasteAsComment](https://github.com/stla/pasteAsComment) to paste the
content of the clipboard as a comment:

![](https://raw.githubusercontent.com/stla/pasteAsComment/main/inst/screenshots/pasteAsComment.gif){width="75%"}

I updated this package today. Now it also allows to paste the content of
the clipboard as **roxygen** lines. This is particularly useful to write
some code in the `@examples` field:

![](https://raw.githubusercontent.com/stla/pasteAsComment/main/inst/screenshots/pasteAsRoxygen.gif){width="75%"}

'JSconsole'
-----------

[JSconsole](https://github.com/stla/JSconsole) is available on CRAN.
This addin allows to send some selected JavaScript code to the V8
console. This is useful when you want to test a function.

![](https://raw.githubusercontent.com/stla/JSconsole/master/inst/screenshots/JSconsole.gif)
