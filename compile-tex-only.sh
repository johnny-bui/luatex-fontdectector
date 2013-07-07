#!/bin/bash
for f in `ls texfont/*.tex` ; do nice -n 20 lualatex -output-directory=texfont -interaction nonstopmode $f &  done
