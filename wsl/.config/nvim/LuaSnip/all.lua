local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node 
local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local d = ls.dynamic_node
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local rep = require("luasnip.extras").rep

-- local aus = function (trigger, text)
-- 	return s({trig = trigger, snippetType = "autosnippet"}, {t(text)})
-- end

return {
	-- aus(";a", "\\alpha")
	s({trig = ";a", snippetType = "autosnippet"}, {t("\\alpha")}),
	s({trig = "testtrig"}, {t("longer test string")})
}
