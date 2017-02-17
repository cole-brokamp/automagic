# TODO

- make `get_package_details.R`
- rewrite `deps_file.R` based on package details

# automagic

[![Build Status](https://travis-ci.org/cole-brokamp/automagic.svg?branch=master)](https://travis-ci.org/cole-brokamp/automagic)

> automagically install packages necessary to run R code

### TL;DR

This package parses R code in a given directory for R packages and attempts to install them from CRAN or GitHub. Optionally use a dependencies file for tighter control over which package versions to install. It also contains helper tools for dockerizing an rshiny app and deploying it to an Amazon Web Services Docker Registry.

### Installation  
You can install automagic from GitHub with:
```
devtools::install_github('cole-brokamp/automagic')
```

### Simple Use  
To make sure R has all the required packages before running any R code, just add:
```
automagic::automagic()
``` 
at the top of the R script. `automagic` searches all `.R` and `.Rmd` files in the current working directory (or another user supplied directory) for necessary packages and installs them. In addition to `library()` and `require()`, it knows about `::` and `:::` namespaces. If the package is not on CRAN, it will attempt to install it from GitHub based on a best guess using `githubinstall::gh_suggest()`.

This usage scenario could be useful for sharing R code with users that might not know how to install package dependencies or for deployment of R code that depends on common packages. Note that the package installs required R packages based on a best guess and does not prompt the user.

### Supplying A Dependencies File

It is possible that `automagic` might mistakenly install the wrong package from GitHub or you might need a different version of an R package for the code to work as intended.  In this case, you can create a `.dependencies` file with `automagic::make_deps_file()`. This function parses R code and then queries the R package library to determine the exact source and version of each package to install. Currently, only CRAN and GitHub packages are supported using a version number and Sha1 key, respectively. Although `automagic::automagic()` will first look for a `.dependencies`, you can specify this step directly with `automagic::install_deps_file()`.

This usage scenario is useful when developing R code locally that needs to be deployed on another computer, like a collaborator's machine, a Shiny or RStudio server, a high performance cluster, or docker image.

### Dockerizing an Shiny Application

This package also contains some functions I created to dockerize a shiny application with automagic commands.  Mileage may vary because I've only tested them for personal use.  It creates a docker image for a shiny application starting with my personal R base image, [colebrokamp/shiny](https://hub.docker.com/r/colebrokamp/shiny/) and uses `automagic` tools to ensure all required R packages are available:

```
automagic::shiny_dockerize()
```

This is a wrapper that uses the following intermediate functions to build, test, and view the dockerized shiny application:

- `find_docker_cmd`: finds docker executable on system
- `build_docker_app`: builds the application
- `view_docker_app`: starts the app in a container and opens in RStudio Viewer or browser


Use `push_docker_app` to push the image to [AWS ECR](https://aws.amazon.com/ecr/).
