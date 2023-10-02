-- LaTeX snippets

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local aus = function (trigger, text)
	return s({trig = trigger, snippetType = "autosnippet"}, {t(text)})
end

local alphatable = {
	a = "\\alpha",
	b = "\\beta",
	g = "\\gamma",
	d = "\\delta",
	e = "\\epsilon",
	ve = "\\varepsilon",
	z = "\\zeta",
	h = "\\eta",
	th = "\\theta",
	i = "\\iota",
	k = "\\kappa",
	l = "\\lambda",
	m = "\\mu",
	n = "\\nu",
	x = "\\xi",
	o = "\\omicron",
	p = "\\pi",
	r = "\\rho",
	s = "\\sigma",
	ta = "\\tau",
	u = "\\upsilon",
	f = "\\phi",
	c = "\\chi",
	y = "\\psi",
	w = "\\omega",
	G = "\\Gamma",
	D = "\\Delta",
	Th = "\\Theta",
	L = "\\Lambda",
	X = "\\Xi",
	P = "\\Pi",
	S = "\\Sigma",
	F = "\\Phi",
	Y = "\\Psi",
	W = "\\Omega",
}

local prefixsnips = function(prefix, tab)
	local snips = {}
	for trig, text in pairs(tab) do
		snips[#snips+1] = aus(prefix .. trig, text)
	end
	return snips
end

return prefixsnips(";", alphatable)
