dofile("makeline.lua")
local font_family = "Iwona"
local font_name = {"Iwona-Bold", "Iwona-BoldItalic", "Iwona-Regular", 
"IwonaCond-Bold", "IwonaCond-BoldItalic", "IwonaCond-Italic","IwonaCond-Regular"}
local tex_file = io.open("./texfont/aakar.tex","w")

write_glyphen_test_file(font_family,font_name,tex_file)

tex_file:close()
local cmd = "lualatex -interaction nonstopmode -output-directory=./texfont ./texfont/aakar.tex > /dev/null"
print(cmd)
os.execute(cmd)

