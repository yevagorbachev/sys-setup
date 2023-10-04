all:
	latexmk -pdf -shell-escape -halt-on-error __NAME.tex
clean:
	latexmk -c
	rm -f *eps-converted-to.pdf
	rm -f **/*eps-converted-to.pdf
