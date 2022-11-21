SOURCE = main
OUT_DIR = ./temp
LATEX_CMD = latex -output-format='pdf' -output-directory=$(OUT_DIR) $(SOURCE).tex -no-shell-escape

draw_src = $(shell find ./figure/ -type f -name "*.draw.svg")
draw_target = $(draw_src:./figure/%.draw.svg=./figure/%.draw.png)
#https://unix.stackexchange.com/questions/140912/no-target-error-using-make


./$(OUT_DIR)/$(SOURCE).aux: $(SOURCE).tex ./texContent/* $(draw_target)
	$(LATEX_CMD)
	bibtex ./$(OUT_DIR)/$(SOURCE)
	bib2gls ./$(OUT_DIR)/$(SOURCE)
	$(LATEX_CMD)
	$(LATEX_CMD)
	mv ./temp/main.pdf ./main.pdf

./figure/%.draw.png: ./figure/%.draw.svg
	inkscape --export-area-drawing --export-dpi=300 --export-png=$@ $<

clean:
	find . -name '*.aux' -delete

reset:
	make clean
	rm -f $(SOURCE).pdf
	find . -name '*.log' -delete
	find . -name '*.fls' -delete
	find . -name '*.fdb_latexmk' -delete
	find . -name '*.blg' -delete
	find . -name '*.ist' -delete
	find . -name '*.loc' -delete
	find . -name '*.bbl' -delete
	find . -name '*.lot' -delete
	find . -name '*.synctex.gz' -delete
	find . -name '*.toc' -delete
	find . -name '*.gls' -delete
	find . -name '*.acn' -delete
	find . -name '*.glo' -delete
	find . -name '*.glg' -delete
	find . -name '*.bak' -delete
