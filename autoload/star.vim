""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"    https://github.com/linjiX/vim-star                      "
"             _                         _                    "
"     __   __(_) _ __ ___          ___ | |_  __ _  _ __      "
"     \ \ / /| || '_ ` _ \  _____ / __|| __|/ _` || '__|     "
"      \ V / | || | | | | ||_____|\__ \| |_| (_| || |        "
"       \_/  |_||_| |_| |_|       |___/ \__|\__,_||_|        "
"                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function star#Vword() abort
    let l:temp = @s
    silent normal! gv"sy
    let [l:temp, @s] = [@s, l:temp]
    return l:temp
endfunction

function star#Cword() abort
    let l:temp = @s
    silent normal! "syiw
    let [l:temp, @s] = [@s, l:temp]
    return l:temp
endfunction

function star#EscapedVword() abort
    return '\V'. substitute(escape(star#Vword(), '\'), '\n', '\\n', 'g')
endfunction

function star#EscapedCword() abort
    let l:cword = star#Cword()
    if match(l:cword, '\w') == -1
        return '\V'. escape(l:cword, '\')
    else
        return '\<'. l:cword .'\>'
    endif
endfunction

function star#Search(is_visual, is_forward, is_g) abort
    let @/ = a:is_visual ? star#EscapedVword()
                \        : a:is_g ? star#Cword()
                \                 : star#EscapedCword()
    call histadd('/', @/)
    if g:star_echo_search_pattern
        echo (a:is_forward ? '/' : '?') . @/
    endif
    if g:star_keep_cursor_pos
        call setpos('.', s:pos)
    endif
endfunction

function star#Command(is_visual, is_forward, is_g) abort
    let s:pos = getpos('.')

    let l:search = ":\<C-u>call star#Search(".
                \ a:is_visual .', '. a:is_forward .', '. a:is_g .")\<CR>"
    if v:count > 0
        let l:postcmd = v:count . (a:is_forward ? '/' : '?') . "\<CR>"
    else
        let l:hlsearch = ":let v:hlsearch = 1\<CR>"
        let l:searchforward = ":let v:searchforward = ". a:is_forward ."\<CR>"
        let l:postcmd = l:hlsearch . l:searchforward
    endif

    return l:search . l:postcmd
endfunction
