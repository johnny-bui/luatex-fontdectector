# makefile

LLT=lualatex -shell-escape #-interaction=batchmode
XLT=lualatex -shell-escape -interaction=batchmode
BUILD=build
TF=texfont

listfontpdf: $(TF)/temp.tex
	$(LLT) -output-directory $(BUILD) $(<)
	$(LLT) -output-directory $(BUILD) $(<)
	$(LLT) -output-directory $(BUILD) $(<)


temp: listfont.tex $(BUILD) $(TF)
	$(LLT) $<

$(BUILD): 
	mkdir -p $@

$(TF):
	mkdir -p $@

clean:
	$(RM) *.aux *.log *.out *.pyc

clean-all:
	$(RM) -r $(TF) $(BUILD) *.pdf



