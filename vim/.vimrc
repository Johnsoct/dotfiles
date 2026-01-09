" VIM-PLUG BEGIN
noremap <leader>y "+y " enables copying a thing in visual mode to OS clipboard
" VIM-PLUG BEGIN
" VIM-PLUG BEGIN

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'machakann/vim-highlightedyank'
Plug 'posva/vim-vue'
" Themes
Plug 'joshdick/onedark.vim'
Plug 'raphamorim/lucario'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

call plug#end()

" VIM-PLUG END
" VIM-PLUG END
" VIM-PLUG END

" DEFAULT OVERRIDES BEGIN
" DEFAULT OVERRIDES BEGIN
" DEFAULT OVERRIDES BEGIN

set hls ic
syntax enable
set clipboard=unnamedplus
set relativenumber
set re=0

" DEFAULT OVERRIDES END
" DEFAULT OVERRIDES END
" DEFAULT OVERRIDES END

" LINE RULE BEGIN
" LINE RULE BEGIN
" LINE RULE BEGIN

set colorcolumn=100
highlight ColorColumn ctermbg=7 guibg=#898989

" Only show the colorcolumn in the current window
autocmd WinLeave * set colorcolumn=0
autocmd WinEnter * set colorcolumn=+0

" LINE RULE END 
" LINE RULE END 
" LINE RULE END 


" KEYMAPPING BEGIN
" KEYMAPPING BEGIN
" KEYMAPPING BEGIN

let mapleader = " "

" n - mode
" nore - no recursive execution
" map - ... mapping
" <leader>pv - left side of argument, keybind you're creating
" :Vex<CR> - right side of argument, what you're mapping to

" SOURCE CHANGES
nnoremap <leader><cr> :so ~/.vimrc<cr>

" MOVEMENT
nnoremap j jzz
nnoremap k kzz

" EXIT WHILE INSERTING
inoremap <C-c> <esc>

" FILE EXPLORER
nnoremap <leader>pv :Vex<CR>

" SOURCE CONFIG
nnoremap <leader><CR> :so ~/.vimrc<CR>

" FZF
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :GFiles?<CR>
 
" GREP/RIPGREP
nnoremap <leader>rg :Rg<Space>

" QUICKFIX
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR>

" CLIPBOARD MAGIC (assumes set clipboard!=unnamed)
nnoremap <leader>y "+y " enables copying the result of complex motions to the OS clipboard
vnoremap <leader>y "+y " enables copying a thing in visual mode to OS clipboard
nnoremap <leader>Y gg"+yG " copies the entire file

" LINE MANIPULATION
vnoremap J :m '>+1<CR>gv=gv " moves selected code down one line
vnoremap K :m '<-2<CR>gv=gv " moves selected code up one line

" Explanation for line manipulation keymaps:
" '> is the beginning of a highlighted region
" '< is the end of a highlighted region
" :m is performing a move of the selected region to outside of the highlighted
" press enter, then highlight my previous highlight (gv=gv)

" KEYMAPPING END 
" KEYMAPPING END 
" KEYMAPPING END 
