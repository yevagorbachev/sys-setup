" Appearance
colo slate
syntax on
hi LineNr ctermfg=grey
set nu rnu " set line and relative line numbers
set incsearch " highlight next result while searching
set hlsearch " highlight search
set laststatus=2 " always display statusline
set scrolloff=10 " leave 10 lines up and down
set tabstop=4 " 4 space tabs
set shiftwidth=4 " 4 space tabs
set textwidth=80 
set guifont=Consolas:h11 

" Mappings
map <Tab> >>
map <S-Tab> <<
noremap j gj
noremap k gk
noremap H g^
noremap L g_
noremap <C-H> (
noremap <C-L> )

" go-to-end versions 
nnoremap Y vg_"ly
nnoremap P vg_"lp
nnoremap D vg_"ld
nnoremap C vg_"lc

noremap <C-j> 10jzz
noremap <C-k> 10kzz
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

vmap F S)i

let mapleader = "\<Space>"
noremap <leader>r "
nnoremap <leader>p "_dp
nnoremap <leader>d :Ex<CR>
nnoremap <leader><leader> za
nnoremap <leader>m :<C-P><CR>
nnoremap <leader>wm :w<CR><leader>m
nnoremap <leader>fi <Esc>80A#<Esc>d80|

nmap <leader><C-c> "+y
nmap <leader><C-v> "+p

let g:netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

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

