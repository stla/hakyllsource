---
author: Stéphane Laurent
date: '2020-10-21'
highlighter: 'pandoc-solarized'
output:
  html_document:
    highlight: tango
    theme: cosmo
  md_document:
    preserve_yaml: True
    variant: markdown
tags: javascript
title: Formatting code with PhantomJS and CodeMirror
---

Here is some ugly Julia code:

``` {.julia}
function mandelbrot(a)
z = 0
for i=1:50
        z = z^2 + a
    end
return z
end

for y=1.0:-0.05:-1.0
for x=-2.0:0.0315:0.5
abs(mandelbrot(complex(x, y))) < 2 ? print("*") : print(" ")
end
    println()
end
```

We will see how to format it with the help of
[CodeMirror](https://codemirror.net/) and
[PhantomJS](https://phantomjs.org/). The result we will get is:

``` {.julia}
function mandelbrot(a)
  z = 0
  for i=1:50
    z = z^2 + a
  end
  return z
end
for y=1.0:-0.05:-1.0
  for x=-2.0:0.0315:0.5
    abs(mandelbrot(complex(x, y))) < 2 ? print("*") : print(" ")
  end
  println()
end
```

If necessary, install `PhantomJS`. If you are a R user, you can install
it with the help of the 'webdriver' package, by running
`webdriver::install_phantomjs()`.

Now, download these files (these are `CodeMirror` components):

-   [codemirror.js](http://codemirror.net/lib/codemirror.js)
-   [julia.js](http://codemirror.net/mode/julia/julia.js)
-   [formatting.js](http://codemirror.net/2/lib/util/formatting.js)

Below is the `PhantomJS` script. Save it into a file named
**JuliaFormatter.js**.

``` {.js .numberLines}
"use strict";

phantom.onError = function (msg, trace) {
  console.log(msg);
  phantom.exit(1);
};

// read the arguments of the call
var system = require("system");
var args = system.args; // = [script, julia file, indentation size]

// open the Julia file and put its contents in the 'code' variable
var fs = require("fs");
var code = fs.read(args[1]);

// create a page
var page = require("webpage").create();
page.onConsoleMessage = function (str) {
  console.log(str);
};

// main stuff
page.open("about:blank", function (status) {
  if (status === "success") {
    page.content =
      '<html><body><textarea id="editor">' +
      code +
      "</textarea></body></html>";
    if (page.injectJs("codemirror.js")) {
      if (page.injectJs("julia.js")) {
        if (page.injectJs("formatting.js")) {
          page.evaluate(function (tabSize) {
            var editor = CodeMirror.fromTextArea(
              document.getElementById("editor"),
              {
                mode: "julia",
                tabSize: tabSize,
                indentUnit: tabSize
              }
            );
            CodeMirror.commands.selectAll(editor);
            editor.autoFormatRange(
              editor.getCursor(true),
              editor.getCursor(false)
            );
            editor.setCursor(0);
            console.log(editor.getValue());
          }, parseInt(args[2]));
        } else {
          console.error("injectJs failed");
          phantom.exit(1);
        }
      } else {
        console.error("injectJs failed");
        phantom.exit(1);
      }
    } else {
      console.error("injectJs failed");
      phantom.exit(1);
    }
  } else {
    console.error("page.open failed");
    phantom.exit(1);
  }
  phantom.exit(0);
});
```

The script takes two arguments: the file containing the Julia code, say
**mandelbrot.jl**, and an integer, the desired number of spaces of the
indentation. Below is the command to execute it, and the output:

    $ phantomjs JuliaFormatter.js mandelbrot.jl 2
    function mandelbrot(a)
      z = 0
      for i=1:50
        z = z^2 + a
      end
      return z
    end
    for y=1.0:-0.05:-1.0
      for x=-2.0:0.0315:0.5
        abs(mandelbrot(complex(x, y))) < 2 ? print("*") : print(" ")
      end
      println()
    end

`PhantomJS` is a [headless
browser](https://en.wikipedia.org/wiki/Headless_browser):

> A headless browser is a web browser without a graphical user
> interface. Headless browsers provide automated control of a web page
> in an environment similar to popular web browsers, but they are
> executed via a command-line interface or using network communication.
> They are particularly useful for testing web pages as they are able to
> render and **understand HTML the same way a browser would**, including
> styling elements such as page layout, colour, font selection and
> execution of JavaScript and Ajax which are usually not available when
> using other testing methods.

So you can create a HTML element with `PhantomJS`, such as a `textarea`,
and you can get it with `document.getElementById`, exactly as you would
do with a normal browser.

What does the script do:

-   it creates a blank HTML page
-   it fills it with a `textarea` displaying the code contained in the
    Julia file (but nothing is displayed to the user!)
-   it runs JavaScript code using `CodeMirror` to format the code.

`CodeMirror` is a client-side library. It does not allow to format the
code on the JavaScript side exclusively: this code must be rendered in
the browser. This is why one needs a headless browser to use
`CodeMirror` without using a normal browser.

My R package [prettifyAddins](https://github.com/stla/prettifyAddins)
uses this method to format C, C++, Java, Fortran, Julia, Python, SAS,
Scala, Shell, and SQL. There are many other languages supported by
`CodeMirror`.
