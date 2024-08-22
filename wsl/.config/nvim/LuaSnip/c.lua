local ls = require("luasnip")
local snip = ls.snippet
local snip_node = ls.snippet_node 
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local dyn = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local reterr_fmta = [[
if (ret < 0) {
	<>return ret;
}
]]

return {
	snip({trig = "reterr", dscr = "return Zephyr error"}, fmta(reterr_fmta, insert(1), insert(2)))
}
