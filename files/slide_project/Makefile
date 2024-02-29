ifndef $(taget)
	target = slidy
endif

# file information
src = __NAME.md
header = -H header.html

# compilation information
sl = --slide-level=3
mathjax = --mathjax=https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js
deflags = $(sl) $(mathjax) $(header)

all: $(src)
	pandoc -t $(target) -s $(src) $(deflags) $(flags) -o __NAME.html
