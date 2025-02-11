set expandtab
set textwidth=0

setlocal colorcolumn=100
setlocal foldmethod=expr
setlocal foldexpr=MatlabFold(v:lnum)
setlocal foldtext=MatlabFoldText()
setlocal foldcolumn=4

function! MatlabFold(lnum)
    let key = MatlabFoldKey(a:lnum)
    let starters = ["properties", "methods", "function", "for", "parfor", "if", "switch", "try", "arguments"]

    if key == "classdef"
        return "0"
    elseif (index(starters, key) >= 0)
        return "a1"
    elseif (key == "end")
        return "s1"
    else
        return "="
    endif
endfunction

" return the first word on a line
function! MatlabFoldKey(lnum)
    "currently returns 'end' even if it's in a block comment
    let line = trim(getline(a:lnum))
    if line =~ '^%'
        return "%"
    end

    let words = split(line, '\W\+')
    let firstword = get(words, 0, "%")
    return firstword
endfunction

function! MatlabFoldText()
    let snum = v:foldstart
    let enum = v:foldend
    return repeat("\t", indent(snum)) . trim(getline(snum)) . printf( " (%d lines)", enum - snum + 1)
endfunction
