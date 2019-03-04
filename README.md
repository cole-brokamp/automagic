<h1>automagic<img src='automagic.png' align='right'></h1>

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/automagic)](https://cran.r-project.org/package=automagic)
[![DOI](https://zenodo.org/badge/65520853.svg)](https://zenodo.org/badge/latestdoi/65520853)
[![Build Status](https://travis-ci.org/cole-brokamp/automagic.svg?branch=master)](https://travis-ci.org/cole-brokamp/automagic)
![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/automagic?color=orange)

Parse R code for required packages and install them. Optionally control which package versions to install using a `deps.yaml` file that can be created manually or automatically created based on a directory of R source files and the versions and sources of packages found in the local R library.

## Installation

Install the latest stable version (0.3) from CRAN with `install.packages('automagic')`.  
Install the latest development version from GitHub with `remotes::install_github('cole-brokamp/automagic')`.

## Using

### With A Dependencies File

It is possible that `automagic` might mistakenly install the wrong package from GitHub or you might need a different version of an R package for the code to work as intended.  In this case, you can create a `deps.yaml` file with `automagic::make_deps_file()`. This function parses R code and then queries the local R package libraries to determine the exact source and version of each package to install. Currently, only CRAN and GitHub packages are supported. 

An example `deps.yaml` file looks like

```yaml
- Package: CB
  GithubUsername: cole-brokamp
  GithubRepo: CB
  GithubRef: master
  GithubSHA1: 0a56eadaf4282678c949bc8eedaacb5d6e0777fe
- Package: remotes
  Repository: CRAN
  Version: 1.0.0
```

The dependencies file could also be created or changed manually if necessary. For example, you could create a list of packages that you frequently depend on and when moving to a new machine or server, run `automagic::automagic()` to install them all.

### Without A Dependencies File

To make sure R has all the required packages before running any R code, run `automagic::automagic()`. If there is no `deps.yaml` file present, `automagic` searches all `.R` and `.Rmd` files in the current working directory for necessary packages and creates a `deps.yaml` file. Review this file to see what packages will be installed and rerun `automagic::automagic()` to install all packages in the file.

## Details

### GitHub Installation

GitHub packages are installed using the `remotes` package. Set the environment variable `GITHUB_PAT` to supply a personal access token (PAT) to install a package from a private repository or to increase the limit of calls to the GitHub API during installation of a large number of packages.

### Shiny Applications

See [https://github.com/cole-brokamp/rize](https://github.com/cole-brokamp/rize) for robust method of dockerizing Shiny applications within R.  `rize` utilizes `automagic` for documenting and installing the packages that are needed to run the R Shiny app in a Docker container.
