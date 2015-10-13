" Vim config file.

" Global Settings: {{{
if has("syntax")
    syntax on                       " highlight syntax
endif
filetype on
filetype plugin indent on           " auto detect file type
call pathogen#infect()              " use pathogen to manage plugins

set nocompatible                    " out of Vi compatible mode
set number                          " show line number
set cursorline
set numberwidth=3                   " minimal culumns for line numbers
set textwidth=0                     " do not wrap words (insert)
set nowrap                          " do not wrap words (view)
set wrap                            " wrap words (view)
set showcmd                         " show (partial) command in status line
set ruler                           " line and column number of the cursor position
set wildmenu                        " enhanced command completion
set wildmode=list:longest,full      " command completion mode
set laststatus=2                    " always show the status line
set mouse=a                         " use mouse in all mode
set foldenable                      " fold lines
set foldmethod=marker               " fold as marker
set noerrorbells                    " do not use error bell
set novisualbell                    " do not use visual bell
set t_vb=                           " do not use terminal bell

set wildignore=.svn,.git,*.swp,*.bak,*~,*.o,*.a
set autowrite                       " auto save before commands like :next and :make
set cursorline
set hidden                          " enable multiple modified buffers
set history=100                     " record recent used command history
set autoread                        " auto read file that has been changed on disk
set backspace=indent,eol,start      " backspace can delete everything
set completeopt=menuone,longest     " complete options (insert)
set pumheight=10                    " complete popup height
set scrolloff=5                     " minimal number of screen lines to keep beyond the cursor
set autoindent                      " automatically indent new line
set cinoptions=:0,l1,g0,t0,(0,(s    " C kind language indent options

set tabstop=4                       " number of spaces in a tab 表示一个tab显示出来是多少个空格
set softtabstop=4                   " insert and delete space of <tab> 在编辑的时候，一个tab是多少个空格
set shiftwidth=4                    " number of spaces for indent 每一级缩进是多少个空格
set expandtab                       " expand tabs into spaces  将tab扩展成空格
"set noexpandtab                     " noexpand tabs into spaces  将tab不扩展成空格
set smarttab                        "根据文件中其他地方的缩进空格个数来确定一个tab是多少个空格
set incsearch                       " incremental search
set hlsearch                        " highlight search match
set ignorecase                      " do case insensitive matching
set smartcase                       " do not ignore if search pattern has CAPS
set nobackup                        " do not create backup file
set noswapfile                      " do not create swap file
set backupcopy=yes                  " overwrite the original file
set showmatch                       "设置匹配模式，显示匹配的括号
set linebreak                       "整词换行
set whichwrap=b,s,<,>,,]           "光标从行首和行末时可以跳到另一行去

set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gb2312,gbk,gb18030
set fileformat=unix

set background=dark
"colorscheme SolarizedDark_modified
"colorscheme wombat_modified
"let g:molokai_original = 1
"let g:rehash256 = 1
"colorscheme molokai
colorscheme mycolor
" gui settings
if has("gui_running")
    set guioptions-=T " no toolbar
    set guioptions-=r " no right-hand scrollbar
    set guioptions-=R " no right-hand vertically scrollbar
    set guioptions-=l " no left-hand scrollbar
    set guioptions-=L " no left-hand vertically scrollbar
    autocmd GUIEnter * simalt ~x " window width and height
    source $VIMRUNTIME/delmenu.vim " the original menubar has an error on win32, so
    source $VIMRUNTIME/menu.vim    " use this menubar
    language messages zh_CN.utf-8 " use chinese messages if has
endif

" vim-go
syntax enable  
filetype plugin on  
let g:go_disable_autoinstall = 0

" Highlight
let g:go_highlight_functions = 1  
let g:go_highlight_methods = 1  
let g:go_highlight_structs = 1  
let g:go_highlight_operators = 1  
let g:go_highlight_build_constraints = 1  

au FileType go nmap <Leader>s <Plug>(go-def-split)
au FileType go nmap <Leader>v <Plug>(go-def-vertical)
au FileType go nmap <Leader>in <Plug>(go-info)
au FileType go nmap <Leader>ii <Plug>(go-implements)

au FileType go nmap <leader>r  <Plug>(go-run)
au FileType go nmap <leader>b  <Plug>(go-build)
au FileType go nmap <leader>g  <Plug>(go-gbbuild)
au FileType go nmap <leader>t  <Plug>(go-test-compile)
au FileType go nmap <Leader>d <Plug>(go-doc)
au FileType go nmap <Leader>f :GoImports<CR>

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

nmap <F8> :TagbarToggle<CR>

" Restore the last quit position when open file.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g'\"" |
    \ endif
"}}}

" Key Bindings: {{{
let mapleader = ","
let maplocalleader = "\\"

" map : -> <space>
map <Space> :

" move between windows
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Don't use Ex mode, use Q for formatting
map Q gq

"make Y consistent with C and D
nnoremap Y y$

" toggle highlight trailing whitespace
nmap <silent> <leader>l :set nolist!<CR>

" Ctrol-E to switch between 2 last buffers
nmap <C-E> :b#<CR>

" ,e to fast finding files. just type beginning of a name and hit TAB
nmap <leader>e :e **/

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" ,n to get the next location (compilation errors, grep etc)
nmap <leader>n :cn<CR>
nmap <leader>p :cp<CR>

" Ctrl-N to disable search match highlight
nmap <silent> <C-N> :silent noh<CR>

" center display after searching
nnoremap n   nzz
nnoremap N   Nzz
nnoremap *   *zz
nnoremap #   #zz
nnoremap g*  g*zz
nnoremap g#  g#z

" Grep
nnoremap <silent> <F3> :Grep<CR>
nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>

"}}}

" Plugin Settings: {{{
if has("win32") " win32 system
    let $HOME  = $VIM
    let $VIMFILES = $HOME . "/vimfiles"
else " unix
    let $HOME  = $HOME
    let $VIMFILES = $HOME . "/.vim"
endif

" mru
let MRU_Window_Height = 10
nmap <Leader>r :MRU<cr>

" taglist
let g:Tlist_Auto_Open = 0
let g:Tlist_WinWidth = 30
let g:Tlist_Use_Right_Window = 0
let g:Tlist_Auto_Update = 1
let g:Tlist_Process_File_Always = 1
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_Show_One_File = 1
let g:Tlist_Enable_Fold_Column = 0
let g:Tlist_Auto_Highlight_Tag = 1
let g:Tlist_GainFocus_On_ToggleOpen = 1
nmap <F6> :Tlist<CR>
nmap <Leader>t :TlistToggle<cr>

" pydiction
filetype plugin on  
autocmd FileType python set omnifunc=pythoncomplete#Complete  
autocmd FileType javascrīpt set omnifunc=javascriptcomplete#CompleteJS  
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags  
autocmd FileType css set omnifunc=csscomplete#CompleteCSS  
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags  
autocmd FileType php set omnifunc=phpcomplete#CompletePHP  
autocmd FileType c set omnifunc=ccomplete#Complete  
   
let g:pydiction_location='~/.vim/tools/pydiction/complete-dict'  

" nerdtree
" autocmd vimenter * NERDTree
let g:NERDTreeWinPos = "left"
let g:NERDTreeWinSize = 25
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeQuitOnOpen = 0
let NERDTreeShowBookmarks=1
let NERDChristmasTree=1
nmap <F7> :NERDTreeToggle<CR>
nmap <Leader>F :NERDTreeFind<CR>

" snipMate
let g:snip_author   = "Jeffy Du"
let g:snip_mail     = "jeffy.du@163.com"
let g:snip_company  = "SIC Microelectronics CO. Ltd"

" man.vim - view man page in VIM
source $VIMRUNTIME/ftplugin/man.vim


nmap <F9> :!ctags -R --c-kinds=+cdefgmnpstuv --c++-kinds=+cdefgmnpstuv --fields=+iaS --extra=+q .<CR><CR>:TlistUpdate<CR>
"nmap <F9> :!ctags -R --c-kinds=+cdefgmnpstuv --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>:TlistUpdate<CR>
nmap <F10> :!cscope -Rbkq<cr><cr>
set tags=./tags
autocmd BufRead,BufNewFile *.py set tags+=/Users/zhangzhen/anaconda/lib/python2.7/site-packages/tags
autocmd FileType c set tags+=/usr/include/tags
autocmd FileType go set tags+=$GOPATH/src/tags
autocmd FileType go set tags+=$GOROOT/src/tags
"set autochdir

" cscope
nmap <leader>ss :cs find s <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sg :cs find g <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sc :cs find c <C-R>=expand("<cword>")<cr><cr>
nmap <leader>st :cs find t <C-R>=expand("<cword>")<cr><cr>
nmap <leader>se :cs find e <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<cr><cr>
nmap <leader>si :cs find i <C-R>=expand("<cfile>")<cr><cr>
nmap <leader>sd :cs find d <C-R>=expand("<cword>")<cr><cr>

if has("cscope")
    set cscopetag
    set csto=1
    set cst
    set nocsverb
    set cscopequickfix=s-,c-,d-,i-,t-,e-,f-
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
endif

"paste
vmap <C-c> "+y
nmap <C-v> "+p
set pastetoggle=<F12>


" display column highlight
"nmap <leader>c  :set cuc!<cr><cr>
"set cuc cul

set t_CO=256 "如果是在模拟终端需要把颜色设置成256色

" tselect
"nmap <leader>d :tselect <C-R>=expand("<cword>")<cr><cr>

" vimgdb.vim
if has("gdb")
	set asm=0
	let g:vimgdb_debug_file=""
	run macros/gdb_mappings.vim
endif


" -- omnicppcomplete settting ---
" imap <F5> <C-X><C-O>
" imap <F2> <C-X><C-I>


" -- WinManager Settings --
let g:winManagerWindowLayout='FileExplorer|Taglist'
"let g:winManagerWindowLayout='BufExplorer,FileExplorer|Taglist'
let g:persistentBehaviour=0
"nmap <leader>wm :WMToggle<cr>
nmap <leader>w :WMToggle<cr>

"删除行尾的^M, ^M的输入方式:ctrl v + m
"%s///g

"autocmd FileType java set shiftwidth=4 | set tabstop=4 | set softtabstop=4 | set expandtab

"保存文件的时候，自动删除行尾空白字符
"autocmd  BufWrite,BufWritePre *.c  exe "normal :%s/\s\+$//"
" nmap <F8>  :%s/[ \t\r]\+$//g<CR>

"内核代码和Android代码的风格不同
"Android
"nmap <F5> :set shiftwidth=4 tabstop=4 softtabstop=4 expandtab<cr>
"nmap <F5> :set shiftwidth=4 tabstop=4 softtabstop=4 expandtab<cr>:%retab!<cr><cr>
"内核
"nmap <F6> :set shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab<cr>
"nmap <F6> :set shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab<cr>:%retab!<cr><cr>
"
"Source Explorer
"nmap <F8> :SrcExplToggle<CR>
"let g:SrcExpl_winHeight = 8
"let g:SrcExpl_refreshTime = 100
"let g:SrcExpl_jumpKey = "<ENTER>"
"let g:SrcExpl_gobackKey = "<SPACE>"
"let g:SrcExpl_isUpdateTags = 0
"set list
"set listchars=tab:>-,trail:-

"make current window the largest
"nmap <F7> :res<cr>:vertical res<cr>
