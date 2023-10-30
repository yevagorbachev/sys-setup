-- MATLAB snippets
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

local cap = function(idx)
	return ls.function_node(function(_, snip)
		return snip.captures[idx]
	end)
end

return {
	s({trig = "uass"}, fmta("<> = <>; % [<>]", {i(1), i(2), i(3)})),
	s({trig = "([%a][_%w]* =)", regTrig = true}, fmta("<><>; % [<>]",
		{cap(1), i(1), i(2)})),
	s({trig = "ulab"}, fmta("\"$<>$ [<>]\"", {i(1), i(2)})),
	s({trig = "fig"}, fmta("figure(\"name\", \"<>\");", {i(1)})),
}
