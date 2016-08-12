# automagic

[![Build Status](https://travis-ci.org/cole-brokamp/automagic.svg?branch=master)](https://travis-ci.org/cole-brokamp/automagic)

automagic searches R code for necessary packages and installs them. In addition to `library()` and `require()`, it knows about `::` and `:::` namespaces. If the package is not on CRAN, it will attempt to install it from GitHub.

### Installation  
You can install automagic from GitHub with:
```
devtools::install_github('cole-brokamp/prepaRe')
```

### Use  
To make sure R has all the required packages before running any R code, just add:
```
automagic::automagic()
``` 
at the top of the R script. By default it will search all `.R` and `.Rmd` files in the working directory for necessary packages and install them if they are not available.

### Intermediate Functions  
- `parse_packages`: gathers the package names from all R and R Markdown files in a given directory
- `install_package`: installs package by trying CRAN, then best match on GitHub

### Note
This package was initially created to auto install dependent packages when Dockerizing R Shiny applications, but has also proved useful when running R code on remote computers or sharing R code with users that might not know how to install package dependencies.  Note that the package installs required R packages based on a best guess and does not prompt the user. It is experimental and meant for use in automatically setting up an R programming environment. Do not use for installing packages if you have the option to install with other tools like install.packages or one of the various GitHub installers.


