""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"    https://github.com/linjiX/vim-star                      "
"             _                         _                    "
"     __   __(_) _ __ ___          ___ | |_  __ _  _ __      "
"     \ \ / /| || '_ ` _ \  _____ / __|| __|/ _` || '__|     "
"      \ V / | || | | | | ||_____|\__ \| |_| (_| || |        "
"       \_/  |_||_| |_| |_|       |___/ \__|\__,_||_|        "
"                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function star#Word(is_visual) abort
    let l:reg = getreg('"')
    let l:regtype = getregtype('"')
    try
        let l:cmd = a:is_visual ? 'gv""y' : '""yiw'
        execute 'noautocmd silent normal! '. l:cmd
        return @"
    finally
        call setreg('"', l:reg, l:regtype)
    endtry
endfunction

function star#EscapedVword() abort
    return '\V'. substitute(escape(star#Word(1), '\'), '\n', '\\n', 'g')
endfunction

function star#EscapedCword() abort
    let l:cword = star#Word(0)
    if empty(l:cword)
        return '\V\n'
    endif
    if match(l:cword, '\w') == -1
        return '\V'. escape(l:cword, '\')
    else
        return '\<'. l:cword .'\>'
    endif
endfunction

function star#GetPattern(is_visual, is_g) abort
    return a:is_visual ? star#EscapedVword()
                \      : a:is_g ? star#Word(0)
                \               : star#EscapedCword()
endfunction

function star#Search(is_visual, is_forward, is_g) abort
    let l:pattern = star#GetPattern(a:is_visual, a:is_g)
    let @/ = l:pattern
    call histadd('/', @/)
    if g:star_echo_search_pattern
        echo (a:is_forward ? '/' : '?') . @/
    endif
endfunction

function star#Command(is_visual, is_forward, is_g) abort
    if &lazyredraw == 0
        set lazyredraw
        let l:setlz = ":set nolazyredraw\<CR>"
    else
        let l:setlz = ''
    endif

    let l:args = join([a:is_visual, a:is_forward, a:is_g], ',')
    let l:search = ":\<C-u>call star#Search(". l:args .")\<CR>"

    if v:count
        let l:postcmd = v:count . (a:is_forward ? '/' : '?') . "\<CR>"
    else
        let l:setpos = g:star_keep_cursor_pos
                    \ ? ":noautocmd call setpos('.', ". string(getcurpos()) .")\<CR>"
                    \ : ''
        let l:hlsearch = ":let v:hlsearch = 1\<CR>"
        let l:searchforward = ':let v:searchforward = '. a:is_forward ."\<CR>"
        let l:postcmd = l:setpos . l:hlsearch . l:searchforward
    endif

    return l:search . l:postcmd . l:setlz
endfunction
