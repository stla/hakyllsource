---
title: "Tooltips for a dropdown list in Shiny"
author: "Stéphane Laurent"
date: '2023-05-13'
tags: R, shiny, JavaScript
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

Here is how to have some tooltips for the options and their headers of a
`selectizeInput` in Shiny.

``` r
library(shiny)

ui <- fluidPage(
  selectizeInput(
    inputId = "selectAnimals",
    label = "Select some animals",
    choices = NULL,
    multiple = TRUE,
    options = list(
      options = list(
        list(
          species = "mammal", value = "dog", name = "Dog", 
          tooltip = "it's a pet"
        ),
        list(
          species = "mammal", value = "cat", name = "Cat", 
          tooltip = "another pet"
        ),
        list(
          species = "mammal", value = "kangaroo", name = "Kangaroo",
          tooltip = "it jumps"
        ),
        list(
          species = "bird", value = "duck", name = "Duck",
          tooltip = "like Donald"
        ),
        list(
          species = "bird", value = "ostrich", name = "Ostrich",
          tooltip = "very tasty"
        ),
        list(
          species = "bird", value = "seagull", name = "Seagull",
          tooltip = "it's a seabird"
        ),
        list(
          species = "reptile", value = "snake", name = "Snake",
          tooltip = "it has no leg"
        ),
        list(
          species = "reptile", value = "lizard", name = "Lizard",
          tooltip = "mainly carnivorous"
        ),
        list(
          species = "reptile", value = "turtle", name = "Turtle",
          tooltip = "it is slow"
        )
      ),
      optgroups = list(
        list(
          value = "mammal",  label = "Mammal",  tooltip = "like us"
        ),
        list(
          value = "bird",    label = "Bird",    tooltip = "they fly"
        ),
        list(
          value = "reptile", label = "Reptile", tooltip = "not only snakes"
        )
      ),
      optgroupField = "species",
      labelField = "name",
      render = I(
        "{
          optgroup_header: function(data, escape) {
            return '<div class=\"optgroup-header\"><span ' + 
              'title=\"' + data.tooltip + '\">' + escape(data.label) + 
              '</span></div>';
          },
          option: function(data, escape) {
            return '<div class=\"option\"><span ' + 
              title=\"' + data.tooltip + '\">' + escape(data.name) + 
              '</span></div>';
          }
        }"
      )
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

It's also possible to have Bootstrap tooltips. They are prettier, and
customizable. To do so, replace the `render` option with the following
one (that could differ if you use Bootstrap 5) and add this
`onDropdownOpen` option and this `onChange` options to initialize them
or reinitialize them:

``` r
render = I(
  "{
    optgroup_header: function(data, escape) {
      return '<div class=\"optgroup-header\"><span ' + 
        'data-toggle=\"tooltip\" data-placement=\"right\" title=\"' + 
        data.tooltip + '\">' + escape(data.label) + '</span></div>';
    },
    option: function(data, escape) {
      return '<div class=\"option\"><span ' + 
        'data-toggle=\"tooltip\" data-placement=\"top\" title=\"' + 
        data.tooltip + '\">' + escape(data.name) + '</span></div>';
    }
  }"
),
onDropdownOpen = I(
  "function() {
     setTimeout(function(){$('[data-toggle=tooltip]').tooltip();}, 100);
  }"
),
onChange = I(
  "function() {
     setTimeout(function(){$('[data-toggle=tooltip]').tooltip();}, 100);
  }"
)
```

![](./figures/selectizeTooltips.gif)
