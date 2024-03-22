if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
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
Plug 'psf/black'    ", { 'tag': '19.10b0' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'gioele/vim-autoswap'
Plug 'mhinz/vim-grepper'
Plug 'kassio/neoterm'
" Plug 'dense-analysis/ale'
Plug 'vim-syntastic/syntastic'
" Plug 'walm/jshint.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-rhubarb'
Plug 'preservim/tagbar'
Plug 'navarasu/onedark.nvim'

call plug#end()

filetype on

colorscheme jellybeans

" Sets how many lines of history VIM has to remember
set history=500

" Set to auto read when a file is changed from the outside
set autoread
set autowrite

" Set 4 lines to the cursor - when moving vertically using j/k
set so=1

let $LANG='en'
set langmenu=en

" Turn on the Wild menu
" set wildmode=longest,list
" set wildmenu

"Always show current position
set ruler
set hidden
set ignorecase
set smartcase
set hlsearch
set nohlsearch
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
" set relativenumber
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
let g:Illuminate_useDeprecated = 1
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
set mouse=
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
:command! -nargs=1 AG GrepperAg <args>
:command! -nargs=1 RG GrepperRg <args>

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>
map Q <Nop>

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
" nnoremap * <silent> *N:let @/.='\C'<CR>n

" nmap <leader>gd :Gvdiffsplit  " (!)
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>nh :GitGutterNextHunk<CR>
nmap <leader>ph :GitGutterPrevHunk<CR>
nmap <leader>sh :GitGutterStageHunk<CR>
nmap <leader>uh :GitGutterUndoHunk<CR>
nmap <leader>cn :cnext<CR>

" Use Ctrl-L for Forward motion when browsing. Ctrl-I == Tab for Vim
nnoremap <C-l> <C-i>

inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

let g:gundo_prefer_python3 = 1

let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

set inccommand=nosplit
tnoremap <Esc> <C-\><C-n>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'   " Overriding Bash's Ctrl-R reverse search

iabbrev pdb breakpoint()
iabbrev bpt breakpoint()
iabbrev main_pytest import sys<CR>import pytest<CR><CR>pytest.main(sys.argv)

" let g:airline_section_x = ''
" let g:airline_section_z = ''
let g:airline_theme = 'jellybeans'

" let g:neomake_python_pylint_maker = {'args': ['-d', 'W']}
" let g:neomake_python_enabled_makers=['pylint', 'mypy']
let g:neomake_javascript_enabled_makers = ['eslint']
" call neomake#configure#automake('w')
let g:neoterm_default_mod='botright'
let g:fzf_layout = {'down':  '40%'}
let black_quiet=1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'

let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['python', 'pep8']
" let g:syntastic_javascript_checkers = ['jslint']
" let g:ale_javascript_eslint_options = "--quiet"

function! RunDjangoTests(test_file, use_make)
    if (match(a:test_file, 'creditqb') == -1 || a:use_make == 0)
        echo "Using Dispatch, value of make: " . a:use_make . ", value of test_file: " . a:test_file
        "let cmd = ":wa! | Dispatch .
        "~/ac/Environments/trialanderror/bin/activate && REUSE_DB=1
        "~/ac/trialanderror/manage.py test
        "-m\"((?:^\|[_.-])(:?[tT]est[s]?\|When\|should))\" " . a:test_file
        ""let cmd = ":wa! | Dispatch . ~/ac/Environments/CreditQB/bin/activate
        && REUSE_DB=1 nosetests -s -m\"((?:^\|[_.-])(:?[tT]est[s]?\|When\|should))\" " . a:test_file
        let cmd = ":wa! | Dispatch REUSE_DB=1 nosetests -s -m\"((?:^\|[_.-])(:?[tT]est[s]?\|When\|should))\" " . a:test_file
    else
        echo "Using Make"
        let cmd = ":wa! | Make " . a:test_file
    end
sleep 3
execute cmd
endfunction

" LSP stuff
set completeopt-=preview
lua << EOF
  -- this is a comment
  --require'lspconfig'.pylyzer.setup{}
  require'lspconfig'.pylsp.setup{
    settings = {
      pylsp = {
        plugins = {
          pyflakes = {enabled = false},
          pylint = {enabled = false},
          mccabe = {enabled = false},
          pydocstyle = {enabled = false},
          pycodestyle = {enabled = false},
        }
      }
    }
  }
  --require'lspconfig'.pyright.setup{}
EOF
