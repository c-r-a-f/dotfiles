"Initialize---------------------------{{{

if &compatible
    set nocompatible
endif
" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

"-------------------------------------}}}
"dein settings------------------------{{{

" install dein
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.vim') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

" load plugin and  make cache
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/.dein.toml'
let s:toml_file_lazy = fnamemodify(expand('<sfile>'), ':h').'/.dein_lazy.toml'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#load_toml(s:toml_file_lazy, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

" install plugin that not installed
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

"------------------------------------ }}}

"Basic Settings-----------------------------{{{-

syntax on
filetype indent on
filetype plugin indent on
colorscheme monokai
set guifont=Ricty_Diminished:h10
set backspace=indent,eol,start
set background=dark
set modifiable
set foldmethod=marker
set guioptions=
set hidden
set visualbell t_vb=
set clipboard=unnamed
set virtualedit=block
set autoread
set nobackup
set noswapfile
set hlsearch
set ignorecase
set smartcase
set nowrapscan
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set autoindent
set incsearch
set number
set whichwrap=b,s,h,l,<,>,[,]
set wildmenu
set ruler
set laststatus=2
set lsp=2
set mouse=a
set cmdheight=2
set encoding=utf-8
set fileencodings=utf-8,sjis,ucs-bom,iso-2022-jp,cp932,euc-jp,default,latin
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set t_Co=256
set notagbsearch

let NERDTreeShowHidden = 1
let g:nerdtree_tabs_open_on_console_startup = 1
let mapleader = "\<Space>"

"End Basic Settings--------------------------}}}

"Key Mapping---------------------------------{{{

inoremap <silent> jj <ESC>
nnoremap <silent><C-e> :NERDTreeToggle<CR>
nnoremap == gg=G''
noremap <silent> ,a ggVG
noremap <silent> ,v :vsplit<return>
noremap <silent> ,h :split<return>
noremap <silent> <C-k> <C-w>k
noremap <silent> <C-j> <C-w>j
noremap <silent> <C-h> <C-w>h
noremap <silent> <C-l> <C-w>l
noremap <silent> ,prb :b # <return>
nnoremap O :<C-u>call append(expand('.'), '')<Cr>j
nmap s <Plug>(easymotion-s2)
vmap s <Plug>(easymotion-s2)
omap z <Plug>(easymotion-s2)

nmap ,stab :setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2 <return>
nmap ,htab :setlocal noexpandtab <return>

autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent loadview

nmap <Leader>c <Plug>(caw:hatpos:toggle)
vmap <Leader>c <Plug>(caw:hatpos:toggle)

"continuous paste on visual mode
function! Put_text_without_override_register()
  let line_len = strlen(getline('.'))
  execute "normal! `>"
  let col_loc = col('.')
  execute 'normal! gv"_x'
  if line_len == col_loc
    execute 'normal! p'
  else
    execute 'normal! P'
  endif
endfunction
xnoremap <silent> p :call Put_text_without_override_register()<CR>

function! OpenModifiableQF()
  cw
  set modifiable
  set nowrap
endfunction

autocmd QuickfixCmdPost vimgrep call OpenModifiableQF()

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"End Key Mapping ----------------------------}}}

"emmet------------------------------------------

autocmd FileType html,css,scss,php imap <buffer><expr><tab>
    \ emmet#isExpandable() ? "\<plug>(emmet-expand-abbr)" :
    \ "\<tab>"
let g:user_emmet_settings = {
    \    'variables': {
    \      'lang': "ja"
    \    },
    \   'indentation': '  '
    \ }

"yankround---------------------------------------

nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

"openbrowser--------------------------------------

" let g:previm_open_cmd = 'open -a Safari'
nnoremap <silent><Space><Space>p :PrevimOpen<CR>
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

"matchhit--------------------------------------

function! s:set_match_words()
  " Enable these pairs for all file types
  let words = ['(:)', '{:}', '[:]', '（:）', '「:」']
  if exists('b:match_words')
    for w in words
      if b:match_words !~ '\V' . w
        let b:match_words .= ',' . w
      endif
    endfor
  else
    let b:match_words = join(words, ',')
  endif
endfunction
augroup matchit-setting
  autocmd!
  autocmd BufEnter * call s:set_match_words()
augroup END

"matchhit--------------------------------------
let g:multi_cursor_next_key='<C-w>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

"markdown preview -----------------------------
noremap <silent> ,md :PrevimOpen

"neosnippet-------------------------------------
let g:neosnippet#disable_runtime_snippets = {
      \   '_' : 1,
      \ }
