#!/usr/bin/env bash

Rscript -e "rmarkdown::render(input='aquameter_plots.Rmd', output_file='index.html')"
