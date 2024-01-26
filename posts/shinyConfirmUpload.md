---
title: "Confirmation dialog in a Shiny app"
author: "Stéphane Laurent"
date: '2024-01-26'
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

Assume you have a Shiny app allowing to upload a data file and to
perform various operations on the uploaded data. Now, if the user
uploads a new file, the current state of the app is lost, and you want
to warn the user about that. Here is a way using the amazing JavaScript
library **sweetalert2**.

The JavaScript code below must be saved in a file, say ***confirm.js***,
in the ***www*** subfolder of the app.

``` js
$(document).ready(function() {
  var upload = false;
  $("#upload").on("click", async function(event) {
    if(!upload) {
      upload = true;
      return true;
    }
    event.preventDefault();
    const { value: yes } = await Swal.fire({
      title: "Really upload a new file?",
      text: "If you do so, the current state of the app will be lost.",
      showDenyButton: true,
      confirmButtonText: "Yes",
      denyButtonText: "No"
    });
    if(yes) {
      upload = false;
      $("#upload").click();
    }
  });
});
```

Now, here is the Shiny app. It does nothing, I just provide it for the
illustration.

``` r
library(shiny)

ui <- fluidPage(
  tags$head(
    tags$script(src = "https://cdn.jsdelivr.net/npm/sweetalert2@11.10.0/dist/sweetalert2.all.min.js"),
    tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/sweetalert2@11.10.0/dist/sweetalert2.min.css"),
    tags$script(src = "confirm.js")
  ),
  br(),
  fileInput("upload", "Upload")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
```

![](./figures/shinyConfirmUpload.gif)
