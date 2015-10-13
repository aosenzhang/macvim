" File: project.vim
" Author: Jeffy Du <jeffy.du@163.com>
" Version: 0.1
"
" Description:
" ------------
" This plugin provides a solution for creating project tags and cscope files.
" If you want to run this plugin in Win32 system, you need add the system-callings
" (ctags,cscope,find,grep,sort) to your system path. Usually, you can find these
" system-callings in Cygwin.
"
" Installation:
" -------------
" 1. Copy project.vim to one of the following directories:
"
"       $HOME/.vim/plugin    - Unix like systems
"       $VIM/vimfiles/plugin - MS-Windows
"
" 2. Start Vim on your project root path.
" 3. Use command ":ProjectCreate" to create project.
" 3. Use command ":ProjectLoad" to load project.
" 4. Use command ":ProjectUpdate" to update project.
" 5: Use command ":ProjectQuit" to quit project.

if exists('loaded_project')
    finish
endif
let loaded_project=1

if v:version < 700
    finish
endif

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

" Global variables
if !exists('g:project_data')
    let g:project_data = "project_vim"
endif

" flag for tags type
" "d" - macro define
" "e" - enum item
" "f" - function
let s:HLUDFlag = ['d', 'e', 'f', 'g', 'p', 's', 't', 'u']
let s:HLUDType = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']

" HLUDLoad                      {{{1
" load user types
function! s:HLUDLoad(udtagfile)
	if filereadable(a:udtagfile)
		let s:HLUDType = readfile(a:udtagfile)
	endif
endfunction

" HLUDGetTags                   {{{1
" get tag data by tag flag
function! s:HLUDGetTags(flag)
	let idx = index(s:HLUDFlag, a:flag)
	if idx != -1
		return s:HLUDType[idx]
	else
		return ' '
	endif
endfunction

" HLUDColor                     {{{1
" highlight tags data
function! s:HLUDColor()
	exec 'syn keyword cUserTypes X_X_X ' . s:HLUDGetTags('t') . s:HLUDGetTags('u') .  s:HLUDGetTags('s') . s:HLUDGetTags('g')
	exec 'syn keyword cUserDefines X_X_X ' . s:HLUDGetTags('d') . s:HLUDGetTags('e')
	exec 'syn keyword cUserFunctions X_X_X ' . s:HLUDGetTags('f') . s:HLUDGetTags('p')
    exec 'hi cUserTypes ctermfg=green guifg=green'
    exec 'hi cUserDefines ctermfg=red guifg=red'
    exec 'hi cUserFunctions ctermfg=magenta guifg=magenta'
endfunction

" HLUDSync                      {{{1
" sync tag data
function! s:HLUDSync(tagsfile, udtagfile)

	" if tag file is not exist, do nothing.
	if !filereadable(a:tagsfile)
		return
	endif

	" parse tag file line by line.
    let s:HLUDType = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
	for line in readfile(a:tagsfile)
		" parse tag flag
		let idx = stridx(line, ';"' . "\t")
		if idx != -1
			let s:flag = strpart(line, idx+3, 1)

			" parse and save flag
			let idx = index(s:HLUDFlag, s:flag)
			if idx != -1
				let s:HLUDType[idx] = s:HLUDType[idx] . matchstr(line, '^\<\h\w*\>') . ' '
			endif
		endif
	endfor

	" write tags data to file.
	call writefile(s:HLUDType, a:udtagfile)
endfunction

" WarnMsg                       {{{1
" display a warning message
function! s:WarnMsg(msg)
    echohl WarningMsg
    echon a:msg
    echohl None
endfunction

" ProjectCreate                 {{{1
" create project data
function! s:ProjectCreate()
    " create project data directory.
    if !isdirectory(g:project_data)
        call mkdir(g:project_data, "p")
    endif

    " create tags file
    if executable('ctags')
        call system('ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -o ' . g:project_data . '/tags ' . getcwd())
    else
        call s:WarnMsg("command 'ctags' not exist.")
        return -1
    endif

    " create cscope file
    if executable('cscope')
        call system('cscope -Rbqk -f' . g:project_data . "/cstags")
    else
        call s:WarnMsg("command 'cscope' not exist.")
        return -1
    endif

    call s:HLUDSync(g:project_data . '/tags', g:project_data . '/udtags')
    echon "create project done, "
    call s:ProjectLoad()
    return 1
endfunction

" ProjectUpdate                 {{{1
" update project data
function! s:ProjectUpdate()
    " find the project root directory.
    let proj_data = finddir(g:project_data, getcwd() . ',.;')
    if proj_data == ''
        return
    endif
    exe 'cd ' . proj_data . "/.."

    " create tags file
    if executable('ctags')
        call system('ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -o ' . proj_data . '/tags ' . getcwd())
    else
        call s:WarnMsg("command 'ctags' not exist.")
        return -1
    endif

    " create cscope file
    if executable('cscope')
        call system('cscope -Rbqk -f' . proj_data . "/cstags")
    else
        call s:WarnMsg("command 'cscope' not exist.")
        return -1
    endif

    call s:HLUDSync(proj_data . '/tags', proj_data . '/udtags')
    call s:HLUDColor()
    echo "update project done."
    return 1
endfunction

" ProjectLoad                   {{{1
" load project data
function! s:ProjectLoad()
    " find the project root directory.
    let proj_data = finddir(g:project_data, getcwd() . ',.;')
    if proj_data == ''
        return
    endif
    exe 'cd ' . proj_data . "/.."

    " load tags.
    let &tags = proj_data . '/tags,' . &tags

    " load cscope.
    if filereadable(proj_data . '/cstags')
        set csto=1
        set cst
        set nocsverb
        exe 'cs add ' . proj_data . '/cstags'
        cs reset
        set csverb
    endif

    " color user defined.
    call s:HLUDLoad(proj_data . '/udtags')
    call s:HLUDColor()

    echon "load project done."
    return 1
endfunction

" ProjectQuit                   {{{1
" quit project
function! s:ProjectQuit()
    " find the project root directory.
    let proj_data = finddir(g:project_data, getcwd() . ',.;')
    if proj_data == ''
        return
    endif

    " quit vim
    exe 'qa'
    return 1
endfunction

" }}}

command! -nargs=0 -complete=file ProjectCreate call s:ProjectCreate()
command! -nargs=0 -complete=file ProjectUpdate call s:ProjectUpdate()
command! -nargs=0 -complete=file ProjectLoad call s:ProjectLoad()
command! -nargs=0 -complete=file ProjectQuit call s:ProjectQuit()

aug Project
    au VimEnter * call s:ProjectLoad()
    au VimLeavePre * call s:ProjectQuit()
    au BufEnter,FileType c,cpp call s:HLUDColor()
aug END

nnoremap <leader>jc :ProjectCreate<cr>
nnoremap <leader>ju :ProjectUpdate<cr>
nnoremap <leader>jl :ProjectLoad<cr>
nnoremap <leader>jq :ProjectQuit<cr>

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set foldenable foldmethod=marker:
