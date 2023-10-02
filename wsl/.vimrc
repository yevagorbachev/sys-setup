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
set textwidth=80 "11pt Consolas
set guifont=Consolas:h11 "11pt Consolas

" mappings
map <Tab> >>
map <S-Tab> <<
noremap H ^
noremap L $
nnoremap Y v$y
nnoremap P v$p
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" leader mappings
let mapleader = "\<Space>"
nmap <leader>d :Ex<CR>
nmap <leader><leader> za
nmap <leader>m :<C-P><CR>
nmap <leader>wm :w<CR><leader>m
nmap <leader>fi <Esc>80A#<Esc>d80|
" system clipboard commands through leader
nmap <leader><C-c> "+y
nmap <leader><C-x> "+x
nmap <leader><C-v> "+p

let g:netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

filetype on
filetype plugin on
filetype indent on

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

