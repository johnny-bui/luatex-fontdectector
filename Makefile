# makefile

LLT=lualatex -shell-escape #-interaction=batchmode
XLT=lualatex -shell-escape -interaction=batchmode
BUILD=build
TF=texfont

listfontpdf: $(TF)/temp.tex
	cd $(<D) ;\
	$(LLT) $(<F) ;\
	$(LLT) $(<F) ;\
	$(LLT) $(<F) 

quicklist: $(TF)/temp.tex 
	cd $(<D) ;\
	$(LLT) $(<F) 

$(TF)/temp.tex : temp listfont.tex makeline.lua


temp: listfont.tex $(BUILD) $(TF)
	$(LLT) $<

$(BUILD): 
	mkdir -p $@

$(TF):
	mkdir -p $@

clean:
	$(RM) *.aux *.log *.out *.pyc

clean-all: clean
	$(RM) -r $(TF) $(BUILD) *.pdf



