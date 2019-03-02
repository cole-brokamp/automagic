library(pkg1)
library("pkg2")
library('pkg3')
library(pkg4); library(pkg5)
library(pkg6, quietly = TRUE)

require(pkg7)
require("pkg8")
require('pkg9', quietly = TRUE)

pkg10::some_function
pkg11:::some_unexported_function

## xfun::pkg_attach(c('pkg12', 'pkg13', 'pkg14'))
## pacman::p_load('pkg15')
