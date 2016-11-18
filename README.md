# automagic

[![Build Status](https://travis-ci.org/cole-brokamp/automagic.svg?branch=master)](https://travis-ci.org/cole-brokamp/automagic)

> automagically install packages necessary to run R code

### Installation  
You can install automagic from GitHub with:
```
devtools::install_github('cole-brokamp/automagic')
```

### Use  
To make sure R has all the required packages before running any R code, just add:
```
automagic::automagic()
``` 
at the top of the R script. `automagic` searches all `.R` and `.Rmd` files in the current working directory (or another user supplied directory) for necessary packages and installs them. In addition to `library()` and `require()`, it knows about `::` and `:::` namespaces. If the package is not on CRAN, it will attempt to install it from GitHub based on a best guess using `githubinstall::gh_suggest()`.

This usage scenario could be useful for sharing R code with users that might not know how to install package dependencies or for deployment of R code that depends on common packages. Note that the package installs required R packages based on a best guess and does not prompt the user.

### Supplying A Dependencies File

It is possible that `automagic` might mistakenly install the wrong package from GitHub or you might need a different version of an R package for the code to work as intended.  In this case, you can create a `.dependencies` file with `automagic::make_deps_file()`. This function parses R code and then queries the R package library to determine the exact source and version of each package to install. Currently, only CRAN and GitHub packages are supported using a version number and Sha1 key, respectively. Although `automagic::automagic()` will first look for a `.dependencies`, you can specify this step directly with `automagic::install_deps_file()`.

This usage scenario is useful when developing R code locally that needs to be deployed on another computer, like a collaborator's machine, a Shiny or RStudio server, a high performance cluster, or docker image.

### Intermediate Functions  
- `parse_packages`: gathers the package names from all R and R Markdown files in a given directory
- `install_package`: installs package by trying CRAN, then best match on GitHub

## TODO
- parse the code ala http://adv-r.had.co.nz/Expressions.html#ast-funs
- prompt user before installing packages
- grab externally referenced files?


