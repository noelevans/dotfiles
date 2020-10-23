if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'sjl/gundo.vim'
" Plug 'alfredodeza/pytest.vim'
" Plug 'jpalardy/vim-slime'      " Copying code to another tmux pane for repl interaction
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
" Plug 'kalekundert/vim-coiled-snake'
" Plug 'xolox/vim-misc'            " Dependency of vim-session
" Plug 'xolox/vim-session'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rrethy/vim-illuminate'
" Plug 'liuchengxu/vista.vim'
" Plug 'majutsushi/tagbar'
Plug 'psf/black', { 'tag': '19.10b0' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'gioele/vim-autoswap'
Plug 'mhinz/vim-grepper'
Plug 'neovim/nvim-lsp'   ", {'do': ':LspInstall pyls_ms'}
Plug 'nvim-lua/completion-nvim'
Plug 'steelsojka/completion-buffers'
Plug 'neomake/neomake'

call plug#end()

filetype on

colorscheme jellybeans

" Sets how many lines of history VIM has to remember
set history=500

" Set to auto read when a file is changed from the outside
set autoread
set autowrite

" Set 4 lines to the cursor - when moving vertically using j/k
set so=4

let $LANG='en'
set langmenu=en

" Turn on the Wild menu
set wildmode=longest,list
set wildmenu

"Always show current position
set ruler
set hidden
set ignorecase
set smartcase
set hlsearch
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets under cursor
set showmatch

" Tenths of second to blink when matching brackets
set mat=2

set noerrorbells
set novisualbell
set t_vb=

set path+=**
set tags=tags
set showcmd
set number
set encoding=utf8
set ffs=unix,dos,mac
set suffixesadd=.py     " Allows you to do 'gf' on config which opens config.py
set expandtab
set shiftwidth=4        " 1 tab == 4 spaces
set tabstop=4
set ai "Auto indent
set wrap "Wrap lines
set clipboard+=unnamedplus
set cursorline

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" hi CursorLine term=bold cterm=bold guibg=Grey40
hi link illuminatedWord Visual

" Enable syntax highlighting
syntax enable

" " Mark lines going past 88 characters
" augroup vimrc_autocmds
"   autocmd BufEnter *.py highlight OverLength ctermbg=darkgrey guibg=#111111
"   autocmd BufEnter *.py match OverLength /\%88v.*/
" augroup END

" autocmd BufWritePre *.py execute ':Black'
" autocmd BufWritePre *.json execute ':%!jq .'

" Backup settings from
" https://begriffs.com/posts/2019-07-19-history-use-vim.html?hn=3

" Protect changes between writes. Default values of
" updatecount (200 keystrokes) and updatetime
" (4 seconds) are fine
set swapfile
set directory^=~/.vim/swap//

" protect against crash-during-write
set writebackup
" but do not persist backup after successful write
set nobackup
" use rename-and-write-new method whenever safe
set backupcopy=auto
" patch required to honor double slash at end
if has("patch-8.1.0251")
    " consolidate the writebackups -- not a big
    " deal either way, since they usually get deleted
    set backupdir^=~/.vim/backup//
end
" persist the undo tree for each file
set undofile
set undodir^=~/.vim/undo//

nnoremap <Left> <c-w>h
nnoremap <Right> <c-w>l
nnoremap <Up> <c-w>k
nnoremap <Down> <c-w>j

augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END


" LSP stuff
lua << EOF
  local nvim_lsp = require'nvim_lsp'
  -- Disable Diagnostcs globally
  vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end

  completion_chain_complete_list = {
    { complete_items = { 'lsp' } },
    { complete_items = { 'buffers' } },
    { mode = { '<c-p>' } },
    { mode = { '<c-n>' } }
  }
EOF

lua require'nvim_lsp'.pyls_ms.setup{on_attach=require'completion'.on_attach}
autocmd BufEnter * lua require'completion'.on_attach()
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
" <c-p> to manually trigger completion
inoremap <silent><expr> <c-p> completion#trigger_completion()
let g:completion_enable_auto_hover = 0

let mapleader="\<Space>"

" :W sudo saves the file
" (useful for handling the permission-denied error)
"command W w !sudo tee % > /dev/null

" The echo comamnd tells you the id of the terminal running in nvim
" You can then use the id to call something like the restart command below
" :echo b:terminal_job_id
:command! Restart call jobsend(1, "\<C-c>npm run server\<CR>")

" Correct spelling error on this line with first dictionary choice
"nnoremap <leader>sp :normal! mf[s1z=`f<cr>
" or...
function! FixLastSpellingError()
    normal! mf[s1z=`f
endfunction
nnoremap <leader>sp :call FixLastSpellingError()<cr>

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
nnoremap <leader>wspace :call TrimWhitespace()<cr>

:command! RunTests call chansend(getmatches("term")[-1]["id"], "python -m pytest tests/<cr>")

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

nnoremap <leader>sop :source %<cr>
" nnoremap <leader>h :set hlsearch!<cr>
nnoremap <leader>h :nohlsearch<cr>
nnoremap <leader>r :%s/<C-r><C-w>//g<Left><Left>
nnoremap <leader>b :ls<CR>:b<Space>
nnoremap <leader>v :vert sfind
" nnoremap <leader>gg :vimgrep // **/*.py \| clist \| call feedkeys(":cc ")<C-R>=setcmdpos(10)<CR><BS>
" nnoremap <leader>gg :Grepper -tool rg -cword -noprompt
nnoremap <leader>gg :GrepperRg <C-R><C-W>
nnoremap <leader>f :FZF -q <C-R><C-W><CR>
nnoremap <leader>cp :let @" = expand("%")<CR>

" nmap <leader>gd :Gvdiffsplit  " (!)
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>nh :GitGutterNextHunk<CR>
nmap <leader>ph :GitGutterPrevHunk<CR>

" Use Ctrl-L for Forward motion when browsing. Ctrl-I == Tab for Vim
nnoremap <C-l> <C-i>

inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

let g:gundo_prefer_python3 = 1

let g:better_whitespace_enabled=1
" let g:strip_whitespace_on_save=1

if has('nvim')
    set inccommand=nosplit
    tnoremap <Esc> <C-\><C-n>
endif

iabbrev pdb import pdb<CR><CR>pdb.set_trace()
iabbrev main_pytest import sys<CR>import pytest<CR><CR>pytest.main(sys.argv)

" let g:airline_section_x = ''
" let g:airline_section_z = ''
let g:airline_theme = 'jellybeans'

let g:neomake_python_enabled_makers=['pylint', 'mypy']
call neomake#configure#automake('w')
