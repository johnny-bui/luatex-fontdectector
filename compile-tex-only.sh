#!/bin/bash
for f in `ls texfont/*.tex` ; do lualatex -output-directory=texfont -interaction nonstopmode $f &  done
