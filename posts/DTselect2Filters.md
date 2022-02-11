---
author: Stéphane Laurent
date: '2022-02-11'
highlighter: 'pandoc-solarized'
output:
  html_document:
    highlight: kate
    keep_md: no
  md_document:
    preserve_yaml: True
    variant: markdown
rbloggers: yes
tags: 'R, datatables, shiny, javascript'
title: Nice DT filters
---

I am not a big fan of the built-in filters of **DT**. I prefer the ones
below, made with the help of the JavaScript library **select2**.

![](figures/DTselect2Filters.gif)

First, [download](https://cdnjs.com/libraries/select2) the files
**select2.min.js** and **select2.min.css**. Now, here is the code:

``` {.r .numberLines}
library(DT)
library(htmltools)

dat <- iris

sketch <- tags$table(
  tags$thead(
    tags$tr(
      tags$th(), lapply(names(dat), tags$th)
    ),
    tags$tr(
      lapply(c(0, 1:ncol(dat)), function(i) tags$th(id = paste0("th", i)))
    )
  )
)

js <- c(
  "function(){", 
  "  this.api().columns().every(function(i){",
  "    var column = this;",
  "    var $select =",
  "      $('<select multiple=\"multiple\">' +",
  "         '<option value=\"\"></option>' +",
  "      '</select>')",
  "      .appendTo($('#th'+i).empty())", 
  "      .on('change', function(){",
  "        var vals = $('option:selected', this).map(function(idx, element){",
  "          return $.fn.dataTable.util.escapeRegex($(element).val());",
  "        }).toArray().join('|');",
  "        column.search(",
  "          vals.length > 0 ? '^(' + vals + ')$' : '', true, false",
  "        ).draw();",
  "      });",
  "    var data = column.data();",
  "    if(i == 0){",
  "      data.each(function(d, j){",
  "        $select.append('<option value=\"' + d + '\">' + d + '</option>');",
  "      });",
  "    }else{",
  "      data.unique().sort().each(function(d, j){",
  "        $select.append('<option value=\"' + d + '\">' + d + '</option>');",
  "      });",
  "    }",
  "    $select.select2({width: '100%', closeOnSelect: false});",
  "  });",
  "}")

htmlDep <- htmlDependency(
  name = "select2", 
  version = "4.0.13", 
  src = "path/to/select2", # path to the folder containing the 'select2' files 
  script = "select2.min.js", 
  stylesheet = "select2.min.css", 
  all_files = FALSE
)

dtable <- 
  datatable(
    dat, 
    container = sketch, 
    options = list(
      orderCellsTop = TRUE,
      initComplete = JS(js),
      columnDefs = list(
        list(targets = "_all", className = "dt-center")
      )
    )
  )
dtable[["dependencies"]] <- c(dtable[["dependencies"]], list(htmlDep))
dtable
```
