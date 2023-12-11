-- General LaTeX snippets

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node 
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local beg_fmt = [[
\begin{<>}<>
	<>
\end{<>}
]]
local beg_snip = s({trig = "begin", dscr = "Invoke environment"},
	fmta(beg_fmt, {i(1, "environment"), i(2), i(0), rep(1)}))


local tab_fmt = [[ 
\begin{table}[H]
	\centering
	\caption{<>}
	\label{tbl:<>}
	<>
\end{table}
]]
local tab_fmt = s("tab", fmta(tab_fmt, 
	{i(1, "contents"), i(2, "label"), i(3, "contents")}))

local fig_fmt = [[
\begin{figure}[H]
	\centering
	<>
	\caption{<>}
	\label{fig:<>}
\end{figure}
]]

local fig_snip = s("fig", fmta(fig_fmt,
		{i(1, "contents"), i(2, "caption"), i(3, "label")}))

--- linewidth instead of textwidth, becuase textwidth does not play
--- nicely with multicols
local subfig_fmt = [[
\begin{subfigure}{<>\linewidth}
	\centering
	\includegraphics[<>]{<>}
	\caption{<>}
	\label{sfig:<>}
\end{subfigure}
]]

local subfig_snip = s("sub", fmta(subfig_fmt,
	{i(1), i(2, "dimension"), i(3, "file"), i(4, "caption"), i(5, "label")}))


return {
	s({trig = "ff",
		dscr = "Automatic fraction",
		snippetType = "autosnippet",
		wordTrig = true},
		fmta("\\frac{<>}{<>}", {i(1), i(2)})),
	s({trig = "\\9",
		dscr = "Inline equation",
		snippetType = "autosnippet",
		wordTrig = true},
		fmta("\\(<>\\)", {i(1)})),
	s({trig = "inc",
		dscr = "Include graphics"},
		fmta("\\includegraphics[<>]{<>}", {i(1, "dimension"), i(2, "file")})),
	tab_fmt,
	fig_snip,
	subfig_snip,
	beg_snip
}
