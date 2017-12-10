---
title: "Smaller Haskell DLLs"
author: "Stéphane Laurent"
date: "2017-12-10"
output:
  md_document:
    variant: markdown
    preserve_yaml: true
  html_document:
    keep_md: no
prettify: yes
prettifycss: twitter-bootstrap
tags: haskell
highlighter: kate
---

In [another
post](https://laustep.github.io/stlahblog/posts/FloatExpansionHaskell.html),
I give the command line to compile Haskell code to a DLL on Windows:

``` {.bash}
ghc -shared FloatExpansion2.hs StartEnd.c -o FloatExpansion2.dll
```

This can generate a huge DLL. It is possible to get a smaller one.

The above example is not too big: the size of `FloatExpansion2.dll` is
7.6 MB. But let's take this example.

Strip
=====

The GNU `strip` program can make the size of a DLL smaller. This program
is included in the Haskell platform (if you are a R user, it is included
in `Rtools`). The size of `FloatExpansion2.dll` decreases to 4.2 MB when
I run this command:

``` {.bash}
strip -g -S --strip-unneeded -v FloatExpansion2.dll
```

The `upx` program considerably compresses the size of a DLL. However my
Haskell DLLs do not work anymore when I compress them with `upx`.

Module definition file
======================

To get a smaller DLL, you can list the functions you want to export with
the help of a module definition file. For our example, we want to export
the `floatExpansion` function and - don't forget - the `HsStart`
function. To export these functions only, it suffices to list them in a
text file like this:

    EXPORTS
     HsStart
     floatExpansion

and then, assuming this file is named `exports.def`, run the command

``` {.bash}
ghc -shared FloatExpansion2.hs StartEnd.c -o FloatExpansion2.dll exports.def
```

When I do that, the size of `FloatExpansion2.dll` is 7.0 MB. This is not
a big reduction, but I got a considerable reduction for other DLLs.

After that, you can use `strip`. Doing so, the size of
`FloatExpansion2.dll` reduces to 3.5 MB.
