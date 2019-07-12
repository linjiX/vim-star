""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"    https://github.com/linjiX/vim-star                      "
"             _                         _                    "
"     __   __(_) _ __ ___          ___ | |_  __ _  _ __      "
"     \ \ / /| || '_ ` _ \  _____ / __|| __|/ _` || '__|     "
"      \ V / | || | | | | ||_____|\__ \| |_| (_| || |        "
"       \_/  |_||_| |_| |_|       |___/ \__|\__,_||_|        "
"                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" configuration
let g:star_echo_search_pattern = get(g:, 'star_echo_search_pattern', 1)

" functions
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

function star#VwordForGrep() abort
    return '"'. escape(star#Vword(), '$\`"#%') .'"'
endfunction

function star#VwordForStar() abort
    return '\V'. substitute(escape(star#Vword(), '\'), '\n', '\\n', 'g')
endfunction

function star#CwordForStar() abort
    let l:cword = star#Cword()
    if match(l:cword, '\w') == -1
        return '\V'. escape(l:cword, '\')
    else
        return '\<'. l:cword .'\>'
    endif
endfunction

function star#Search(pattern, is_forward) abort
    let @/ = a:pattern
    call histadd('/', @/)
    call search(@/, 'cb')
    if g:star_echo_search_pattern
        echo (a:is_forward ? '/' : '?') . @/
    endif
endfunction

function star#Command(is_visual, is_forward, is_g) abort
    let l:pattern = a:is_visual ? "star#VwordForStar()"
                \               : a:is_g ? "star#Cword()"
                \                        : "star#CwordForStar()"

    let l:search = ":call star#Search(". l:pattern .", ". a:is_forward .")\<CR>"
    let l:hlsearch = ":let v:hlsearch = 1\<CR>"
    let l:searchforward = ":let v:searchforward = ". a:is_forward ."\<CR>"

    return l:search . l:hlsearch . l:searchforward
endfunction

" mappings
vnoremap <expr><silent> <Plug>(star-*) star#Command(1, 1, 0)
vnoremap <expr><silent> <Plug>(star-#) star#Command(1, 0, 0)
nnoremap <expr><silent> <Plug>(star-*) star#Command(0, 1, 0)
nnoremap <expr><silent> <Plug>(star-#) star#Command(0, 0, 0)
nnoremap <expr><silent> <Plug>(star-g*) star#Command(0, 1, 1)
nnoremap <expr><silent> <Plug>(star-g#) star#Command(0, 0, 1)
