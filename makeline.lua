doc_prefix=[[
\documentclass[11pt,a4paper]{article}
\usepackage{luacode,luaotfload}
\usepackage{fontspec}
\usepackage{geometry}
\usepackage{tikz}
\usetikzlibrary{arrows,calc,positioning,shapes.geometric}
%\usepackage{a4wide}
\usepackage{layout}

\geometry{
  margin=2cm
}
\usepackage{hyperref}

\title{Font-List}
\author{Hong Phuc Bui}
\date{27.06.2013}

\begin{document}
\setlength{\parindent}{0pt}
\maketitle
\tableofcontents
]]

doc_suffix=[[
\end{document}
]]

tikz_prefix = [[
\begin{tikzpicture}[%
  ->,
  very thin, shorten >=1pt,
  >=latex,
  node distance=-0.1pt,
  noname/.style={%
    rectangle, %rounded corners=9pt,
    text height=1em,
    text depth=-1ex,
    text width=1ex,
    text centered,
    minimum height=2.5cm,
    minimum width=2cm,
    inner sep=1.ex,
    %draw=black!50,fill=black!20
    draw=black
  }
]
]]

tikz_suffix = [[
\end{tikzpicture}
]]

function makeline(vector, line_length, f)
	local latex_code = tikz_prefix .. "\n"
	f(tikz_prefix)

	local first_line = [[\node[noname] (1)              {%s\\ \textnormal{%s}};]]

	local line = string.format(first_line,vector[1], vector[1])
	
	f(line)
	latex_code = latex_code .. line .. "\n"

	local midle_line = [[\node[noname] (%i) [right=of %i] {%s\\ \textnormal{%s}};]]
	local base_line =  [[\draw[help lines,red, -] let \p1 = (%i.base), \p2 = (%i.base) in (-0.5ex,\y1) -- (\x2+1ex,\y1) ;]]
	local below_line = [[\node[noname] (%i) [below=of %i] {%s\\ \textnormal{%s}};]]
	local mark = 1
	local i = 0
	for _,c in ipairs(vector) do
		--local c = vector:sub(i,i)
		i = i + 1
		if i ~= 1 then
			if i % line_length == 1 then
				line = string.format(below_line,i, i-line_length,c,c)
				f(line)
				latex_code = latex_code .. line .. "\n"
				mark = i
			else
				line = string.format(midle_line,i,i-1,c,c)
				f(line)
				latex_code = latex_code .. line .. "\n"
			end
			if i % line_length == 0 then
				line = string.format(base_line, i-line_length+1, i)
				f(line)
				latex_code = latex_code .. line .. "\n"
				f("%%%%")
			end
		end
	end
	if #vector % line_length ~= 0 then
		line = string.format(base_line,mark,i)
		f(line)
		latex_code = latex_code .. line .. "\n"
	end
	f(tikz_suffix)
	latex_code = latex_code .. tikz_suffix .. "\n"

	return latex_code
end



-- makeline("abcdefghijklmkopqrst",6, print)
