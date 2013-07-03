doc_prefix=[[
\documentclass[11pt,a4paper]{article}
\usepackage{fontspec}
\usepackage{geometry}
\usepackage{tikz}
\usetikzlibrary{arrows,calc,positioning,shapes.geometric}
\usepackage{layout}
\setcounter{secnumdepth}{-1}
\geometry{
  margin=2cm
}
\usepackage[hidelinks]{hyperref}

\title{%s}
\author{Hong Phuc Bui}
\date{27.\,06.\,2013}

\begin{document}
\setlength{\parindent}{0pt}
\maketitle
\tableofcontents
]]

doc_suffix=[[
\end{document}
]]

subsection_toc = [[
\subsection{%s {\fontspec[Ligatures=TeX,Scale=1]{%s}abc ABC 12340}}
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
    text depth=2ex,
    text width=1.25ex,
    text centered,
    minimum height=.5cm,
    minimum width=1.5cm,
    inner xsep=0.ex,
	inner ysep=1ex,
    %draw=black!50,fill=black!20
    draw=black
  }
]
]]

tikz_suffix = [[
\end{tikzpicture}
]]

text_probe = 
[[Vögel üben Gezwitscher oft ähnlich packend wie Jupp die Maus auf dem Xylophon einer Qualle. 1234567890]]


function contains(t, e)
	for i = 1,#t do
		if t[i] == e then return true end
	end
	return false
end


function str_sort(a, b)
	return string.lower(a) < string.lower(b)
end


function make_probe_text()
	local cmd = [[
\%s{%s}
	]]
	text_size = {"tiny","scriptsize","footnotesize",
	"small", "normalsize", "large", "Large"}
	local text = "\n"
	for _,size in ipairs(text_size)  do
		text = text .. string.format(cmd,size,text_probe) .. "\n"
	end
	return text
end

function makeline(vector, line_length, f)
	local latex_code = tikz_prefix .. "\n"
	f(tikz_prefix)

	local first_line = [[\node[noname] (1)              {\symbol{%04d}\\ \textnormal{\symbol{%04d} \texttt{%02d}}};]]

	local line = string.format(first_line, vector[1], vector[1], vector[1], vector[1])
	
	f(line)
	latex_code = latex_code .. line .. "\n"

	local midle_line = [[\node[noname] (%i) [right=of %i] {\symbol{%04d}\\ \textnormal{\symbol{%04d} \texttt{%02d}}};]]
	local base_line =  [[\draw[help lines,red, -] let \p1 = (%i.base), \p2 = (%i.base) in (-0.5ex,\y1) -- (\x2+1ex,\y1) ;]]
	local below_line = [[\node[noname] (%i) [below=of %i] {\symbol{%04d}\\ \textnormal{\symbol{%04d} \texttt{%02d}}};]]
	local mark = 1
	for i = 2,#vector do
		local c = vector[i]
		if i % line_length == 1 then
			line = string.format(below_line,i, i-line_length,c,c,c)
			f(line)
			latex_code = latex_code .. line .. "\n"
			mark = i
		else
			line = string.format(midle_line,i,i-1,c,c,c)
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
	if #vector % line_length ~= 0 then
		line = string.format(base_line,mark,#vector)
		f(line)
		latex_code = latex_code .. line .. "\n"
	end
	f(tikz_suffix)
	latex_code = latex_code .. tikz_suffix .. "\n"

	return latex_code
end

function make_table(from, to, step, tab)
	for i = from, to, step do
		tab[#tab+1] = i
	end
end

function write_glyphen_test_file(font_family, font_name, tex_file)
	tex_file:write(string.format(doc_prefix,font_family))
	
	
	for _,fn in ipairs(font_name) do
		tex_file:write(string.format([[\section{\fontspec[Ligatures=TeX,Scale=1]{%s}%s}]].."\n",fn,fn))
		local set_font_code = string.format([[\fontspec[Ligatures=TeX,Scale=2]{%s}]] .. "\n", fn)
		tex_file:write(set_font_code)
		
		local latex_code = make_block(0x0021,0x007E,"basic latin")
		tex_file:write(latex_code)
		
		local latex_code = make_block(0x00A1, 0x00FF,"latin supplement")
		tex_file:write(latex_code)

		--local latex_code = make_block(0x0100, 0x017F,"latin extended A")
		--tex_file:write(latex_code)
		
		--local latex_code = make_block(0x0400, 0x04FF,"Cyrillic")
		--tex_file:write(latex_code)
		
		--local latex_code = make_block(0x0500, 0x052F,"Cyrillic Supplement")
		--tex_file:write(latex_code)
		
	end
	tex_file:write(doc_suffix)
end

function make_block(begin_letter, end_letter, name,font_name)
	local block_length = 5
	local line_length = 11
	local begin_block = begin_letter
	local last = begin_block + block_length*line_length -1
	local end_block = (last < end_letter) and last or end_letter
	local latex_code = string.format("\\subsection{%s}\n",name)

	-- print ("end_letter", end_letter)
	while begin_block < end_letter do
		-- print ("begin_block", begin_block,"end_block",end_block)
		local b = {}
		make_table(begin_block, end_block, 1, b)
		latex_code = latex_code .. makeline(b,line_length,function(a) end)

		begin_block = end_block + 1
		last = begin_block + block_length*line_length -1
		-- print ("next last", last)
		end_block = (last < end_letter) and last or end_letter
	end
	return latex_code
end


-- makeline("abcdefghijklmkopqrst",6, print)
