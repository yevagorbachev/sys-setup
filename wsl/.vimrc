" Appearance
set background=dark
colorscheme icebergcustom

hi LineNr ctermfg=grey
set nohidden
set nu rnu " set line and relative line numbers
set incsearch " highlight next result while searching
set hlsearch " highlight search
set laststatus=2 " always display statusline
set scrolloff=100 " leave 10 lines up and down
set tabstop=4 " 4 space tabs
set shiftwidth=4 " 4 space tabs
set textwidth=80
set guifont=Consolas:h16
set backspace=indent,eol,start

map <Tab> >>
map <S-Tab> <<

" Movement redesign
noremap j gj
noremap k gk
" shifted versions of HJKL do the same thing but MORE
noremap H g^
noremap L g_
" makes more sense to me than ^ _ 0 $ C-d C-u
noremap J 10j
noremap K 10k
noremap <C-H> (
noremap <C-L> )

" go-to-end versions 
" TODO rework to behave less wierd around the end of line
nnoremap D dg_
vnoremap D "_d

" Line editing
" J/K got remapped, need new ones
noremap <C-j> J 
noremap <C-k> K
" move the highlighted lines
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

let mapleader = "\<Space>"
noremap <leader>r "
nnoremap <leader>p "_dp
nnoremap <leader>d :Ex<CR>
nnoremap <leader><leader> za

vnoremap <leader>y "+y
vnoremap <leader>p "+P

nnoremap <leader>* *:%s//

vmap <C-f> S)i

let g:netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

let s:netrw_hide_ext = ["aux", "dvi", "fdb_latexmk", "fls", "log", "toc", "out"] 

let g:netrw_list_hide = ""
for s in s:netrw_hide_ext
	let g:netrw_list_hide .= ".*\." . s . ","
endfor

filetype on
filetype plugin on
filetype indent on
syntax on

packadd! matchit

augroup todo
    au!
    au Syntax * syn match MyTodo /\v<(FIXME|NOTE|TODO|XXX):?/
          \ containedin=.*Comment,vimCommentTitle
augroup END

hi def link MyTodo Todo
