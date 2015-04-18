A LaTeX script to dedect fonts in a (linux) system, which can be used in
luaLaTeX. 

First time I learn lua.


To get a list of all fonts in System:

	$ mkdir texfont
	$ lualatex listfont.tex # generate other tex file
	$ lualatex -output-directory build texfont/temp.tex # compile the generated file
	$ lualatex -output-directory build texfont/temp.tex # re-compile the generate file to get table of contents in aux-file
	$ lualatex -output-directory build texfont/temp.tex # re-compile to get the correct table of contents

To get font-table of a font:
	
	$ lualatex texfont/<fontname>.tex # three times

To get font-table of all fonts in the system:
	
	$ python compile-tex-only.py

