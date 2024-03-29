---
title: "Icons in a Shiny dropdown input"
author: "Stéphane Laurent"
date: '2024-01-04'
tags: R, shiny
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

The function below generates a Shiny dropdown list including some icons.

``` r
library(shiny)
library(fontawesome)
library(htmltools)

selectInputWithIcons <- function(
  inputId, inputLabel, labels, values, icons, iconStyle = NULL,
  selected = NULL, multiple = FALSE, width = NULL
){
  options <- mapply(function(label, value, icon){
    list(
      "label" = label,
      "value" = value,
      "icon"  = as.character(fa_i(icon, style = iconStyle))
    )
  }, labels, values, icons, SIMPLIFY = FALSE, USE.NAMES = FALSE)
  render <- paste0(
    "{",
    "  item: function(item, escape) {", 
    "    return '<span>' + item.icon + '&nbsp;' + escape(item.label) + '</span>';", 
    "  },",
    "  option: function(item, escape) {", 
    "    return '<span>' + escape(item.label) + '</span>';", 
    "  }",
    "}"
  )
  widget <- selectizeInput(
    inputId  = inputId, 
    label    = inputLabel,
    choices  = NULL, 
    selected = selected,
    multiple = multiple,
    width    = width,
    options  = list( 
      "options"    = options,
      "valueField" = "value", 
      "labelField" = "label",
      "render"     = I(render),
      "items"      = as.list(selected)
    )
  )
  attachDependencies(widget, fa_html_dependency(), append = TRUE)
}


ui <- fluidPage(
  br(),
  selectInputWithIcons(
    "slctz",
    "Select an animal:",
    labels    = c("I want a dog", "I want a cat"),
    values    = c("dog", "cat"),
    icons     = c("dog", "cat"),
    iconStyle = "font-size: 3rem; vertical-align: middle;",
    selected  = "cat"
  )
)

server <- function(input, output, session){
  
  observe({
    print(input[["slctz"]])
  })
  
}


shinyApp(ui, server)
```

![](./figures/selectizeWithIcons1.gif)

The other function below has the same purpose, but this one allows to
include some icons in the group headers.

``` r
library(shiny)
library(fontawesome)
library(htmltools)

selectInputWithIcons <- function(
    inputId, inputLabel, 
    groupsizes, labels, values, icons, iconStyle = NULL,
    glabels, gvalues, gicons, giconStyle = NULL,
    selected = NULL, multiple = FALSE, width = NULL
){
  options <- mapply(function(label, value, icon){
    list(
      "label" = label,
      "value" = value,
      "icon"  = as.character(fa_i(icon, style = iconStyle))
    )
  }, labels, values, icons, SIMPLIFY = FALSE, USE.NAMES = FALSE)
  groups <- rep(gvalues, groupsizes)
  for(i in seq_along(options)) {
    options[[i]][["group"]] <- groups[i]
  }
  optgroups <- mapply(function(label, value, icon){
    list(
      "label" = label,
      "value" = value,
      "icon"  = as.character(fa_i(icon, style = giconStyle))
    )
  }, glabels, gvalues, gicons, SIMPLIFY = FALSE, USE.NAMES = FALSE)
  
  render <- paste0(
    "{",
    "  item: function(item, escape) {", 
    "    return '<div class=\"item\">' + item.icon + ",
    "           '&nbsp;' + escape(item.label) + '</div>';",
    "  },",
    "  optgroup_header: function(item, escape) {", 
    "    return '<div class=\"optgroup-header\">' + item.icon + ", 
    "           '&nbsp;' + escape(item.label) + '</div>';",
    "  }",
    "}"
  )
  widget <- selectizeInput(
    inputId  = inputId, 
    label    = inputLabel,
    choices  = NULL, 
    selected = selected,
    multiple = multiple,
    width    = width,
    options  = list( 
      "options"    = options,
      "optgroups"  = optgroups,
      "valueField" = "value", 
      "labelField" = "label",
      "optgroupField" = "group",
      "render"     = I(render),
      "items"     = as.list(selected)
    )
  )
  attachDependencies(widget, fa_html_dependency(), append = TRUE)
}


ui <- fluidPage(
  tags$head(
    tags$style(HTML(".optgroup-header {font-size: 21px !important;}"))
  ),
  br(),
  selectInputWithIcons(
    "slctz",
    "Select something:",
    groupsizes = c(2, 2, 2),
    labels    = c("Drum", "Guitar", "Mouse", "Keyboard", "Hammer", "Screwdriver"),
    values    = c("drum", "guitar", "mouse", "keyboard", "hammer", "screwdriver"),
    icons     = c("drum", "guitar", "computer-mouse", "keyboard", "hammer", "screwdriver"),
    iconStyle = "font-size: 2rem; vertical-align: middle;",
    glabels   = c("Music", "Computer", "Tools"),
    gvalues   = c("music", "computer", "tools"),
    gicons    = c("music", "computer", "toolbox"),
    giconStyle = "font-size: 3rem; vertical-align: middle;",
    selected  = "drum"
  )
)

server <- function(input, output, session){
  
  observe({
    print(input[["slctz"]])
  })
  
}

shinyApp(ui, server)
```

![](./figures/selectizeWithIcons2.gif)
