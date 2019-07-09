---
author: Stéphane Laurent
date: '2019-07-09'
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
tags: 'R, shiny'
title: Tiny checkbox for Shiny
---

<style type="text/css">
@-moz-keyframes dothabottomcheck {
  0% {
    height: 0;
  }
  100% {
    height: 5.5px;
  }
}

@-webkit-keyframes dothabottomcheck {
  0% {
    height: 0;
  }
  100% {
    height: 5.5px;
  }
}

@keyframes dothabottomcheck {
  0% {
    height: 0;
  }
  100% {
    height: 5.5px;
  }
}

@keyframes dothatopcheck {
  0% {
    height: 0;
  }
  50% {
    height: 0;
  }
  100% {
    height: 13.2px;
  }
}

@-webkit-keyframes dothatopcheck {
  0% {
    height: 0;
  }
  50% {
    height: 0;
  }
  100% {
    height: 13.2px;
  }
}

@-moz-keyframes dothatopcheck {
  0% {
    height: 0;
  }
  50% {
    height: 0;
  }
  100% {
    height: 13.2px;
  }
}

.check-box-input {
  display: none;
}

.check-box-label {
  cursor: pointer;
  font-weight: normal;
  font-style: oblique;
}

.check-box-container {
  margin-bottom: 10px;
}

.check-box {
  height: 11px;
  width: 11px;
  background-color: #FEF2E0;
  border: 0.73333px solid #19197A;
  border-radius: 5px;
  position: relative;
  display: inline-block;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  -moz-transition: border-color ease 0.2s;
  -o-transition: border-color ease 0.2s;
  -webkit-transition: border-color ease 0.2s;
  transition: border-color ease 0.2s;
  cursor: pointer;
  margin-bottom: -1px;
  margin-right: 2px;
}

.check-box::before, .check-box::after {
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  position: absolute;
  height: 0;
  width: 2.2px;
  background-color: #8B0000;
  display: inline-block;
  -moz-transform-origin: left top;
  -ms-transform-origin: left top;
  -o-transform-origin: left top;
  -webkit-transform-origin: left top;
  transform-origin: left top;
  border-radius: 5px;
  content: ' ';
  -webkit-transition: opacity ease .5;
  -moz-transition: opacity ease .5;
  transition: opacity ease .5;
}

.check-box::before {
  top: 7.92px;
  left: 4.51px;
  -moz-transform: rotate(-135deg);
  -ms-transform: rotate(-135deg);
  -o-transform: rotate(-135deg);
  -webkit-transform: rotate(-135deg);
  transform: rotate(-135deg);
}

.check-box::after {
  top: 4.07px;
  left: 0.55px;
  -moz-transform: rotate(-45deg);
  -ms-transform: rotate(-45deg);
  -o-transform: rotate(-45deg);
  -webkit-transform: rotate(-45deg);
  transform: rotate(-45deg);
}

input[type=checkbox]:checked + .check-box,
input[type=radio]:checked + .check-box,
.check-box.checked {
  border-color: #19197A;
  background-color: #FFFFF0;
}

input[type=checkbox]:checked + .check-box::after,
input[type=radio]:checked + .check-box::after,
.check-box.checked::after {
  height: 5.5px;
  -moz-animation: dothabottomcheck 0.2s ease 0s forwards;
  -o-animation: dothabottomcheck 0.2s ease 0s forwards;
  -webkit-animation: dothabottomcheck 0.2s ease 0s forwards;
  animation: dothabottomcheck 0.2s ease 0s forwards;
}

input[type=checkbox]:checked + .check-box::before,
input[type=radio]:checked + .check-box::before,
.check-box.checked::before {
  height: 13.2px;
  -moz-animation: dothatopcheck 0.4s ease 0s forwards;
  -o-animation: dothatopcheck 0.4s ease 0s forwards;
  -webkit-animation: dothatopcheck 0.4s ease 0s forwards;
  animation: dothatopcheck 0.4s ease 0s forwards;
}

input[type=checkbox][disabled].check-box-input ~ label {
  opacity: 0.65;
  cursor: not-allowed;
}
</style>
<div class="check-box-container" style="display:inline-block">

<input id="mytinycheckbox" type="checkbox" class="check-box-input"/>
<label for="mytinycheckbox" class="check-box" style="margin-right: 0;"></label>
<label for="mytinycheckbox" class="check-box-label"> [Check
me!]{style="color:darkred"} </label>

</div>

Here is how to get this checkbox in Shiny. First, the CSS file:

``` {.css}
@-moz-keyframes dothabottomcheck {
  0% {
    height: 0;
  }
  100% {
    height: 5.5px;
  }
}

@-webkit-keyframes dothabottomcheck {
  0% {
    height: 0;
  }
  100% {
    height: 5.5px;
  }
}

@keyframes dothabottomcheck {
  0% {
    height: 0;
  }
  100% {
    height: 5.5px;
  }
}

@keyframes dothatopcheck {
  0% {
    height: 0;
  }
  50% {
    height: 0;
  }
  100% {
    height: 13.2px;
  }
}

@-webkit-keyframes dothatopcheck {
  0% {
    height: 0;
  }
  50% {
    height: 0;
  }
  100% {
    height: 13.2px;
  }
}

@-moz-keyframes dothatopcheck {
  0% {
    height: 0;
  }
  50% {
    height: 0;
  }
  100% {
    height: 13.2px;
  }
}

.check-box-input {
  display: none;
}

.check-box-label {
  cursor: pointer;
  font-weight: normal;
  font-style: oblique;
}

.check-box-container {
  margin-bottom: 10px;
}

.check-box {
  height: 11px;
  width: 11px;
  background-color: #FEF2E0;
  border: 0.73333px solid #19197A;
  border-radius: 5px;
  position: relative;
  display: inline-block;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  -moz-transition: border-color ease 0.2s;
  -o-transition: border-color ease 0.2s;
  -webkit-transition: border-color ease 0.2s;
  transition: border-color ease 0.2s;
  cursor: pointer;
  margin-bottom: -1px;
  margin-right: 2px;
}

.check-box::before, .check-box::after {
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  position: absolute;
  height: 0;
  width: 2.2px;
  background-color: #8B0000;
  display: inline-block;
  -moz-transform-origin: left top;
  -ms-transform-origin: left top;
  -o-transform-origin: left top;
  -webkit-transform-origin: left top;
  transform-origin: left top;
  border-radius: 5px;
  content: ' ';
  -webkit-transition: opacity ease .5;
  -moz-transition: opacity ease .5;
  transition: opacity ease .5;
}

.check-box::before {
  top: 7.92px;
  left: 4.51px;
  -moz-transform: rotate(-135deg);
  -ms-transform: rotate(-135deg);
  -o-transform: rotate(-135deg);
  -webkit-transform: rotate(-135deg);
  transform: rotate(-135deg);
}

.check-box::after {
  top: 4.07px;
  left: 0.55px;
  -moz-transform: rotate(-45deg);
  -ms-transform: rotate(-45deg);
  -o-transform: rotate(-45deg);
  -webkit-transform: rotate(-45deg);
  transform: rotate(-45deg);
}

input[type=checkbox]:checked + .check-box,
input[type=radio]:checked + .check-box,
.check-box.checked {
  border-color: #19197A;
  background-color: #FFFFF0;
}

input[type=checkbox]:checked + .check-box::after,
input[type=radio]:checked + .check-box::after,
.check-box.checked::after {
  height: 5.5px;
  -moz-animation: dothabottomcheck 0.2s ease 0s forwards;
  -o-animation: dothabottomcheck 0.2s ease 0s forwards;
  -webkit-animation: dothabottomcheck 0.2s ease 0s forwards;
  animation: dothabottomcheck 0.2s ease 0s forwards;
}

input[type=checkbox]:checked + .check-box::before,
input[type=radio]:checked + .check-box::before,
.check-box.checked::before {
  height: 13.2px;
  -moz-animation: dothatopcheck 0.4s ease 0s forwards;
  -o-animation: dothatopcheck 0.4s ease 0s forwards;
  -webkit-animation: dothatopcheck 0.4s ease 0s forwards;
  animation: dothatopcheck 0.4s ease 0s forwards;
}

input[type=checkbox][disabled].check-box-input ~ label {
  opacity: 0.65;
  cursor: not-allowed;
}
```

Now, the Shiny UI, assuming this CSS file is named `check-box.css`:

``` {.r}
ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", 
              href = "check-box.css")
  ),
  div(class = "check-box-container", 
      style = "display:inline-block",
      tags$input(id = "mytinycheckbox", type = "checkbox", 
                 class = "check-box-input"),
      tags$label(`for` = "mytinycheckbox", class = "check-box", 
                 style = "margin-right: 0;"),
      tags$label(`for` = "mytinycheckbox", 
                 tags$span(style="color:darkred", "Check me!"), 
                 class = "check-box-label")
  )
)
```
