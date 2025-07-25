" Vim filetype plugin file
" Language:	matlab
" Maintainer:	Fabrice Guy <fabrice.guy at gmail dot com>
" Modified:	    Yevgeniy Gorbachev 
" Last Changed: 2025 July 25

if exists("b:did_matlab")
  finish
endif
let b:did_matlab = 1

let s:save_cpo = &cpo
set cpo-=C

setlocal fo+=croql
setlocal comments=:%>,:%

if exists("loaded_matchit")
  let s:conditionalEnd = '\([-+{\*\:(\/]\s*\)\@<!\<end\>\(\s*[-+}\:\*\/)]\)\@!'
  let b:match_words = '\<classdef\>\|\<methods\>\|\<events\>\|\<properties\>\|\<if\>\|\<while\>\|\<for\>\|\<switch\>\|\<try\>\|\<function\>:' . s:conditionalEnd
endif

setlocal suffixesadd=.m
setlocal suffixes+=.asv
" Change the :browse e filter to primarily show M-files
if has("gui_win32") && !exists("b:browsefilter")
  let  b:browsefilter="M-files (*.m)\t*.m\n" .
	\ "All files (*.*)\t*.*\n"
endif

let b:undo_ftplugin = "setlocal suffixesadd< suffixes< "
      \ . "| unlet! b:browsefilter"
      \ . "| unlet! b:match_words"

let &cpo = s:save_cpo

set expandtab
set textwidth=0

" FOLDING 
setlocal colorcolumn=100
setlocal foldmethod=expr
setlocal foldexpr=MatlabFold(v:lnum)
setlocal foldtext=MatlabFoldText()
setlocal foldcolumn=4

function! MatlabFold(lnum)
    let key = MatlabFoldKey(a:lnum)
    let starters = ["properties", "methods", "function", "for", "parfor", "if", "switch", "try", "arguments", "while"]

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

" LINTING
let g:mlint_path = '"C:\\Program Files\\MATLAB\\R2024b\\bin\\win64\\mlint.exe"'

let &l:makeprg = g:mlint_path . ' "%" -id'
let &l:errorformat = "L %l (C %c): %m," .
            \ "L %l (C %c-%k): %m,"
            \ "-%-G%.%#"

function! Mlint()
    silent make
    cwindow
endfunction

:command Mlint call Mlint()
