---
author: Stéphane Laurent
date: '2020-10-17'
highlighter: 'pandoc-solarized'
output:
  html_document:
    highlight: tango
    theme: cosmo
  md_document:
    preserve_yaml: True
    variant: markdown
tags: 'R, shiny, javascript'
title: A second editor in RStudio
---

Last month, my package
[shinyMonacoEditor](https://github.com/stla/shinyMonacoEditor) has been
published on CRAN. This package provides a code editor as a Shiny app.
It is powered by [Monaco
editor](https://microsoft.github.io/monaco-editor/), an amazing
JavaScript library better known for powering the Microsoft 'VS code'
editor.

![](https://raw.githubusercontent.com/stla/shinyMonacoEditor/master/inst/screenshots/shinyMonacoEditor.gif)
While developing this app I really had fun and I improved my modest
JavaScript skills. It works fine but it is rather a proof of concept.
Indeed, if you want to enjoy the Monaco editor, it is better to use 'VS
code'. Even though `shinyMonacoEditor` makes available some features in
addition to the built-ins features of the Monaco editor, it is not an
essential tool for code development.

Recently I developed two HTML widgets which also are code editors:
[aceEditor](https://github.com/stla/aceEditor) and
[monaco](https://github.com/stla/monaco). They have less features than
`shinyMonacoEditor`, because you cannot communicate with R from a HTML
widget, and you cannot run a system command. For example,
`shinyMonacoEditor` allows to reformat a `C++` file with the help of the
command line utility `clang-format`. Again, this is just a proof of
concept; if you want a tool to prettify some code, I would rather
recommend my package
[prettifyAddins](https://github.com/stla/prettifyAddins) (available on
CRAN).

The HTML widgets are less funny but more practical. They really provide
a second editor in RStudio: you can open them in the viewer pane and
they don't lock RStudio, contrary to a Shiny app.

![](https://raw.githubusercontent.com/stla/monaco/main/inst/screenshots/monacoJS.gif)

The `aceEditor` widget is powered by Ace editor, the JavaScript library
also used by RStudio. It has support for 150 languages (syntax
highlighting and snippets). It provides diagnostics for JavaScript and
CSS but those tools are now quite old and provide false positive errors
for more modern usages. I added the possibility to prettify or reformat
the code for some languages, with the help of
[Prettier](https://prettier.io/).

The `monaco` widget is powered by Monaco editor. It has support for 50
languages, particularly good for JavaScript. I have not submitted it to
CRAN yet. I submitted `aceEditor` last week but there is a more recent
version in my Github repo. If you want to try it now, run:

``` {.r}
remotes::install_github("stla/aceEditor@browsable")
```

The Ace *diff* editor is implemented in this version. It allows to
highlight the differences between two files (if you want a tool to also
*merge* two files, give a try to my other package
[shinyMergely](https://github.com/stla/shinyMergely), available on
CRAN).
