"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections
"
" - General
" - VIM user interface
" - Colors and Fonts
" - Files, backups and undo
" - Text, tab and indent related
" - Visual mode related
" - Command mode related
" - Moving around, tabs and buffers
" - Statusline
" - Browsing and using external applications
" - Parenthesis/bracket expanding/folding
" - General Abbrevs
" - Calculations
" - Editing mappings
" - Cope
" - Omni complete functions
" - Spell checking
" - html section
" - JavaScript section
" - Plugins
" - Fuf/MRU plugin
" - NERDTree
" - Command-T
" - Syntastic
" - Zen Coding
" - Vim grep
" - MISC
" - Functions
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>s saves the current file
let mapleader = ","
let g:mapleader = ","



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7
set wildmenu                        "Turn on WiLd menu
set ruler                           "Always show current position
set cmdheight=1                     "The commandbar height
set showcmd                         "Show incomplete commands in commandbar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l              "Allow these left/right keys to move the cursor across lines
set cursorline

set ignorecase                      "Ignore case when searching
set smartcase
set hlsearch                        "Highlight search things
set incsearch                       "Make search act like search in modern browsers
set nolazyredraw                    "Don't redraw while executing macros 

set magic                           "Set magic on, for regular expressions

set showmatch                       "Show matching bracets when text indicator is over them
set matchpairs+=<:>                 " highlight closing backet for tags
set mat=2                           "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
"set virtualedit=all,onemore
set t_vb=
set tm=500

set shellslash                      " use unix path separators

"Remeber open buffers on close
" set viminfo^=%


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable                       "Enable syntax hl

" Set font according to system
if MySys() == "mac"
  set gfn=Consolas:h14
  set shell=/bin/bash
elseif MySys() == "windows"
  set gfn=Consolas:h11
elseif MySys() == "linux"
  set gfn=Monospace\ 10
  set shell=/bin/bash
endif

if has("gui_running")
  set guioptions-=T
  set t_Co=256
  set background=dark
  colorscheme bespin
  set nu
else
  colorscheme bespin
  set background=dark
  set nonu
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

" encodings and formats
" can use set fileformat=unix if needed
set encoding=utf8
set fileformat=unix

" diff current file with it's saved version
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set tabstop=4
set softtabstop=4
set smarttab
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'

set lbr
set tw=500

set ai                              "Auto indent
set si                              "Smart indent
set nowrap                          "don't wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Some useful keys for vimgrep
command! -nargs=+ DFind execute 'noautocmd vimgrep! <args>' | copen 10
map <c-f> :DFind //gj **/*.*<left><left><left><left><left><left><left><left><left><left>
map <c-f><c-c> :DFind // **/*.css<left><left><left><left><left><left><left><left><left><left>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

"
" From an idea by Michael Naumann
" 
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Smart mappings on the command line
cno $h e ~/
cno $d c <C-\>eCurrentFileDir("e")<cr>
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Useful 

func! Cwd()
  let cwd = getcwd()
  return "e " . cwd 
endfunc

func! DeleteTillSlash()
  let g:cmd = getcmdline()
  if MySys() == "linux" || MySys() == "mac"
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  else
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  endif
  if g:cmd == g:cmd_edited
    if MySys() == "linux" || MySys() == "mac"
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    else
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    endif
  endif   
  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Useful when moving accross long lines
map j gj
map k gk

" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <s-space> ?
map <silent> <leader><cr> :noh<cr>

" moving between tabs

" move between windows
map <C-down> <C-W>j
map <C-up> <C-W>k
map <C-left> <C-W>h
map <C-right> <C-W>l
map <c-h> <C-W>h
map <c-l> <C-W>l
map <c-j> <c-w>j
map <c-k> <c-w>k

" move between buffers
map <leader>b :FufBuffer<CR>
" let g:miniBufExplMapCTabSwitchBufs = 1
" let g:miniBufExplShowBufNumbers = 0
nmap <m-left> :bp<cr>
nmap <m-right> :bn<cr>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>


" Tab configuration
map <leader>tn :tabnew!<cr>:NERDTreeMirror<CR>
map <leader>te :tabedit 
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>


command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Specify the behavior when switching between buffers 
try
  set hidden
  set switchbuf=usetab      " Like useopen, but also consider windows in other tab pages.
  set stal=1                " only show tab bar if there are 2 or more tabs
catch
endtry

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

"Add the variable with the name a:varName to the statusline. Highlight it as
"'error' unless its value is in a:goodValues (a comma separated string)
function! AddStatuslineFlag(varName, goodValues)
  set statusline+=[
  set statusline+=%#error#
  exec "set statusline+=%{RenderStlFlag(".a:varName.",'".a:goodValues."',1)}"
  set statusline+=%*
  exec "set statusline+=%{RenderStlFlag(".a:varName.",'".a:goodValues."',0)}"
  set statusline+=]
endfunction

"returns a:value or ''
"
"a:goodValues is a comma separated string of values that shouldn't be
"highlighted with the error group
"
"a:error indicates whether the string that is returned will be highlighted as
"'error'
"
function! RenderStlFlag(value, goodValues, error)
  let goodValues = split(a:goodValues, ',')
  let good = index(goodValues, a:value) != -1
  if (a:error && !good) || (!a:error && good)
    return a:value
  else
    return ''
  endif
endfunction

"Git branch
function! GitBranch()
    try
        let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
    catch
        return ''
    endtry

    if branch != ''
        return substitute(branch, '\n', '', 'g')
    endif

    return ''
endfunction

"statusline setup
set statusline=%#string#%f%*       "tail of the filename
call AddStatuslineFlag('&ff', 'unix')    "fileformat
call AddStatuslineFlag('&fenc', 'utf-8') "file encoding
" set statusline+=%{GitBranch()} " git branch
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
" set statusline+=%{StatuslineCurrentHighlight()}
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Browsing and using external applications
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open file browser
if MySys() == "mac"
    nmap <f11> :!open --reveal %:p<CR>
elseif MySys() == "windows"
    nmap <leader>cmd :!start cmd %:p:h<cr>
    nmap <F11> :!start explorer /select,%:p<cr>
    imap <F11> <Esc><F11>
    nmap <F12> :!start %:p<cr>
endif

" web browsers
if MySys() == "mac"
    cabbrev ff !open -a /Applications/Firefox.app/Contents/MacOS/firefox 'file:///%:p'
elseif MySys() == "windows"
    cabbrev ff !start c:\Program Files (x86)\Mozilla Firefox\firefox.exe file:///%:p
    cabbrev ff20 !cd d:\Dropbox\programs\firefox\ && d: && start run-firefox20.bat file:///%:p
    cabbrev ff30 !start cd d:\Dropbox\programs\firefox\ && run-firefox30.bat file:///%:p
    cabbrev ff35 !start cd D:\Dropbox\programs\firefox\ && run-firefox35.bat file:///%:p
    cabbrev ff36 !start cd D:\Dropbox\programs\firefox\ && run-firefox36.bat file:///%:p
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding/folding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<left>
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap '+ ' +  + '<left><left><left><left>
inoremap §= ' +  + '<left><left><left><left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdatet <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab xdate <c-r>=strftime("%Y-%m-%d")<cr>
" iab xlg <c-r>=strftime("%Y-%m-%d %H:%M")<cr><space><space>DT<space>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Calculations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" em calculations
imap <leader>em <c-r>=00/12<left><left><left><left><left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM home/end keys
map 0 ^
map 4 $

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if MySys() == "mac"
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
elseif MySys() == "windows"
    " stop windows vim mapping <c-a> to select all
    nunmap <C-A>
endif

set guitablabel=%t


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
map <leader>cc :cw<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

inoremap <c-space> <C-x><C-o>
inoremap <a-space> <C-x><C-f>
inoremap <c-l> <C-x><C-l>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

""""""""""""""""""""""""""""""
" => html section
"""""""""""""""""""""""""""""""
" indenting
let g:html_indent_inctags = "html,body,head,p,tbody,li,header,footer,section,article,figure,aside"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" entities
au FileType html imap <s-cr> <br /><cr>
au FileType html nmap =% f><left>V%=
" au FileType html nmap <cr> i<cr>

function HtmlEscape()
  silent %s/\%V&/\&amp;/eg
  silent %s/\%V</\&lt;/eg
  silent %s/\%V>/\&gt;/eg
endfunction

function HtmlUnEscape()
  silent s/\%V&lt;/</eg
  silent s/\%V&gt;/>/eg
  silent s/\%V&amp;/\&/eg
endfunction

command Dhtmlescape call HtmlEscape()
command Dhtmlunescape call HtmlUnEscape()

" tags
au FileType html nmap <leader>, f>i<space>

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
"au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript nmap <leader>, $i,<cr>
au BufNewFile,BufRead *.json set filetype=javascript

function! JavaScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction

""""""""""""""""""""""""""""""
" => css section
"""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.less set filetype=less.css

""""""""""""""""""""""""""""""
" => text based section
"""""""""""""""""""""""""""""""
" au BufNewFile,BufRead *.txt set filetype=mkd
au FileType mkd set textwidth=80

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
""""""""""""""""""""""""""""""
" => Fuf/MRU plugin
let MRU_Max_Entries = 400
let MRU_Use_Current_Window = 1
map <leader>ff :FufJumpList<CR>
map <leader>fm :MRU<CR>
noremap <leader>fb :FufBuffer<CR>
map <leader>fl :FufLine<CR>
let g:fuf_keyOpenSplit='<C-i>'
let g:fuf_keyOpenVsplit='<C-s>'
let g:fuf_autoPreview = 1

" => NERDTree
let g:NERDTreeChDirMode=2
let g:NERDChristmasTree=1
let g:NERDTreeHighlightCursorline=1
let g:NERDTreeShowBookmarks=1
let g:NERDTreeShowHidden=1
let g:NERDTreeIgnore=['\~$','\.svn']

nmap <silent> <c-n> :NERDTreeToggle<CR>
nmap <leader>nt :NERDTree<CR>
nmap <leader>ntf :NERDTreeFind<cr>

" => Command-T
let g:CommandTMaxHeight = 15
set wildignore+=*.o,*.obj,.git,*.pyc,*.exe,*.aux,*.dvi,*.dll,node_modules/**
noremap <leader>y :CommandTFlush<cr>
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTMatchWindowReverse = 1
"let g:CommandTMatchWindowAtTop = 1
" => Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_enable_signs=1
" let g:syntastic_auto_loc_list=1
" let g:syntastic_quiet_warnings=1

run SyntasticEnable html
" => Zen Coding
" let g:user_zen_leader_key = '<c-y>'
imap <leader><tab> <c-y>,
vmap <leader><tab> <c-y>,

""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>mm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
noremap <Leader>ml mmHmt:s/<cr>//g<cr>'tzt'm

map <leader>q :w<cr>:bd<cr>
map <leader>w :Bclose<cr>
map <leader>ls :ls<cr>
map <leader>pp :setlocal paste!<cr>

" quick navigation
map <leader>bb :cd ..<cr>
map <leader>cs :cd ~/Sites<cr>
map <leader>cp :cd c:/projects<cr>

" Fast saving
nmap <leader>s :w!<cr>
imap <leader>s <esc>:w!<cr>
nmap <leader>sa :wa!<cr>


" gui options
if MySys() == "mac"
    if has("gui_running")
      set fuoptions=maxvert,maxhorz
      " au GUIEnter * set fullscreen
    endif
endif
" maximise the window to fit the screen
au GUIEnter * set columns=9999
au GUIEnter * set lines=999

if MySys() == "mac"
	au GUIEnter * :cd ~/Sites
elseif MySys() == "windows"
	au GUIEnter * :cd c:/projects
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function DGetToc()
    let @a = ""
    normal V$%d
    execute 'g/=>/y A'
    let @a = "/*\n    " . expand("%:t") . "\n    =================================" . substitute(@a, "=>", "-", "g") . "\n*/\n"
    normal ggP
endfunction
command! DToc call DGetToc()
