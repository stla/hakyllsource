---
title: "Avoiding reactivity in a Shiny app"
author: "Stéphane Laurent"
date: '2024-01-29'
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

Sometimes the Shiny reactivity is not desirable. Assume for example the
Shiny app renders a plot and the title of this plot is given by the user
with a text input. So in the Shiny UI you have

``` r
textInput("title", label = "Title"),
plotOutput("ggplot")
```

and in the Shiny server you have

``` r
output[["ggplot"]] <- renderPlot({
  ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
    geom_point() +
    ggtitle(input[["title"]])
})
```

The problem is that a new rendering of the plot will occur whenever the
user types a new character for the title in the text input.

One possibility to avoid this problem is to use an action button to
submit the title, but this is not very convenient.

Another, more convenient possibility is to submit the title whenever the
Enter key is pressed. Here is how to implement this feature. We use
JavaScript to listen to the key press event and if the pressed key is
the Enter key then we send a signal to the Shiny server:

``` js
js <- '
$(document).on("keyup", function(e) {
  if(e.keyCode == 13) {
    Shiny.setInputValue("keyPressed", true, {priority: "event"});
  }
});
'
```

The number 13 is the key code of the Enter key. When it is pressed, the
line `Shiny.setInputValue(...)` is executed. This command sends the
Shiny value `input[["keyPressed"]]` to the Shiny server. Its value is
always `TRUE`. Thanks to the option `priority: "event"`, the Shiny
server will react to `input[["keyPressed"]]` each time it is sent, even
though its value does not change.

To include this JavaScript code in the Shiny app, we have to insert
`tags$script(HTML(js))` in the Shiny UI.

Now, in the Shiny server we define our reactive title:

``` r
Title <- eventReactive(input[["keyPressed"]], {
  input[["title"]]
})
```

and then we code the rendering of the plot as follows:

``` r
output[["ggplot"]] <- renderPlot({
  ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
    geom_point() +
    ggtitle(Title())
})
```
