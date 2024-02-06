" Appearance
colo slate
syntax on
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
set guifont=Consolas:h12 

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
nnoremap Y vg_"ly
nnoremap P vg_"lp
nnoremap D vg_"ld
nnoremap C vg_"lc

" Line editing
" J/K got remapped, need new ones
noremap <C-j> J 
noremap <C-k> K
" move the highlighted lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Entering insert mode after surround keybind starts typing
" shorthand to surround and make function
vmap <C-f> S)i

let mapleader = "\<Space>"
noremap <leader>r "
nnoremap <leader>p "_dp
nnoremap <leader>d :Ex<CR>
nnoremap <leader><leader> za
nnoremap <leader>m :<C-P><CR>
nnoremap <leader>wm :w<CR><leader>m
nnoremap <leader>fi <Esc>80A#<Esc>d80|
nnoremap <leader>s :e ~/scratchpad<CR>

nmap <leader><C-y> "+y
nmap <leader><C-v> "+p
" inoremap <C-v> <C-r>+

let g:netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

let s:netrw_hide_ext = ["aux", "dvi", "fdb_latexmk", "fls", "log", "toc", "out"] 

let g:netrw_list_hide = ""
for s in s:netrw_hide_ext
	let g:netrw_list_hide .= ".*\." . s . ","
endfor

filetype on
filetype plugin on
filetype indent on

au BufNewFile,BufRead *.m set expandtab
au BufNewFile,BufRead *.m set tw=0

" make the clipboard work
" taken from Neovim docs
let g:clipboard = {
			\   'name': 'WslClipboard',
			\   'copy': {
			\      '+': 'clip.exe',
			\      '*': 'clip.exe',
			\    },
			\   'paste': {
			\      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			\      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			\   },
			\   'cache_enabled': 0,
			\ }

