" search for 'not yet finished' to find out unfinished parts (ex: some mappings)
set nocompatible " enable many features/plugins of vim; put the statement on the 1st line of .vimrc as it affects many statements
let s:mac=has('mac') || has('macunix')
let s:win=has('win16') || has('win32') || has('win64')
if has('unix')
    if !s:mac
        let g:my_xterm=''
        let g:my_fm=''
        let s:my_xterms=['urxvt -e', 'st -e', 'stterm -e', 'roxterm -e', 'terminator -x', 'xfce4-terminal -x', 'terminal -x', 'Terminal -x', 'gnome-terminal -x', 'konsole -e', 'xterm -e', 'rxvt -e', 'aterm -e', 'xvt -e']
        for s:e in s:my_xterms | if executable(split(s:e,' ')[0]) | let g:my_xterm=s:e | break | endif | endfor
        "let s:my_fms=['xdg-open', 'spacefm', 'pcmanfm', 'thunar', 'gvfs-open', 'exo-open', 'gnome-open', 'kde-open', 'kfmclient exec']
        let s:my_fms=[]
        for s:e in s:my_fms | if executable(split(s:e,' ')[0]) | let g:my_fm=s:e | break | endif | endfor
        if g:my_xterm == '' | let g:my_xterm='urxvt -e' | endif
        if g:my_fm == '' | let g:my_fm="bash -ic 'x \"$0\" \"$@\"'" | endif
    else
        let g:my_xterm='Terminal'
        let g:my_fm='open'
    endif
elseif s:win
    let g:my_xterm='cmd.exe'
    let g:my_fm=''
    "let g:my_fm='explorer.exe'
endif

if has('multi_byte')
    set encoding=utf-8 " encoding inside vim
    set fileencodings=ucs-bom,utf-8,big5,sjis,euc-jp,gb2312,gb18030,latin1 " vim guesses the file encoding one by one according to the list
    set fileencoding=utf-8 " the default encoding for a new open file
    if has('unix') | set termencoding=utf-8 | elseif s:win | set termencoding=big5 | endif
    language messages C " C == POSIX; pay attention to the capitalization and punctuation
    "source $VIMRUNTIME/delmenu.vim
    "set langmenu=none
    "source $VIMRUNTIME/menu.vim
    set nobomb " keep or remove UTF-8 BOM
endif

set fileformat=unix      " the default eol for a file (set fileformat=...)
set fileformats=unix,dos " vim guesses eol of a new open file according to the list (set fileformats=...)
" for unknown reasons, vim always sets &fileformat to 'mac' when the first line of a file is very long...
" to prevent this undesired behavior, include 'mac' in fileformats only under Mac
if s:mac | set fileformats+=mac | endif

set backupcopy=auto
if has('unix') && ($USER == 'root') || ($SSH_TTY != '')
    set nobackup        " whether to generate the ~ backup file
    set noswapfile      " whether to generate the swp file
    set updatecount=0   " after typing this many characters the swap file will be written to disk
    if has('viminfo') | set viminfo= | endif
else
    set backup
    set swapfile
    set updatecount=200
    let s:parent=split(&runtimepath,',')[0].'/'
    if has('viminfo') | execute 'set viminfo+=n'.'~/'.split(s:parent, '/')[-1].'/.viminfo' | endif
    let s:backup=s:parent."backup/"
    let s:swap=s:parent.'swap/'
    let s:view=s:parent.'view/'
    let s:undo=s:parent.'undo/'
    if exists('*mkdir')
        if !isdirectory(s:parent) | call mkdir(s:parent) | endif
        if !isdirectory(s:backup) | call mkdir(s:backup) | endif
        if !isdirectory(s:swap)   | call mkdir(s:swap)   | endif
        "if !isdirectory(s:view)   | call mkdir(s:view)   | endif
        "if !isdirectory(s:undo)   | call mkdir(s:undo)   | endif
    endif
    if isdirectory(s:backup) | execute 'set backupdir=' . escape(s:backup, ' ') . ',.' | else | set backupdir=. | endif
    if isdirectory(s:swap)   | execute 'set directory=' . escape(s:swap, ' ') . ',.'   | else | set directory=. | endif
    if isdirectory(s:view)   | execute 'set viewdir=' . escape(s:view, ' ') . ''       | else | set viewdir=.   | endif
    if isdirectory(s:view)   | execute 'set undodir=' . escape(s:undo, ' ') . ''       | else | set undodir=.   | endif
endif

" when vimrc file is sourced twice, the autocommands will appear twice
" to avoid this, put autocmd! in .vimrc before defining autocommands
autocmd!

if has('gui_running')
    autocmd BufWritePost .gvimrc,_gvimrc,.vimrc,_vimrc source %
else
    autocmd BufWritePost .vimrc,_vimrc source %
endif

"--- Key mappings start here ---"
let g:mapleader=";"

" DON'T map <esc>, otherwise many weird things will happen!
" prevent the one left movement of cursor when quitting insert mode using ESC
nnoremap <leader>j <esc>
inoremap <leader>j <esc>`^
vnoremap <leader>j <esc>
inoremap <c-c> <esc>`^

" make f(F)<char>;(,) back to work in visual mode
"vnoremap ;, ;,
"vnoremap ,; ,;

" when on, function keys that start with an <esc> are recognized in insert mode
set esckeys
imap <f1> <leader>j
imap <f2> <leader>j
imap <f3> <leader>j
imap <f4> <leader>j
imap <f5> <leader>j
imap <f6> <leader>j
imap <f7> <leader>j
imap <f8> <leader>j
imap <f9> <leader>j
imap <f10> <leader>j
imap <f11> <leader>j
imap <f12> <leader>j

" setting of mapped keys and key codes timeout
set notimeout
set ttimeout
" solve the problem that <esc> being treated as ALT in some terminals
set timeoutlen=0
set ttimeoutlen=0 " prevent strange sending of keycodes when entering vim in xterm

" fix the keyboard if backspace/delete keys don't work properly in terminal vim
"if &term =~ 'xterm'
    "fixdel
    "set t_kb=^V<bs>
    "set t_kD=^V<delete>
"elseif &term =~ 'rxvt'
    "fixdel
    "set t_kb=^V<bs>
    "set t_kD=^V<delete>
"else
    "fixdel
    "set t_kb=^V<bs>
    "set t_kD=^V<delete>
"endif

" not yet finished
" key mappings for split window. for some reason vim can only detect c-key in c-s-key
"nnoremap <silent> <c-s-k> <esc><c-w>k
"nnoremap <silent> <c-s-j> <esc><c-w>j
"nnoremap <silent> <c-s-h> <esc><c-w>h
"nnoremap <silent> <c-s-l> <esc><c-w>l

nnoremap <silent> <leader>HSW :call ToggleHotkeysToManipulateSplitWindows()<cr>
function! ToggleHotkeysToManipulateSplitWindows()
    if exists('g:swHotkeysOn') && g:swHotkeysOn
        "" move current line upward/downward
        "nnoremap <silent> <c-k> mz:m-2<cr>`z
        "nnoremap <silent> <c-j> mz:m+<cr>`z
        if (mapcheck('<c-h>','n') != '') | execute 'nunmap <c-h>' | endif
        if (mapcheck('<c-l>','n') != '') | execute 'nunmap <c-l>' | endif
        let g:swHotkeysOn=0
    else
        nnoremap <silent> <c-k> <esc><c-w>-
        nnoremap <silent> <c-j> <esc><c-w>+
        nnoremap <silent> <c-h> <esc><c-w><
        nnoremap <silent> <c-l> <esc><c-w>>
        let g:swHotkeysOn=1
    endif
endfunction

"nnoremap <silent> <c-k> mz:m-2<cr>`z
"nnoremap <silent> <c-j> mz:m+<cr>`z
"vnoremap <silent> <c-k> :m'<-2<cr>`>my`<mzgv`yo`z
"vnoremap <silent> <c-j> :m'>+<cr>`<my`>mzgv`yo`z

" make the behavior of space the same as in w3m/vimperator/pentadactyl
"nnoremap <space> <c-f>

set number " whether to display line number
function! GetTextAreaWidth() " this function should be preceded by 'set (no)nu' (otherwise the result won't be correct)
    let @c=''
    if &numberwidth == 1
        let @c=line('$')
        let @c=len(@c)
        if &numberwidth >= @c
            let @c=&columns-&numberwidth
            if &numberwidth == 1 | let @c=@c-1 | endif
        else
            let @c=&columns-@c-1
        endif
    else
        let @c=&columns
    endif
    return @c
endfunction

" highlight lines that are longer than the width of textarea
"nnoremap <silent> <leader>ll :call ToggleHiLongLines()<cr>
function! ToggleHiLongLines()
    if exists('b:hiLongLines') && b:hiLongLines
        highlight clear longLines
        let b:hiLongLines=0
        echo 'highlight long line off'
    else
        highlight longLines ctermbg=darkred gui=undercurl guisp=blue
        let @c=GetTextAreaWidth()+1
        let @c='2match longLines /^.\{'.@c.',\}$/'
        execute @c
        let b:hiLongLines=1
        echo 'highlight long line on'
    endif
endfunction

" highlight lines that are longer than the width of &synmaxcol
"nnoremap <silent> <leader>lL :call ToggleHiLongLines_2()<cr>
function! ToggleHiLongLines_2()
    if exists('b:hiLongLines_2') && b:hiLongLines_2
        DoMatchParen
        highlight clear longLines_2
        let b:hiLongLines_2=0
        echo 'highlight long line(2) off'
    else
        NoMatchParen
        highlight longLines_2 ctermbg=yellow gui=undercurl guisp=yellow
        let @c=&synmaxcol
        let @c='3match longLines_2 /^.\{'.@c.',\}$/'
        execute @c
        let b:hiLongLines_2=1
        echo 'highlight long line(2) on'
    endif
endfunction

" highlight lines that are longer than the width of textarea plus the column where the cursor is located
"nnoremap <silent> <leader>Ll :call ToggleHiLongLines_3()<cr>
function! ToggleHiLongLines_3()
    if exists('b:hiLongLines_3') && b:hiLongLines_3
        DoMatchParen
        highlight clear longLines_3
        let b:hiLongLines_3=0
        echo 'highlight long line(3) off'
    else
        NoMatchParen
        highlight longLines_3 ctermbg=yellow gui=undercurl guisp=yellow
        let @c=col('.')+GetTextAreaWidth()
        let @c='3match longLines_3 /^.\{'.@c.',\}$/'
        execute @c
        let b:hiLongLines_3=1
        echo 'highlight long line(3) on'
    endif
endfunction

nnoremap <leader>e <esc>:tabe<space>
"nnoremap <leader>ta <esc>:tab<space>
nnoremap <silent> <c-p> <esc>gT
nnoremap <silent> <c-n> <esc>gt
"nnoremap <silent> <leader>T <esc>:tabe %<cr>
nnoremap ,tm <esc>:tabmove 0
let g:previous_tab=1

nnoremap <silent> <leader>s <esc>:w<cr>
nnoremap <silent> <leader>S <esc>:w!<cr>
nnoremap <silent> <leader>W <esc>:w !sudo tee >/dev/null '%'<cr>
" not yet finished (doesn't always work, but why?)
"nnoremap <silent> <leader>W <esc>:w !xargs -0 bash -c 'su -- -c "printf '\%s' \"$0\" \"$@\" \| tee >/dev/null '%'" </dev/tty'<cr>
nnoremap <silent> <leader>z <esc>ZZ<cr>

nnoremap <silent> <leader>q <esc>:q<cr>
nnoremap <silent> <leader>Q <esc>:q!<cr>

" :set paste before pasting, and after pasting :set nopaste
" don't use <s-insert> as {lhs} because <s-insert> is usually grabbed by terminal most of the time
nnoremap <c-c> "*y
inoremap <c-c> <esc>`^"*y
vnoremap <c-c> "*ygv
nnoremap <c-v> "*p
inoremap <c-v> <c-o>:set paste<cr><c-r>*<c-o>:set nopaste<cr>
vnoremap <c-v> "*pgv

" not yet finished (vim seems to receive only <c-blah> in <c-s-blah>)
"nnoremap <c-s-c> "+y
"inoremap <c-s-c> <esc>`^"+y
"vnoremap <c-s-c> "+ygv
"nnoremap <c-s-v> "+p
"inoremap <c-s-v> <c-o>:set paste<cr><c-r>+<c-o>:set nopaste<cr>
"vnoremap <c-s-v> "+pgv

if has('gui_running')
    " copy current line or visual block to clipboard
    nnoremap <silent> <a-y> "*Y:let @*=substitute(@*, "\n$", '', '')<cr>:let @+=@*<cr>
    vnoremap <silent> <a-y> "*y:let @*=substitute(@*, "\n$", '', '')<cr>:let @+=@*<cr>
    imap <silent> <a-y> <esc><a-y>
    set winaltkeys=no " don't use alt in menubar
endif

if has('clipboard')
    set clipboard= " for some reason @* will have the same content as @+ after "+y. also see and 'guioptions' and 'mouse'
    "if has('unix') && $DISPLAY == '' | set clipboard+=exclude:.* | else | set clipboard+=exclude:cons\\\|linux\\\|screen.linux | endif
    if has('unix') && $DISPLAY == '' | set clipboard+=exclude:.* | endif
    nnoremap <silent> ,y0 mz"*y0`z:let @*=substitute(@*, "\n$", '', '')<cr>:let @+=@*<cr>
    nnoremap <silent> ,y$ mz"*y$`z:let @*=substitute(@*, "\n$", '', '')<cr>:let @+=@*<cr>
    nnoremap <silent> ,yy "*yy:let @*=substitute(@*, "\n$", '', '')<cr>:let @+=@*<cr>
    nnoremap <silent> ,Y  "*Y:let @*=substitute(@*, "\n$", '', '')<cr>:let @+=@*<cr>
    vnoremap <silent> ,y  "*y:let @*=substitute(@*, "\n$", '', '')<cr>:let @+=@*<cr>
endif

" put cursor to where it was in visual mode after yanking
" (don't map to muy`u or muY`u as it makes vim unable to
" yank to named registers like "ay or something like that.)
vnoremap <silent> y y`]
vnoremap <silent> Y Y`]

" toggle 'set paste' and 'set nopaste'
nnoremap ,p :set paste!<bar>set paste?<cr>

" swap characters/words/lines/paragraphs in normal/visual modes
nnoremap <silent> gcp hxphl
nnoremap <silent> gcn xph
nnoremap <silent> gwp ge"xdiwdwep"xp
nnoremap <silent> gwn "xdiwdwep"xp
nnoremap <silent> glp ddkP
nnoremap <silent> gln ddp
nnoremap <silent> g{  {dap}p{
vnoremap <c-t>    <esc>`.``gvP``P

" fix <c-left> and <c-right> in non-GUI vim
if !has('gui_running') && has('unix')
    execute "set <c-left>=\<esc>[1;5D"
    execute "set <c-right>=\<esc>[1;5C"
endif

" Emacs-like keybindings for insert/command modes
if has('gui_running')
    inoremap <a-b>           <c-left>
    inoremap <a-f>           <c-right>
    inoremap <a-d>           <c-right><c-w>
    inoremap <a-bs>          <c-w>
    inoremap <a-t>           <esc>`^wb"xdiwdwep"xpa
    cnoremap <a-b>           <c-left>
    cnoremap <a-f>           <c-right>
    cnoremap <a-d>           <c-right><c-w>
    cnoremap <a-bs>          <c-w>
    "cnoremap <c-t>
    "cnoremap <a-t>
endif
inoremap <c-a>           <esc>0i
"inoremap <c-e>           <esc>$a
inoremap <c-b>           <left>
inoremap <c-f>           <right>
"inoremap <c-p>           <up>
"inoremap <c-n>           <down>
inoremap <c-j>           <c-j>
inoremap <c-h>           <c-h>
inoremap <c-d>           <delete>
inoremap <c-w>           <c-w>
inoremap <c-u>           <c-u>
inoremap <c-k>           <esc>`^Da
inoremap <c-t>           <esc>`^hxpa
cnoremap <c-a>           <c-b>
cnoremap <c-e>           <c-e>
cnoremap <c-b>           <left>
cnoremap <c-f>           <right>
cnoremap <c-p>           <c-p>
cnoremap <c-n>           <c-n>
cnoremap <c-j>           <c-j>
cnoremap <c-h>           <c-h>
cnoremap <c-d>           <delete>
cnoremap <c-w>           <c-w>
cnoremap <c-u>           <c-u>
cnoremap <c-k>           @
\                                                                                                   <space>
\<c-e>
\<c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h>
\<c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h>
\<c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h><c-h>
\<c-h><c-h><c-h><c-h><c-h><c-h><c-h>
\<c-w>

" toggle line number
nnoremap <silent> <leader>nu <esc>:set number! number?<cr>

" toggle hlsearch (doesn't work while menubar is unhidden)
if has('gui_running')
    nnoremap <silent> <a-h> <esc>:noh<cr>
endif
nnoremap <silent> <leader>h <esc>:noh<cr>

if has('gui_running')
    nnoremap <silent> <a-m> <esc>:if &guioptions =~# 'm' <bar>
            \set guioptions-=m <bar>
            \else <bar>
            \set guioptions+=m <bar>
            \endif<cr>
    nnoremap <silent> <a-t> <esc>:if &guioptions =~# 't' <bar>
            \set guioptions-=t <bar>
            \else <bar>
            \set guioptions+=t <bar>
            \endif<cr>
endif

" move cursor left/right the length of textarea width
function! Zh_n()
    let l:w=GetTextAreaWidth()
    let a:text_to_current_position=getline('.')[0:col('.')-1]
    if len(a:text_to_current_position) > l:w | call cursor(line('.'), col('.')-l:w) | else | call cursor(line('.'),1) | endif
endfunction
function! Zl_n()
    call cursor(line('.'), col('.')+GetTextAreaWidth())
endfunction
nnoremap <silent> zh :call Zh_n()<cr>
nnoremap <silent> zl :call Zl_n()<cr>
noremap <silent> zH zh
noremap <silent> zL zl
function! Zh_v()
    execute "normal! \<esc>"
    execute "normal! gv"
    let l:w=GetTextAreaWidth()
    execute "normal! \<esc>"
    execute "normal! gv"
    execute "normal! ".l:w."h"
    execute "normal! \<esc>"
    execute "normal! gv"
endfunction
function! Zl_v()
    execute "normal! \<esc>"
    execute "normal! gv"
    let l:w=GetTextAreaWidth()
    execute "normal! \<esc>"
    execute "normal! gv"
    execute "normal! ".l:w."l"
    execute "normal! \<esc>"
    execute "normal! gv"
endfunction
vnoremap <silent> zh :<c-w>call Zh_v()<cr>
vnoremap <silent> zl :<c-w>call Zl_v()<cr>

" move screen (not cursor) left/right half of the size of screen
"nnoremap zh zH
"nnoremap zl zL

" change fenc
nnoremap <silent> \tw1 :e ++enc=big5<cr>
nnoremap <silent> \tw2 :e ++enc=euc-tw<cr>
nnoremap <silent> \cn1 :e ++enc=gb18030<cr>
nnoremap <silent> \cn2 :e ++enc=gb2312<cr>
nnoremap <silent> \jp1 :e ++enc=sjis<cr>
nnoremap <silent> \jp2 :e ++enc=euc-jp<cr>
nnoremap <silent> \u8 :e ++enc=utf-8<cr>
nnoremap <silent> \ul :e ++enc=utf-16le<cr>
nnoremap <silent> \ub :e ++enc=utf-16be<cr>
nnoremap <silent> \uu :set fileencoding=utf-8<cr>:set fileformat=unix<cr>

" search
set ignorecase " whether to ignore case when performing search
set nowrapscan " when search reaches bottom, don't search from the top
set smartcase " ignore case if search pattern is all lowercase,case-sensitive otherwise
if has('extra_search')
    set hlsearch " highlight the last found search content
    set noincsearch " whether to jump to the match point when typing search content
endif
set maxmempattern=10000 " default: 1000

" gui (gvim/vimx)
if has('gui') && has('gui_running')
    set guioptions= " for some reason @* will have the same content as @+ after "+y. also see and 'clipboard' and 'mouse'
    "set guioptions=i " clear guioptions, and show only icon

    "set guicursor+=a:block-Cursor-blinkwait800-blinkoff800-blinkon800 " blinking rate of cursor (in millisecond)
    set guicursor=
    set guicursor+=a:block-Cursor-blinkon0

    set nomousehide " when on, the mouse pointer is hidden when typing
    set mousemodel=popup

    " fix <s-insert>
    if has('mouse') | set mouse=a | endif
    map <s-insert> <middlemouse>
    map! <s-insert> <middlemouse>

    if has('unix')
        "function! MaximizeWindow() " not needed if using certain window managers
            "try | call system('silent !wmctrl -i -b add,maximized_vert,maximized_horz -r '.v:windowid) | catch | endtry " or -r :ACTIVE:
            ""try | simalt <f10> | catch | endtry
        "endfunction
        "autocmd GUIEnter * call MaximizeWindow()
    elseif s:win
        "autocmd GUIEnter * simalt ~x
        winpos 0 0
        set columns=130 lines=38
    endif

    set guiheadroom=0
    set guipty
    set guitablabel=
    set guitabtooltip=
else
    if has('mouse') | set mouse= | endif
endif

" font
"set ambiwidth=double " if unsured the width of some char, treat it the doulbe size of ASCII char
if has('gui') && has('gui_running')
    if has('unix')
        if has('xfontset') | set guifontset= | endif
        if !s:mac
            set guifont=Bitstream\ Vera\ Sans\ Mono\ 12px,\ DejaVu\ Sans\ Mono\ 12px,\ Droid\ Sans\ Mono\ 12px,\ Inconsolata\ 12px,\ Terminus\ 12px,\ Monospace\ 12px
            set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\ 12px,\ WenQuanYi\ Zen\ Hei\ Mono\ 12px,\ WenQuanYi\ Bitmap\ Song\ 12px
        else
            set guifont=Monaco:h10:cANSI
            set guifontwide=
        endif
    elseif s:win
        set guifont=DejaVu_Sans_Mono:h12,\ Lucida_Console:h12:cANSI,\ Courier_New:h12:w6.5:cANSI,\ Consolas:h12:w6.5:cANSI
        set guifontwide=PMingLiU,\ MingLiU
    endif
endif

" statusbar
set laststatus=2
if has('statusline')
    set statusline=\%F\ \ %{getcwd()}\ \ [%{strlen(&fileencoding)?&fileencoding:'none'},%{&fileformat},%{&filetype}]%w%h%m%r%=%l,%c/%L\ %P
    "set rulerformat=
    "set titlestring=
    "set iconstring=
endif
if has('cmdline_info')
    set ruler " display the coornidate on the bottom right corner
    set showcmd " display the command being typed on the bottom right corner
endif

" tab and whitespaces
set expandtab " replace \t with space(s)
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab " insert tabs on the start of a line according to context
autocmd FileType make setlocal noexpandtab
"set listchars=
set nolist " whether to show tab as <c-i> and eol as $
" remove trailing whitespaces (use with care) and retain cursor position
function! <sid>StripTrailingWhitespaces()
    let l:l=line('.')
    let l:c=col('.')
    %s/\s\+$//e
    call cursor(l, c)
    "let @/='' " don't uncomment this line
endfunction
autocmd FileWritePre,FileAppendPre,BufWritePre * call <sid>StripTrailingWhitespaces() | retab
"autocmd FileWritePre,FileAppendPre,FilterWritePre,BufWritePre * call <sid>StripTrailingWhitespaces() | retab
" disable auto-commenting and auto-inserting eol
autocmd BufEnter * set formatoptions-=c | set formatoptions-=r | set formatoptions-=o | set formatoptions+=l | set textwidth=0 | set wrapmargin=0
" formatting
"set formatoptions=tcq

" indentation
set autoindent " generate some tab and space in the new line
"if has('smartindent') | set smartindent | endif " do smart autoindenting when starting a new line (Setting this option causes some undesired effects (:h smartindent))
"if has('cindent') | set cindent | endif " enables automatic C program indenting
"set copyindent " copy the previous indentation on autoindenting
"set preserveindent " when changing the indent of the current line, preserve as much of the indent structure as possible

" wrapped lines
nnoremap j          gj
nnoremap k          gk
"nnoremap 0          g0
"nnoremap $          g$
"nnoremap <down>     gj
"nnoremap <up>       gk
nnoremap <home>     g<home>
nnoremap <end>      g<end>
"inoremap <down>     <c-o>gj
"inoremap <up>       <c-o>gk
"inoremap <home>     <c-o>g<home>
"inoremap <end>      <c-o>g<end>
vnoremap j          gj
vnoremap k          gk
"vnoremap 0          g0
"vnoremap $          g$
"vnoremap <down>     gj
"vnoremap <up>       gk
vnoremap <home>     g<home>
vnoremap <end>      g<end>
if has('linebreak')
    set nolinebreak " whether wrap long line by &breakat (when on, the cursor may display in wrong columns on long lines with double-width chars)
    "set breakat=
    "set showbreak=
endif
set display+=lastline " make the screen display as many contents as possible, rather than display @
set scrolloff=0 " minimal number of screen lines to keep above and below the cursor
if has('virtualedit')
    "set virtualedit=
endif
set nowrap " whether to wrap the line automatically
set wrapmargin=0 " number of characters from the right window border where wrapping starts
"set whichwrap=b,s " allow specified keys that move the cursor left/right to move to the previous/next line when the cursor is on the first/last character in the line

" disable sound on errors
set noerrorbells " disalbe the bell when an error message is displayed
set novisualbell
set t_vb=

" fold
if has('folding')
    set foldclose=all
    set foldcolumn=0
    set nofoldenable " close all folds by default. use zi to toggle fold/unfold
    set foldexpr=0
    set foldignore=#
    set foldlevel=0
    set foldlevelstart=-1 " 0:all folds closed; 1:some folds closed; 99:all folds open
    set foldmarker={{{,}}}
    set foldmethod=manual
    set foldminlines=1
    set foldnestmax=20
    set foldopen=block,hor,mark,percent,quickfix,search,tag,undo
    set foldtext=foldtext()
endif

" command line completion
set wildchar=<tab> " start wild expansion in the command line using <tab>
set wildcharm=0
if has('wildignore') | set wildignore=*.o,*.class,*.pyc | endif " ignore these files while expanding wild chars
if has('wildmenu') | set wildmenu | endif " wild char completion menu
try | set wildignorecase | catch | endtry
set wildmode=full
set wildoptions=

" uncategorized
set nomodeline
set history=50 " keep last 50 commands
set scrolljump=1 " minimal number of lines to scroll when the cursor gets off the screen by pressing j/k
if has('title')
    "set icon
    "set title " set the terminal title as filename
endif
set autoread " update the file when the file being change by other programs
"set autowrite " save the file before use :n to switch to next file
"execute 'set textwidth='.GetTextAreaWidth()
set lazyredraw
set textwidth=0
set backspace=2 " the behavior of backspace
set cmdheight=1 " height of command line
set nospell " whether to do spell checking
set showmatch " when type one of the parentheses, briefly jump to the matching one
set matchtime=2 " jump to the matching parenthesis for this period of time. use with 'showmatch'
set showmode " display current mode on the last line (insert/replace/visual/...)
set numberwidth=1 " width of the column line number
set linespace=0 " range between lines
set equalalways " keep the same height and width when splitting the window
if has('writebackup') | set writebackup | endif " overwrite the backup file of the last file. if 'set backup', remove backup file after overwriting, else keep the backup file
set matchpairs+=<:> " making the <> being matched by vim
"if s:win " default shell
    "set shell=C:\\cygwin\\bin\\mintty.exe
    "set shellcmdflag=-e

    "set shell=C:/cygwin/bin/sh.exe
    "set shellcmdflag=-c
"endif
set shortmess=aoOstTI

" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

" remember last cursor position when quitting vim
autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line('$') | execute "normal! g`\"" | execute "normal! zz" | endif

"-- External Commands --"

if s:win
    noremap ,da <esc>:!time<cr>
else
    noremap ,da <esc>:!date<cr>
endif
noremap ,ss <esc>:!
command! -nargs=1 Silent
            \ execute ':silent !'.<q-args>
            \ | execute ':redraw!'

" clear background text
if has('unix')
    command! Cl Silent clear
endif

" input method settings
"set imactivatekey=
"set noimcmdline
"set noimdisable
"set iminsert=0
"set imsearch=0
"set keymap=

"--- Plugin ---"

function! HasPlugin(p)
    return !empty(globpath(&runtimepath, a:p))
endfunction

" Pathogen (must be set up before filetype detection)
if HasPlugin('autoload/pathogen.vim')
    filetype off
    call pathogen#runtime_append_all_bundles()
endif
filetype plugin indent on

if !HasPlugin('plugin/NERD_commenter.vim') " a fallback commenter adapted from https://github.com/tpope/vim-commentary, also see https://github.com/MarcWeber/vim-addon-commenting
    for s:useless_var in [1]
        if exists('g:loaded_commentary') || &compatible || v:version < 700 | break | else | let g:loaded_commentary=1 | endif
        function! s:go(type,...) abort
          if a:0 | let [lnum1, lnum2]=[a:type, a:1] | else | let [lnum1, lnum2]=[line("'["), line("']")] | endif
          let [l, r]=split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
          let uncomment=2
          for lnum in range(lnum1,lnum2)
            let line=matchstr(getline(lnum),'\S.*\s\@<!')
            if line != '' && (stridx(line,l) || line[strlen(line)-strlen(r) : -1] != r) | let uncomment=0 | endif
          endfor
          for lnum in range(lnum1,lnum2)
            let line=getline(lnum)
            if strlen(r) > 2 && l.r !~# '\\' | let line=substitute(line,'\M'.r[0:-2].'\zs\d\*\ze'.r[-1:-1].'\|'.l[0].'\zs\d\*\ze'.l[1:-1],'\=substitute(submatch(0)+1-uncomment,"^0$\\|^-\\d*$",'','')','g') | endif
            if uncomment | let line=substitute(line,'\S.*\s\@<!','\=submatch(0)[strlen(l):-strlen(r)-1]','') | else | let line=substitute(line,'^\%('.matchstr(getline(lnum1),'^\s*').'\|\s*\)\zs.*\S\@<=','\=l.submatch(0).r','') | endif
            call setline(lnum,line)
          endfor
        endfunction
        function! s:undo()
          let [l, r]=split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
          let lnums=[line('.')+1, line('.')-2]
          for [index, dir, bound, line] in [[0, -1, 1, ''], [1, 1, line('$'), '']]
            while lnums[index] != bound && line ==# '' || !(stridx(line,l) || line[strlen(line)-strlen(r) : -1] != r)
              let lnums[index] += dir
              let line=matchstr(getline(lnums[index]+dir),'\S.*\s\@<!')
            endwhile
          endfor
          call s:go(lnums[0], lnums[1])
          silent! call repeat#set("\<plug>CommentaryUndo")
        endfunction
        xmap <silent> <plug>Commentary :<c-u>call <sid>go(line("'<"),line("'>"))<cr>
        nmap <silent> <plug>Commentary :<c-u>set opfunc=<sid>go<cr>g@
        nmap <silent> <plug>CommentaryLine :<c-u>set opfunc=<sid>go<bar>execute 'normal! 'v:count1.'g@_'<cr>
        nmap <silent> <plug>CommentaryUndo :<c-u>call <sid>undo()<cr>
        if !hasmapto('<plug>Commentary') || maparg('\\','n') ==# '' && maparg('\','n') ==# '' " https://github.com/tpope/vim-commentary/blob/master/doc/commentary.txt
          xmap <leader>cc <plug>Commentary
          nmap <leader>cn <plug>Commentary
          nmap <leader>cc <plug>CommentaryLine
          nmap <leader>cu <plug>CommentaryUndo
        endif
    endfor
    autocmd FileType apache set commentstring=#\ %s
endif

" EasyMotion
if HasPlugin('plugin/EasyMotion.vim') | let g:EasyMotion_leader_key=',' | endif

" CSApprox
if HasPlugin('plugin/CSApprox.vim') && !has('gui') | let g:CSApprox_verbose_level=0 | endif " disable error message from CSApprox

" netrw
if HasPlugin('plugin/netrwPlugin.vim')
    "if has('unix') && ($USER == 'root') || ($SSH_TTY != '')
        let g:netrw_dirhistmax=0
        let g:netrw_dirhist_cnt=0
        "autocmd VimLeave * if (filereadable(split(&runtimepath,',')[0].'/.netrwhist')) | call delete(split(&runtimepath,',')[0].'/.netrwhist') | endif
    "else
    "endif

    "let g:netrw_bookmarklist=['','']

    if has('unix')
        if g:my_fm =~ '^[a-z]*sh '
            let g:loaded_netrwFileHandlers=1
            let g:netrw_browsex_viewer=g:my_fm
        elseif executable(g:my_fm)
            let g:loaded_netrwFileHandlers=1
            let g:netrw_browsex_viewer="sh -c '".shellescape(g:my_fm, 1)." \"$0\" \"$@\" &'"
        else
            if exists('g:loaded_netrwFileHandlers') | unlet g:loaded_netrwFileHandlers | endif
            let g:netrw_browsex_viewer='-'
            function! NFH_mp3(filename)
                execute "silent !bash -ic 'x \"$0\" \"$@\"' ".shellescape(escape(a:filename,'"'), 1).' >/dev/null 2>&1'
            endfunction
        endif
    elseif s:win
        let g:netrw_browsex_viewer=g:my_fm
    endif
    if exists('g:netrw_nogx') | unlet g:netrw_nogx | endif

    let g:netrw_banner=0
    let g:netrw_browse_split=3             " 3: <cr> will open file in a new tab
    let g:netrw_fastbrowse=1               " use with care as this option affects some options like g:netrw_browse_split
    let g:netrw_liststyle=0                " 0: one file per line; 1: one file per line w/ timestamps; 2: multiple files per line; 3: tree

    let g:netrw_keepdir=0                  " 0: dir becomes b:netrw_curdir; 1: keep dir on its own
    "autocmd BufEnter * silent! lcd %:p:h  " acd w/o the netrw bug; force g:netrw_keepdir to be 0

    let g:netrw_use_errorwindow=0          " 0: messages from netrw will use echoerr; 1: use a separate one line window

    let g:netrw_xstrlen=0                  " control how netrw computes string lengths
else
    if exists('+autochdir') | set autochdir | endif " auto cd to the directory of the new open file
endif

" ydict
if HasPlugin('util/ydict') && has('unix')
    if !has('gui_running')
        nnoremap <silent> <leader>yd viwy:Silent screen sh -c '$HOME/.vim/util/ydict <c-r>" \| less -R'<cr>
    else
        nnoremap <silent> <leader>yd viwy:Silent <c-r>=g:my_xterm<cr> sh -c '$HOME/.vim/util/ydict <c-r>" \| less -R' &<cr>
    endif
endif

"--- Key mappings for programming languages ---"

" key mapping just like double click the file
if !exists('*MySave')
    function MySave()
        if &modified | w | endif
    endfunction
    function MySave_2()
        if &modified | w! | endif
    endfunction
    command! W :call MySave()
    command! WW :call MySave_2()
endif

if mapcheck('<f10>','n') == ''
    if has('unix')
        autocmd BufNewFile,BufReadPre * nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_fm<cr> '%' >/dev/null 2>&1 &<cr>
    elseif s:win
        autocmd BufNewFile,BufReadPre * nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c explorer.exe "%" & exit<cr>
        "autocmd BufNewFile,BufReadPre * nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c start "" /b "%" & exit<cr>
    endif
    autocmd BufNewFile * execute 'set filetype='.&filetype
endif

""" AutoHotkey
if s:win
    autocmd FileType autohotkey nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c start "" /b AutoHotkey.exe "%"<cr>
endif

""" Bash
if has('unix')
    if !has('gui_running')
        autocmd FileType sh nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent screen sh -c 'bash '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
    else
        autocmd FileType sh nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c 'bash '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
    endif
endif

""" Batch (.bat, .cmd, ...)
if s:win
    autocmd FileType dosbatch nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c "%" & pause<cr>
endif

""" Help
" help in new tab
nnoremap <leader>m  <esc>:tab<space>h<space>
nnoremap ,mm        <esc>:tab<space>h<space>
" help in current tab
nnoremap <leader>M  <esc>:h<space>
nnoremap ,mM        <esc>:h<space>
if has('unix')
    "autocmd FileType help,vim nnoremap K mUwb:tab help <c-r><c-w><cr>`U<c-^>
    autocmd FileType help,vim nnoremap K muwb"zyw`u:execute "tab help ".@z.""<cr>
    autocmd FileType man set nonumber|set keywordprg=bash\ -ic\ 'm\ \\"$0\\"\ \\"$@\\"'
endif
set helplang=en

""" HTML and the likes
if s:win
    autocmd FileType html nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c start "" /b firefox "%"<cr>
else
    autocmd FileType html nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent firefox '%' >/dev/null 2>&1 &<cr>
endif

""" C/C++
if has('unix')
    if !has('gui_running')
        autocmd FileType c,cpp nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent screen sh -c ''\''./%:r.out'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
        autocmd FileType c,cpp nnoremap <silent> <buffer> <f11> <esc>:W<cr>:Silent screen sh -c 'c++ '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
    else
        autocmd FileType c,cpp nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c ''\''./%:r.out'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
        autocmd FileType c,cpp nnoremap <silent> <buffer> <f11> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c 'c++ '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
    endif
elseif s:win
    autocmd FileType c,cpp nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c "%:r.exe" & pause<cr>
    autocmd FileType c,cpp nnoremap <silent> <buffer> <f11> <esc>:W<cr>:Silent start cmd.exe /c c++ "%" & pause<cr>
endif

""" Java
if has('quickfix')
    autocmd FileType java set makeprg=javac\ -d\ .\ %
    autocmd FileType java set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
endif
if has('unix')
    if !has('gui_running')
        autocmd FileType java nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent screen sh -c 'java '\''%:r'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
        autocmd FileType java nnoremap <silent> <buffer> <f11> <esc>:W<cr>:Silent screen sh -c 'javac '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
    else
        autocmd FileType java nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c 'java '\''%:r'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
        autocmd FileType java nnoremap <silent> <buffer> <f11> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c 'javac '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
    endif
elseif s:win
    autocmd FileType java nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c java "%:r" & pause<cr>
    autocmd FileType java nnoremap <silent> <buffer> <f11> <esc>:W<cr>:Silent start cmd.exe /c javac "%" & pause<cr>
endif

""" JavaScript
if has('unix')
    if !has('gui_running')
        autocmd FileType javascript nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent screen sh -c 'js '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
    else
        autocmd FileType javascript nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c 'js '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
    endif
elseif s:win
    autocmd FileType javascript nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c js "%" & pause<cr>
endif

""" Perl
if has('unix')
    if !has('gui_running')
        autocmd FileType perl nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent screen sh -c 'perl '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
    else
        autocmd FileType perl nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c 'perl '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
    endif
elseif s:win
    autocmd FileType perl nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c perl "%" & pause<cr>
endif

""" Python
if has('quickfix')
    " compile .py to .pyc
    autocmd FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(ur'%')\"
    autocmd FileType python nnoremap <silent> <f11> <esc>:W<cr>:make<cr>
    autocmd FileType python set errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
endif
"autocmd FileType python copen " open the compilation window
if has('unix')
    if !has('gui_running') " Python has so many versions; use bash -ic (.bashrc) to determine which one to use
        autocmd FileType python nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent screen bash -ic 'python '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
    else
        autocmd FileType python nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> bash -ic 'python '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
    endif
    "if !has('gui_running')
        "autocmd FileType python nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent screen sh -c 'python '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
    "else
        "autocmd FileType python nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c 'python '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
    "endif
elseif s:win " save -> exec
    " in cmd.exe
    "autocmd FileType python nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c C:\\cygwin\\bin\\python "%" & pause<cr>
    autocmd FileType python nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c python "%" & pause<cr>

    " in mintty.exe
    "autocmd FileType python nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start mintty -e sh -c 'python '\''%'\''; printf "\%s\n" "press Enter to continue..."; read -r tmp;'<cr>

    " in sh.exe
    "autocmd FileType python nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent python "%"; printf "\%s\n" "press Enter to continue..."; read -r tmp;<cr>
endif

" pydiction
if HasPlugin('after/ftplugin/python_pydiction.vim')
    if has('unix')
        let g:pydiction_location=$HOME.'/.vim/bundle/Pydiction(python_code_tab_completion)/ftplugin/complete-dict'
    elseif s:win
        let g:pydiction_location=$HOME.'/vimfiles/bundle/Pydiction(python_code_tab_completion)/ftplugin/complete-dict'
    endif
endif

" search for the word under cursor using Pydoc (for non-gui vim)
if has('unix')
    if !has('gui_running')
        "execute "set <f1>=\<esc>[11~" " puTTY mode -> Terminal -> Keyboard -> The function keys and keypad -> ESC[n~
        "execute "set <f1>=\<esc>OP"   " puTTY mode -> Terminal -> Keyboard -> The function keys and keypad -> Xterm R6
        autocmd FileType python nnoremap <silent> <buffer> <leader>f1
\ :let save_isk=&iskeyword \|
\ set iskeyword+=. \|
\ execute "Silent screen sh -c \"pydoc " . expand('<cword>') . "\"" \|
\ let &iskeyword=save_isk<cr>
    else
        autocmd FileType python nnoremap <silent> <buffer> <leader>f1
\ :let save_isk=&iskeyword \|
\ set iskeyword+=. \|
\ execute "Silent <c-r>=g:my_xterm<cr> sh -c \"pydoc " . expand('<cword>') . "\" &" \|
\ let &iskeyword=save_isk<cr>
    endif
elseif s:win
    "...
endif

" PyFlakes
if HasPlugin('ftplugin/python/pyflakes*') | let g:pyflakes_use_quickfix=0 | endif " disable the use of quickfix support

""" SQL
if has('unix')
    if !has('gui_running')
        autocmd FileType sql nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent screen sh -c 'sqlite3 '\''%:r.db'\'' < '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;'<cr>
    else
        autocmd FileType sql nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent <c-r>=g:my_xterm<cr> sh -c 'sqlite3 '\''%:r.db'\'' < '\''%'\'' ; printf "\%s\n" "press ENTER to continue..."; read -r tmp;' &<cr>
    endif
elseif s:win
    autocmd FileType sql nnoremap <silent> <buffer> <f10> <esc>:W<cr>:Silent start cmd.exe /c start "" /b sqlite3 "%:r.db" < "%" & pause<cr>
endif

" open terminal emulator in current working directory
"nnoremap <leader>t :lcd %:p:h<cr>:Silent <c-r>=g:my_xterm<cr> sh -c "cd <c-r>=shellescape(escape(getcwd(),'"'),1)<cr>; exec $SHELL" &<cr>
nnoremap <leader>t :Silent <c-r>=g:my_xterm<cr> sh -c "cd <c-r>=shellescape(escape(expand('%:p:h'),'"'),1)<cr>; exec $SHELL" &<cr>

" map <f10>/<f11> in insert mode
autocmd BufNewFile,BufReadPost * if (mapcheck('<f10>') != '') | execute 'imap <silent> <buffer> <f10> <esc><f10>' | endif
autocmd BufNewFile,BufReadPost * if (mapcheck('<f11>') != '') | execute 'imap <silent> <buffer> <f11> <esc><f11>' | endif

" mkview and loadview automatically
if has('mksession')
    "autocmd BufWinLeave * if expand('%') != '' | mkview | endif
    "autocmd BufWinEnter * if expand('%') != '' | loadview | endif
endif

" add more filetype
autocmd BufNewFile,BufRead *.vimperatorrc,*_vimperatorrc,*.pentadactylrc,*_pentadactylrc set filetype=vim

" echo current file type
command! EchoFileType :call ReturnFileType()
function! ReturnFileType()
    echo &filetype
endfunction

" echo current path and name of current file
command! EchoFileName :call ReturnFileName()
function! ReturnFileName()
    echo expand('%:p')
endfunction

"--- Color and Syntax ---"
if has('syntax') && ((&t_Co>2)||has('gui_running')) | syntax enable | endif " don't add && !exists('syntax_on')

" maximum column in which to search for syntax items (avoid setting synmaxcol to small number, or it causes some problems)
"execute 'set synmaxcol='.GetTextAreaWidth()
set synmaxcol=1024

" first set the number of colors that vim supports, then set colorscheme
" don't use system('tty') to check if is in tty, as that method isn't necessarily accurate (even in tty it may echo 'not a tty')
" speed up the checking procedure by carefully ordering the checking sequence
if has('unix')
    if has('gui_running') || ($COLORTERM =~ '^rxvt*') || (&term =~ 'xterm')
        set t_Co=256
    elseif &term == 'linux'
        set t_Co=8
    elseif &term =~ 'screen'
        if &term == 'screen-bce'
            if $DISPLAY != '' | set t_Co=256 | else | set t_Co=8 | endif " alternative: ($WINDOWPATH != '') && ($WINDOWID != '')
        elseif &term == 'screen.linux' " install ncurses-term s.t. screen.linux appears in terminfo
            set t_Co=8
        else
            let s:tty_type=system('ps cux | awk '."'".' $7 != "?" '."'".' | grep "\<screen\>" | sort -k9n | tail -n1 | awk '."'".'{print $7}'."'".'')
            if s:tty_type =~ 'tty' | set t_Co=8 | else | set t_Co=256 | endif
        endif
    elseif &term == 'rxvt-unicode'
        set t_Co=88
    elseif (&term =~ '256') || (&term =~ 'color')
        set t_Co=256
    else
        set t_Co=8
    endif
elseif s:win
    if has('gui_running') | set t_Co=256 | else | set t_Co=8 | endif
endif

if &t_Co == 256
    execute "set t_AB=\<esc>[48;5;%dm"
    execute "set t_AF=\<esc>[38;5;%dm"
endif

function! MyColorScheme() " https://github.com/briancarper/gentooish.vim
    " Vim color file
    " Name:    gentooish.vim
    " Author:  Brian Carper<brian@briancarper.net>
    " Version: 0.4

    set background=dark
    highlight clear
    if exists('syntax_on') | syntax reset | endif

    let g:colors_name="gentooish"

    highlight Normal gui=NONE   guifg=#cccccc   guibg=#191919 ctermfg=252 ctermbg=234
    highlight IncSearch gui=NONE   guifg=#000000   guibg=#8bff95 term=reverse ctermfg=16 ctermbg=120
    highlight Search gui=NONE   guifg=#cccccc   guibg=#863132 term=reverse ctermfg=252 ctermbg=95
    highlight ErrorMsg gui=NONE   guifg=#cccccc   guibg=#863132 term=standout ctermfg=252 ctermbg=95
    highlight WarningMsg gui=NONE   guifg=#cccccc   guibg=#863132 term=standout ctermfg=252 ctermbg=95
    highlight ModeMsg gui=NONE   guifg=#cccccc   guibg=NONE term=bold ctermfg=252
    highlight MoreMsg gui=NONE   guifg=#cccccc   guibg=NONE term=bold ctermfg=252
    highlight Question gui=NONE   guifg=#cccccc   guibg=NONE term=standout ctermfg=252
    highlight StatusLine gui=BOLD   guifg=#cccccc   guibg=#333333 term=bold,reverse cterm=bold ctermfg=252 ctermbg=236
    highlight User1 gui=BOLD   guifg=#999999   guibg=#333333 cterm=bold ctermfg=246 ctermbg=236
    highlight User2 gui=BOLD   guifg=#8bff95   guibg=#333333 cterm=bold ctermfg=120 ctermbg=236
    highlight StatusLineNC gui=NONE   guifg=#999999   guibg=#333333 term=reverse cterm=bold ctermfg=240 ctermbg=236
    highlight VertSplit gui=NONE   guifg=#cccccc   guibg=#333333 term=reverse ctermfg=252 ctermbg=236
    highlight WildMenu gui=BOLD   guifg=#cf7dff   guibg=#1F0F29 term=standout cterm=bold ctermfg=177 ctermbg=16
    highlight DiffText gui=NONE   guifg=#000000  guibg=#4cd169 term=reverse ctermfg=16 ctermbg=77
    highlight DiffChange gui=NONE   guifg=NONE     guibg=#541691 term=bold ctermbg=54
    highlight DiffDelete gui=NONE   guifg=#cccccc  guibg=#863132 term=bold ctermfg=252 ctermbg=95
    highlight DiffAdd gui=NONE   guifg=#cccccc  guibg=#306d30 term=bold ctermfg=252 ctermbg=59
    highlight Cursor gui=NONE   guifg=#000000   guibg=#8bff95 ctermfg=16 ctermbg=120
    highlight Folded gui=NONE   guifg=#aaa400   guibg=#000000 term=standout ctermfg=142 ctermbg=16
    highlight FoldColumn gui=NONE   guifg=#cccccc   guibg=#000000 term=standout ctermfg=252 ctermbg=16
    highlight Directory gui=NONE   guifg=#8bff95   guibg=NONE term=bold ctermfg=120
    highlight LineNr gui=NONE   guifg=#bbbbbb   guibg=#222222 term=underline ctermfg=250 ctermbg=235
    highlight NonText gui=NONE   guifg=#555555   guibg=NONE term=bold ctermfg=240
    highlight SpecialKey gui=NONE   guifg=#6f6f2f   guibg=NONE term=bold ctermfg=58
    highlight Title gui=NONE   guifg=#9a383a   guibg=NONE term=bold ctermfg=95
    highlight Comment gui=NONE   guifg=#666666   guibg=NONE term=bold ctermfg=241
    highlight Constant gui=NONE   guifg=#b8bb00   guibg=NONE term=underline ctermfg=142
    highlight Boolean gui=NONE   guifg=#00ff00   guibg=NONE ctermfg=46 ctermfg=46
    highlight String gui=NONE   guifg=#5dff9e   guibg=#0f291a ctermfg=85 ctermbg=16 ctermfg=85 ctermbg=16
    highlight Error gui=NONE   guifg=#990000   guibg=#000000 term=reverse ctermfg=88 ctermbg=16 term=reverse ctermfg=88 ctermbg=16
    highlight Identifier gui=NONE   guifg=#4cbbd1   guibg=NONE term=underline ctermfg=74 term=underline ctermfg=74
    highlight Ignore gui=NONE   guifg=#555555 ctermfg=240 ctermfg=240
    highlight Number gui=NONE   guifg=#ddaa66   guibg=NONE ctermfg=179 ctermfg=179
    highlight PreProc gui=NONE   guifg=#9a383a   guibg=NONE term=underline ctermfg=95 term=underline ctermfg=95
    highlight Special gui=NONE   guifg=#ffcd8b   guibg=NONE term=bold ctermfg=222 term=bold ctermfg=222
    highlight Statement gui=NONE   guifg=#4cd169   guibg=NONE term=bold ctermfg=77 term=bold ctermfg=77
    highlight Todo gui=NONE   guifg=#cccccc   guibg=#863132 term=standout ctermfg=252 ctermbg=95 term=standout ctermfg=252 ctermbg=95
    highlight Type gui=NONE   guifg=#c476f1   guibg=NONE term=underline ctermfg=177 term=underline ctermfg=177
    highlight Underlined gui=UNDERLINE   guifg=#cccccc   guibg=NONE term=underline cterm=underline ctermfg=252 term=underline cterm=underline ctermfg=252
    highlight Visual gui=reverse guifg=#6e4287   guibg=#ffffff term=reverse ctermfg=231 ctermbg=60
    highlight VisualNOS gui=NONE   guifg=#cccccc   guibg=#000000 term=bold,underline ctermfg=252 ctermbg=16
    highlight CursorLine gui=NONE   guifg=NONE      guibg=#222222 term=underline ctermbg=235
    highlight CursorColumn gui=NONE   guifg=NONE      guibg=#222222 term=reverse ctermbg=235
    highlight lispList gui=NONE   guifg=#555555
    highlight Pmenu gui=NONE   guifg=#cccccc   guibg=#222222 ctermfg=252 ctermbg=235
    highlight PMenuSel gui=BOLD   guifg=#c476f1   guibg=#000000
    highlight PmenuSbar gui=NONE   guifg=#cccccc   guibg=#000000 ctermfg=252 ctermbg=16
    highlight PmenuThumb gui=NONE   guifg=#cccccc   guibg=#333333 ctermfg=252 ctermbg=236
    highlight SpellBad gui=undercurl guisp=#cc6666 term=reverse cterm=undercurl ctermfg=167
    highlight SpellRare gui=undercurl guisp=#cc66cc term=reverse cterm=undercurl ctermfg=170
    highlight SpellLocal gui=undercurl guisp=#cccc66 term=underline cterm=undercurl ctermfg=185
    highlight SpellCap gui=undercurl guisp=#66cccc term=reverse cterm=undercurl ctermfg=80
    highlight MatchParen gui=NONE      guifg=#ffffff   guibg=#005500 term=reverse ctermfg=231 ctermbg=22
    highlight SpecialKey gui=NONE   guifg=#6f6f2f   guibg=NONE term=bold ctermfg=58
    highlight NonText gui=NONE   guifg=#555555   guibg=NONE term=bold ctermfg=240
    highlight Directory gui=NONE   guifg=#8bff95   guibg=NONE term=bold ctermfg=120
    highlight ErrorMsg gui=NONE   guifg=#cccccc   guibg=#863132 term=standout ctermfg=252 ctermbg=95
    highlight IncSearch gui=NONE   guifg=#000000   guibg=#8bff95 term=reverse ctermfg=16 ctermbg=120
    highlight Search gui=NONE   guifg=#cccccc   guibg=#863132 term=reverse ctermfg=252 ctermbg=95
    highlight MoreMsg gui=NONE   guifg=#cccccc   guibg=NONE term=bold ctermfg=252
    highlight ModeMsg gui=NONE   guifg=#cccccc   guibg=NONE term=bold ctermfg=252
    highlight LineNr gui=NONE   guifg=#bbbbbb   guibg=#222222 term=underline ctermfg=250 ctermbg=235
    highlight Question gui=NONE   guifg=#cccccc   guibg=NONE term=standout ctermfg=252
    highlight StatusLine gui=BOLD   guifg=#cccccc   guibg=#333333 term=bold,reverse cterm=bold ctermfg=252 ctermbg=236
    highlight StatusLineNC gui=NONE   guifg=#999999   guibg=#333333 term=reverse cterm=bold ctermfg=240 ctermbg=236
    highlight VertSplit gui=NONE   guifg=#cccccc   guibg=#333333 term=reverse ctermfg=252 ctermbg=236
    highlight Title gui=NONE   guifg=#9a383a   guibg=NONE term=bold ctermfg=95
    highlight Visual gui=reverse guifg=#6e4287   guibg=#ffffff term=reverse ctermfg=231 ctermbg=60
    highlight VisualNOS gui=NONE   guifg=#cccccc   guibg=#000000 term=bold,underline ctermfg=252 ctermbg=16
    highlight WarningMsg gui=NONE   guifg=#cccccc   guibg=#863132 term=standout ctermfg=252 ctermbg=95
    highlight WildMenu gui=BOLD   guifg=#cf7dff   guibg=#1F0F29 term=standout cterm=bold ctermfg=177 ctermbg=16
    highlight Folded gui=NONE   guifg=#aaa400   guibg=#000000 term=standout ctermfg=142 ctermbg=16
    highlight FoldColumn gui=NONE   guifg=#cccccc   guibg=#000000 term=standout ctermfg=252 ctermbg=16
    highlight DiffAdd gui=NONE   guifg=#cccccc  guibg=#306d30 term=bold ctermfg=252 ctermbg=59
    highlight DiffChange gui=NONE   guifg=NONE     guibg=#541691 term=bold ctermbg=54
    highlight DiffDelete gui=NONE   guifg=#cccccc  guibg=#863132 term=bold ctermfg=252 ctermbg=95
    highlight DiffText gui=NONE   guifg=#000000  guibg=#4cd169 term=reverse ctermfg=16 ctermbg=77
    highlight SignColumn  term=standout ctermfg=51 ctermbg=250
    highlight SignColumn  term=standout ctermfg=51 ctermbg=250
    highlight TabLine  term=underline cterm=underline ctermbg=248
    highlight TabLine  term=underline cterm=underline ctermbg=248
    highlight TabLineSel  term=bold cterm=bold
    highlight TabLineSel  term=bold cterm=bold
    highlight TabLineFill  term=reverse ctermfg=234 ctermbg=252
    highlight TabLineFill  term=reverse ctermfg=234 ctermbg=252
    highlight CursorColumn gui=NONE   guifg=NONE      guibg=#222222 term=reverse ctermbg=235
    highlight CursorLine gui=NONE   guifg=NONE      guibg=#222222 term=underline ctermbg=235
    highlight Cursor gui=NONE   guifg=#000000   guibg=#8bff95 ctermfg=16 ctermbg=120
    highlight lCursor  ctermfg=234 ctermbg=252
    highlight lCursor  ctermfg=234 ctermbg=252
    highlight Normal gui=NONE   guifg=#cccccc   guibg=#191919 ctermfg=252 ctermbg=234
    highlight Comment gui=NONE   guifg=#666666   guibg=NONE term=bold ctermfg=241
    highlight Constant gui=NONE   guifg=#b8bb00   guibg=NONE term=underline ctermfg=142
    highlight Special gui=NONE   guifg=#ffcd8b   guibg=NONE term=bold ctermfg=222 term=bold ctermfg=222
    highlight Identifier gui=NONE   guifg=#4cbbd1   guibg=NONE term=underline ctermfg=74 term=underline ctermfg=74
    highlight Statement gui=NONE   guifg=#4cd169   guibg=NONE term=bold ctermfg=77 term=bold ctermfg=77
    highlight PreProc gui=NONE   guifg=#9a383a   guibg=NONE term=underline ctermfg=95 term=underline ctermfg=95
    highlight Type gui=NONE   guifg=#c476f1   guibg=NONE term=underline ctermfg=177 term=underline ctermfg=177
    highlight Underlined gui=UNDERLINE   guifg=#cccccc   guibg=NONE term=underline cterm=underline ctermfg=252 term=underline cterm=underline ctermfg=252
    highlight Ignore gui=NONE   guifg=#555555 ctermfg=240 ctermfg=240
    highlight Error gui=NONE   guifg=#990000   guibg=#000000 term=reverse ctermfg=88 ctermbg=16 term=reverse ctermfg=88 ctermbg=16
    highlight Todo gui=NONE   guifg=#cccccc   guibg=#863132 term=standout ctermfg=252 ctermbg=95 term=standout ctermfg=252 ctermbg=95
    highlight String gui=NONE   guifg=#5dff9e   guibg=#0f291a ctermfg=85 ctermbg=16 ctermfg=85 ctermbg=16
    highlight Number gui=NONE   guifg=#ddaa66   guibg=NONE ctermfg=179 ctermfg=179
    highlight Boolean gui=NONE   guifg=#00ff00   guibg=NONE ctermfg=46 ctermfg=46
    highlight Special gui=NONE   guifg=#ffcd8b   guibg=NONE term=bold ctermfg=222 term=bold ctermfg=222
    highlight Identifier gui=NONE   guifg=#4cbbd1   guibg=NONE term=underline ctermfg=74 term=underline ctermfg=74
    highlight Statement gui=NONE   guifg=#4cd169   guibg=NONE term=bold ctermfg=77 term=bold ctermfg=77
    highlight PreProc gui=NONE   guifg=#9a383a   guibg=NONE term=underline ctermfg=95 term=underline ctermfg=95
    highlight Type gui=NONE   guifg=#c476f1   guibg=NONE term=underline ctermfg=177 term=underline ctermfg=177
    highlight Underlined gui=UNDERLINE   guifg=#cccccc   guibg=NONE term=underline cterm=underline ctermfg=252
    highlight Ignore gui=NONE   guifg=#555555 ctermfg=240 ctermfg=240
    highlight Error gui=NONE   guifg=#990000   guibg=#000000 term=reverse ctermfg=88 ctermbg=16 term=reverse ctermfg=88 ctermbg=16
    highlight Todo gui=NONE   guifg=#cccccc   guibg=#863132 term=standout ctermfg=252 ctermbg=95 term=standout ctermfg=252 ctermbg=95
    highlight String gui=NONE   guifg=#5dff9e   guibg=#0f291a ctermfg=85 ctermbg=16 ctermfg=85 ctermbg=16
    highlight Number gui=NONE   guifg=#ddaa66   guibg=NONE ctermfg=179 ctermfg=179
    highlight Boolean gui=NONE   guifg=#00ff00   guibg=NONE ctermfg=46 ctermfg=46
    highlight User1 gui=BOLD   guifg=#999999   guibg=#333333 cterm=bold ctermfg=246 ctermbg=236
    highlight User2 gui=BOLD   guifg=#8bff95   guibg=#333333 cterm=bold ctermfg=120 ctermbg=236
    if v:version >= 700
        highlight SpellBad gui=undercurl guisp=#cc6666 term=reverse cterm=undercurl ctermfg=167
        highlight SpellCap gui=undercurl guisp=#66cccc term=reverse cterm=undercurl ctermfg=80
        highlight SpellRare gui=undercurl guisp=#cc66cc term=reverse cterm=undercurl ctermfg=170
        highlight SpellLocal gui=undercurl guisp=#cccc66 term=underline cterm=undercurl ctermfg=185
        highlight Pmenu gui=NONE   guifg=#cccccc   guibg=#222222 ctermfg=252 ctermbg=235
        highlight PmenuSel  cterm=bold ctermfg=177 ctermbg=16
        highlight PmenuSel  cterm=bold ctermfg=177 ctermbg=16
        highlight PmenuSbar gui=NONE   guifg=#cccccc   guibg=#000000 ctermfg=252 ctermbg=16
        highlight PmenuThumb gui=NONE   guifg=#cccccc   guibg=#333333 ctermfg=252 ctermbg=236
        highlight MatchParen gui=NONE      guifg=#ffffff   guibg=#005500 term=reverse ctermfg=231 ctermbg=22
    endif
endfunction
function! MyColorScheme_2() " not yet finished
    colorscheme pablo
endfunction

function! HasColorscheme(name)
    return !empty(globpath(&runtimepath, 'colors/'.a:name.'.vim'))
endfunction

function! SetColorsName(name) " some careless color plugins forget to set g:colors_name. Use this function to fix it
    execute "let g:colors_name='".a:name."'"
endfunction

let s:use_hardcoded_colorscheme=1
let s:used_my_color_scheme_already=0 " don't change its value
if s:use_hardcoded_colorscheme == 1
    if &t_Co >= 256
        try | call MyColorScheme()   | if exists('g:colors_name') | unlet g:colors_name | endif | let s:used_my_color_scheme_already=1 | catch | let s:used_my_color_scheme_already=0 | endtry
    elseif &t_Co >= 88
        try | call MyColorScheme_2() | if exists('g:colors_name') | unlet g:colors_name | endif | let s:used_my_color_scheme_already=1 | catch | let s:used_my_color_scheme_already=0 | endtry
    else
        let s:used_my_color_scheme_already=0
    endif
else
    if &t_Co >= 256
        let s:my_color_schemes=['gentooish', 'zenburn', 'molokai'] | for s:e in s:my_color_schemes | if HasColorscheme(s:e) | execute 'colo '.s:e | call SetColorsName(s:e) | let s:used_my_color_scheme_already=1 | break | endif | endfor
    elseif &t_Co >= 88
        let s:my_color_schemes=['pablo']                           | for s:e in s:my_color_schemes | if HasColorscheme(s:e) | execute 'colo '.s:e | call SetColorsName(s:e) | let s:used_my_color_scheme_already=1 | break | endif | endfor
    else
        let s:used_my_color_scheme_already=0
    endif
endif
let s:default_color_schemes=['darkblue', 'blue'] | if s:used_my_color_scheme_already == 0 | for s:e in s:default_color_schemes | if HasColorscheme(s:e) | execute 'colo '.s:e | call SetColorsName(s:e) | break | endif | endfor | endif

" === highlight all occurences of the word under cursor ===
" to change the color of highlight=> :source $VIMRUNTIME/syntax/hitest.vim
" the original statement is buggy; the following is the refined version
" characters to be removed: ~, [, /, \,
if s:used_my_color_scheme_already == 1
    "let s:my_highlight='MatchParen'
    highlight myGroup term=reverse ctermfg=black ctermbg=darkcyan guifg=black guibg=darkcyan
    let s:my_highlight='myGroup'
else
    "let s:my_highlight='ColorColumn'
    highlight myGroup term=reverse ctermfg=black ctermbg=darkcyan guifg=black guibg=darkcyan
    let s:my_highlight='myGroup'
endif
"autocmd CursorMoved * silent! execute printf('match '.s:my_highlight.' /\<%s\>/', escape(expand('<cword>'), '*~[]/\'))
autocmd CursorMoved * execute printf('match '.s:my_highlight.' /\<%s\>/', escape(expand('<cword>'), '*~[]/\'))

if exists('g:colors_name') && g:colors_name == 'molokai' | let g:molokai_original=1 | endif " 1: match the original molokai background color (note that this line must precede 'colo molokai')

" cursorline, cursorcolumn and cursor color
set cursorline
set nocursorcolumn
" disable special attributes (ex: underline/bold/...) of cursorline and its corresponding line number
highlight CursorLine   term=NONE cterm=NONE gui=NONE
highlight CursorLineNr term=NONE cterm=NONE gui=NONE
highlight CursorColumn term=NONE cterm=NONE gui=NONE
" toggle cursorline and cursor color upon entering/leaving insert mode
highlight Cursor guifg=black guibg=yellow
autocmd InsertEnter * set nocursorline | highlight Cursor guifg=black guibg=red
autocmd InsertLeave * set cursorline | highlight Cursor guifg=black guibg=yellow
" note that the usage of &t_SI and &t_EI will drastically reduce the speed of tetris.vim
if &term =~ 'xterm\|rxvt' " if instead using double quotes, \ should be replaced with \\
    " http://vim.wikia.com/wiki/Configuring_the_cursor
    let &t_SI="\<esc>]12;red\x7"
    let &t_EI="\<esc>]12;yellow\x7"
    "if &term =~ '^xterm'
        "let &t_SI.="\<esc>[2 q" " solid block
        "let &t_EI.="\<esc>[2 q" " solid block
        ""autocmd VimLeave * silent !printf '\%b\n' "\e[2 q"
    "endif
    "autocmd VimLeave * silent !printf '\%b' "\033]12;yellow\007"
elseif &term =~ 'screen'
    if &t_Co > 8
        " http://arniealmighty.wordpress.com/2010/07/
        let &t_SI="\<esc>P\<esc>]12;red\x7\<esc>\\"
        let &t_EI="\<esc>P\<esc>]12;yellow\x7\<esc>\\"
        "if &term =~ '^xterm'
            "let &t_SI.="\<esc>P\<esc>[2 q\<esc>\\" " solid block
            "let &t_EI.="\<esc>P\<esc>[2 q\<esc>\\" " solid block
            ""autocmd VimLeave * silent !printf '\%b\n' "\eP\e[2 q\e\\"
        "endif
        "autocmd VimLeave * silent !printf '\%b' "\033P\033]12;yellow\007\033\\"
    else
        " not yet finished
    endif
elseif &term == 'linux' " not yet finished
    " http://linuxgazette.net/137/anonymous.html
    " http://www.emacswiki.org/emacs/CursorOnLinuxConsole
    " http://tech.groups.yahoo.com/group/vim/message/25909
    " 14: light color; 0: dim color
    let &t_SI="\<esc>[?17;14;64c"
    let &t_EI="\<esc>[?17;14;224c"
    "let &t_SI="\<esc>[?25h\<esc>[?17;14;64c"
    "let &t_EI="\<esc>[?25h\<esc>[?17;14;224c"
    "autocmd VimLeave * silent !printf '\%b' "\033[?17;14;224c"
endif

" http://vim.wikia.com/wiki/Non-blinking_block_cursor_in_a_Linux_console
" http://vim.1045645.n5.nabble.com/Using-block-cursor-in-plain-linux-console-but-vim-changes-it-back-to-underline-td1182965.html
if (&term == "linux") || (&term == 'screen.linux') " install ncurses-term s.t. screen.linux appears in terminfo
    let &t_ve.="\e[?17;14;224c" " same as execute "set t_ve+=\<esc>[?17;14;224c"
    "let &t_ve=substitute(&t_ve, '\e[?\zs0c', '17;14;224c', 'g')
endif

command! EchoColorScheme :call ReturnColorscheme()
function! ReturnColorscheme() " display current colorscheme
    if exists('g:colors_name') | echo g:colors_name | else | echo 'The variable "g:colors_name" is not defined.' |endif
endfunction

command! EchoTermialColors :call ReturnTerminalColors()
function! ReturnTerminalColors() " display all the colors the terminal support
    execute 'tabe'
    let l:num=255
    while l:num >= 0
        execute 'highlight col_'.l:num.' ctermbg='.l:num.' ctermfg=white'
        execute 'syntax match col_'.l:num.' "ctermbg='.l:num.'" containedIn=ALL'
        call append(0, 'ctermbg='.l:num.'')
        let l:num=l:num - 1
    endwhile
    execute 'set nomodified | keepjumps normal! gg'
endfunction

function! ReloadColorScheme() " reload current colorscheme
    try | execute "colorscheme ".g:colors_name | catch | endtry
endfunction

command! EchoHighlights :call ReturnHighlights()
function! ReturnHighlights() " show every highlight of current coloscheme (the 'silent' will prevent blinking during sourcing)
    execute 'tabe | silent source $VIMRUNTIME/syntax/hitest.vim | set nomodified'
endfunction
