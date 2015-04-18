#!/bin/bash
latex=xelatex
for f in `ls texfont/*.tex` ; do nice -n 20 ${latex} -output-directory=texfont -interaction nonstopmode $f &  done
