" Modeline and Notes {
" vim: set sw=3 ts=3 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
" }

" Use local before if available {
if filereadable(expand("~/.vimrc.before.local"))
   source ~/.vimrc.before.local
endif
" }

" Environment {

" Basics {
if !(has('win16') || has('win32') || has('win64'))
   set shell=/bin/sh
endif
" }

" Windows Compatible {
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
   set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif
" }

" Setup Bundle Support {
" The next three lines ensure that the ~/.vim/bundle/ system works
filetype on
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
" }

" }

" Bundles {

" Use local bundles if available {
if filereadable(expand("~/.vimrc.bundles.local"))
   source ~/.vimrc.bundles.local
endif
" }

" Use bundles config {
if filereadable(expand("~/.vimrc.bundles"))
   source ~/.vimrc.bundles
endif
" }

" }

" General {

set background=dark " Assume a dark background
if !has('gui')
   "set term=$TERM " Make arrow and other keys work
endif
filetype plugin indent on " Automatically detect file types.
syntax on " Syntax highlighting
"set mouse=a " Automatically enable mouse usage
set mousehide " Hide the mouse cursor while typing
scriptencoding utf-8

if has ('x') && has ('gui') " On Linux use + register for copy-paste
   set clipboard=unnamedplus
elseif has ('gui') " On mac and Windows, use * register for copy-paste
   set clipboard=unnamed
endif

" Most prefer to automatically switch to the current file directory when
" a new buffer is opened
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

au FocusLost * :silent! wall                 " Save on FocusLost
au FocusLost * call feedkeys("\<C-\>\<C-n>") " Return to normal mode
set shortmess+=filmnrxoOtT " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore " Allow for cursor beyond last character
set history=1000 " Store a ton of history (default is 20)
"set spell " "Spell checking on"""
set hidden " Allow buffer switching without saving

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Setting up the directories {
set backup " Backups are nice ...
if has('persistent_undo')
   set undofile " So is persistent undo ...
   set undolevels=1000 " Maximum number of changes that can be undone
   set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
endif

" Add exclusions to mkview and loadview
" eg: *.*, svn-commit.tmp
let g:skipview_files = [
        \ '\[example pattern\]'
        \ ]
" }

" }

" Vim UI {

" Choose a colorscheme
if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
   let g:solarized_termcolors=256
   let g:solarized_termtrans=1
   let g:solarized_contrast="high"
   let g:solarized_visibility="high"
   color solarized " Load a colorscheme
endif

set tabpagemax=15 " Only show 15 tabs
set showmode " Display the current mode

" Highlight the current cursor line and column
augroup CursorLine
   au!
   au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
   au VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
   au WinLeave * setlocal nocursorline
   au WinLeave * setlocal nocursorcolumn
augroup END

set cc=80 " Make a column at line 80

au VimResized * :wincmd=
au WinEnter   * :set winfixheight
au WinEnter   * :wincmd=
au WinEnter   * :setlocal number
au WinLeave   * :setlocal nonumber

highlight clear SignColumn " SignColumn should match background for
" things like vim-gitgutter

highlight clear LineNr " Current line number row will have same background color in relative mode.

if has('cmdline_info')
   set ruler " Show the ruler
   set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
   set showcmd " Show partial commands in status line and
   " Selected characters/lines in visual mode
endif

if has('statusline')
   set laststatus=2

   " Broken down into easily includeable segments
   set statusline=%<%f\ " Filename
   set statusline+=%w%h%m%r " Options
   set statusline+=%{fugitive#statusline()} " Git Hotness
   set statusline+=\ [%{&ff}/%Y] " Filetype
   set statusline+=\ [%{getcwd()}] " Current dir
   set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info
endif

set backspace=indent,eol,start " Backspace for dummies
set linespace=0 " No extra spaces between rows
set nu " Line numbers on
set showmatch " Show matching brackets/parenthesis
set incsearch " Find as you type search
set hlsearch " Highlight search terms
set lazyredraw " Don't redraw the screen in macros
set winminheight=0 " Windows can be 0 line high
set ignorecase " Case insensitive search
set smartcase " Case sensitive when uc present
set wildmenu " Show list instead of just completing
set wildmode=list:longest,full " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,] " Backspace and cursor keys wrap too
set scrolljump=5 " Lines to scroll when cursor leaves screen
set scrolloff=5 " Minimum lines to keep above and below cursor
set foldenable " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {

set wrap " Wrap long lines
set textwidth=79 " Sets the line to wrap on
set formatoptions=qrnl
set gdefault
set autoindent " Indent at the same level of the previous line
set shiftwidth=3 " Use indents of 3 spaces
set expandtab " Tabs are spaces, not tabs
set tabstop=3 " An indentation every three columns
set softtabstop=3 " Let backspace delete indent
set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current
"set matchpairs+=<:> " Match, to be used with %
set encoding=utf8
set autoread " Autoread the buffer
set autowrite " Autowrite the buffer
" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,go,php,javascript,python,twig,verilog_systemverilog,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd FileType haskell setlocal expandtab shiftwidth=2 softtabstop=2

" }


" Key (re)Mappings {

let mapleader = ','

" Quick save/quit
nmap <leader>w :w<CR>

" Use arrow keys to move lines around
nnoremap <Down> :m+<CR>==
nnoremap <Up> :m-2<CR>==
vnoremap <Down> :m '>+1<CR>gv=gv
vnoremap <Up> :m '<-2<CR>gv=gv

" Move words
nnoremap <Left>  "_yiw?\v\w+\_W+%#<CR>:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o><C-l>
nnoremap <Right> "_yiw:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o>/\v\w+\_W+<CR><C-l>


" Easier moving in tabs and windows
" The lines conflict with the default digraph mapping of <C-K>
"map <C-J> <C-W>j<C-W>_
"map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_

" prevent fat fingering F1
map f1 <Esc>

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" <Ctrl-l> to insert a <=
inoremap <C-l> <Space><=<Space>

" Esc avoidance
imap jj <Esc>

" Map . to reset to the original cursor position when complete
" This makes use of marks to the letter 'q'
"noremap . mq.`q

" The following two lines conflict with moving to top and
" bottom of the screen
"map <S-H> gT
"map <S-L> gt

" Stupid shift key fixes
if has("user_commands")
   command! -bang -nargs=* -complete=file E e<bang> <args>
   command! -bang -nargs=* -complete=file W w<bang> <args>
   command! -bang -nargs=* -complete=file Wq wq<bang> <args>
   command! -bang -nargs=* -complete=file WQ wq<bang> <args>
   command! -bang Wa wa<bang>
   command! -bang WA wa<bang>
   command! -bang Q q<bang>
   command! -bang QA qa<bang>
   command! -bang Qa qa<bang>
endif

cmap Tabe tabe

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
" Map ; to :
nnoremap ; :
vnoremap ; :

" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" Splitting
" window
nmap <leader>swl :topleft  vnew<CR>
nmap <leader>swh :botright vnew<CR>
nmap <leader>swk :topleft  new<CR>
nmap <leader>swj :botright new<CR>

" buffer
nmap <leader>sl  :leftabove  vnew<CR>
nmap <leader>sh  :rightbelow vnew<CR>
nmap <leader>sk  :leftabove  new<CR>
nmap <leader>sj  :rightbelow new<CR>

" Most prefer to toggle search highlighting rather than clear the current
" search results. To clear search highlighting rather than toggle it on
" and off, add the following to your .vimrc.before.local file:
" let g:clear_search_highlight = 1
if exists('g:clear_search_highlight')
   nmap <silent> // :nohlsearch<CR>
else
   nmap <silent> // :set invhlsearch<CR>
endif


" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Shortcuts
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" Fix home and end keybindings for screen, particularly on mac
" - for some reason this fixes the arrow keys too. huh.
map [F $
imap [F $
map [H g0
imap [H g0

" RSI reduction keybindings
imap <C-k> _
imap <C-d> _

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Easier horizontal scrolling
map zl zL
map zh zH

" }

" Plugins {

" Misc {
let b:match_ignorecase = 1
" }

" OmniComplete {
if has("autocmd") && exists("+omnifunc")
   autocmd Filetype *
            \if &omnifunc == "" |
            \setlocal omnifunc=syntaxcomplete#Complete |
            \endif
endif

" }

" Ctags {
set tags=./tags;/,~/.vimtags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
   let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
" }

" DelimitMate {
" Turn off all quote matching
let delimitMate_quotes = ""
" }

" AutoCloseTag {
" Make it so AutoCloseTag works for xml and xhtml files as well
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }

" Ultisnips {
let g:UltiSnipsExpandTrigger="<C-CR>"
let g:UltiSnipsJumpForwardTrigger="<A-j>"
"let g:UltiSnipsJumpBackwardTrigger="<s-j>"
let g:snips_author="Tyler Thrane"
let g:snips_author_email="tjthrane@gmail.com"
" }

" Easy Align {
vnoremap <silent> <Leader>a :LiveEasyAlign<CR>
vnoremap <silent> <Leader><Enter> :EasyAlign<CR>
" }

" PyMode {
let g:pymode_lint_checker = "pyflakes"
let g:pymode_utils_whitespaces = 0
let g:pymode_options = 0
" }

" ctrlp {
let g:ctrlp_working_path_mode = 'ra'
nnoremap <silent> <leader>p :CtrlP<CR>
nnoremap <silent> <D-r> :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
         \ 'dir': '\.git$\|\.hg$\|\.svn$',
         \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

" On Windows use "dir" as fallback command.
if has('win32') || has('win64')
   let g:ctrlp_user_command = {
            \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': 'dir %s /-n /b /s /a-d'
            \ }
else
   let g:ctrlp_user_command = {
            \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': 'find %s -type f'
            \ }
endif
"}

" PythonMode {
" Disable if python support not present
if !has('python')
   let g:pymode = 1
endif
" }

" Fugitive {
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>:GitGutter<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
nnoremap <silent> <leader>gg :GitGutterToggle<CR>
"}

" UndoTree {
nnoremap <Leader>u :UndotreeToggle<CR>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
" }

" indent_guides {
if !exists('g:no_indent_guides_autocolor')
   let g:indent_guides_auto_colors = 1
else
   " For some colorschemes, autocolor will not work (eg: 'desert', 'ir_black')
   autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=#212121 ctermbg=3
   autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#404040 ctermbg=4
endif
let g:indent_guides_start_level = 3
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
" }

" airline {
let g:airline_theme='powerlineish' " airline users use the powerline theme
if !exists('g:airline_powerline_fonts')
   let g:airline_left_sep='›' " Slightly fancier separator, instead of '>'
   let g:airline_right_sep='‹' " Slightly fancier separator, instead of '<'
endif
" }

" vim-gitgutter {
" https://github.com/airblade/vim-gitgutter/issues/106
let g:gitgutter_realtime = 0
" }

" }

" GUI Settings {

" GVIM- (here instead of .gvimrc)
if has('gui_running')
   set guioptions-=T " Remove the toolbar
   set guioptions-=m " Remove the menu
   set guioptions-=r " Remove the scrolbar
   set guioptions-=R " Remove the scrolbar
   set guioptions-=l " Remove the scrolbar
   set guioptions-=L " Remove the scrolbar
   set lines=40 " 40 lines of text instead of 24
   if has("gui_gtk2")
      set guifont=Source\ Code\ Pro\ 12,Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
   elseif has("gui_mac")
      set guifont=Source\ Code\ Pro\ 12,Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
   elseif has("gui_win32")
      set guifont=Source\ Code\ Pro\ 12,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
   endif
   if has('gui_macvim')
      set transparency=5 " Make the window slightly transparent
   endif
else
   if &term == 'xterm' || &term == 'screen' || &term == 'rxvt-unicode-256color'
      set t_Co=256 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
   endif
   "set term=builtin_ansi " Make arrow and other keys work
endif

" }

" Functions {

" UnBundle {
function! UnBundle(arg, ...)
   let bundle = vundle#config#init_bundle(a:arg, a:000)
   call filter(g:bundles, 'v:val["name_spec"] != "' . a:arg . '"')
endfunction

com! -nargs=+ UnBundle
         \ call UnBundle(<args>)
" }

" Initialize directories {
function! InitializeDirectories()
   let parent = $HOME
   let prefix = 'vim'
   let dir_list = {
            \ 'backup': 'backupdir',
            \ 'views': 'viewdir',
            \ 'swap': 'directory' }

   if has('persistent_undo')
      let dir_list['undo'] = 'undodir'
   endif

   " turn off swapfiles
   set noswapfile

   " To specify a different directory in which to place the vimbackup,
   " vimviews, vimundo, and vimswap files/directories, add the following to
   " your .vimrc.before.local file:
   " let g:consolidated_directory = <full path to desired directory>
   " eg: let g:consolidated_directory = $HOME . '/.vim/'
   if exists('g:consolidated_directory')
      let common_dir = g:consolidated_directory . prefix
   else
      let common_dir = parent . '/.' . prefix
   endif

   for [dirname, settingname] in items(dir_list)
      let directory = common_dir . dirname . '/'
      if exists("*mkdir")
         if !isdirectory(directory)
            call mkdir(directory)
         endif
      endif
      if !isdirectory(directory)
         echo "Warning: Unable to create backup directory: " . directory
         echo "Try: mkdir -p " . directory
      else
         let directory = substitute(directory, " ", "\\\\ ", "g")
         exec "set " . settingname . "=" . directory
      endif
   endfor
endfunction
call InitializeDirectories()
" }

" Strip whitespace {
function! StripTrailingWhitespace()
   " To disable the stripping of whitespace, add the following to your
   " .vimrc.before.local file:
   " let g:keep_trailing_whitespace = 1
   if !exists('g:keep_trailing_whitespace')
      " Preparation: save last search, and cursor position.
      let _s=@/
      let l = line(".")
      let c = col(".")
      " do the business:
      %s/\s\+$//e
      " clean up: restore previous search history, and cursor position
      let @/=_s
      call cursor(l, c)
   endif
endfunction
" }

" Shell command {
function! s:RunShellCommand(cmdline)
   botright new

   setlocal buftype=nofile
   setlocal bufhidden=delete
   setlocal nobuflisted
   setlocal noswapfile
   setlocal nowrap
   setlocal filetype=shell
   setlocal syntax=shell

   call setline(1, a:cmdline)
   call setline(2, substitute(a:cmdline, '.', '=', 'g'))
   execute 'silent $read !' . escape(a:cmdline, '%#')
   setlocal nomodifiable
   1
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }

" Python Calculator with :Calc {
command! -nargs=+ Calc :py print <args>
py from math import *
" }

" }

" Use local vimrc if available {
if filereadable(expand("~/.vimrc.local"))
   source ~/.vimrc.local
endif
" }

" Use local gvimrc if available and gui is running {
if has('gui_running')
   if filereadable(expand("~/.gvimrc.local"))
      source ~/.gvimrc.local
   endif
endif
" }
