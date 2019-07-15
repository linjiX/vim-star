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
let g:star_keep_cursor_pos = get(g:, 'star_keep_cursor_pos', 0)

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

function star#Search(is_visual, is_forward, is_g) abort
    let @/ = a:is_visual ? star#VwordForStar()
                \        : a:is_g ? star#Cword()
                \                 : star#CwordForStar()
    call histadd('/', @/)
    " call search(@/, 'cb')
    if g:star_echo_search_pattern
        echo (a:is_forward ? '/' : '?') . @/
    endif
    if g:star_keep_cursor_pos
        call setpos('.', s:pos)
    endif
endfunction

function s:GetCommand(is_visual, is_forward, is_g) abort
    let s:pos = getpos('.')
    let l:search = ":call star#Search(". a:is_visual .", ". a:is_forward .", ". a:is_g .")\<CR>"
    let l:hlsearch = ":let v:hlsearch = 1\<CR>"
    let l:searchforward = ":let v:searchforward = ". a:is_forward ."\<CR>"

    return l:search . l:hlsearch . l:searchforward
endfunction

" mappings
vnoremap <expr><silent> <Plug>(star-*) <SID>GetCommand(1, 1, 0)
vnoremap <expr><silent> <Plug>(star-#) <SID>GetCommand(1, 0, 0)
nnoremap <expr><silent> <Plug>(star-*) <SID>GetCommand(0, 1, 0)
nnoremap <expr><silent> <Plug>(star-#) <SID>GetCommand(0, 0, 0)
nnoremap <expr><silent> <Plug>(star-g*) <SID>GetCommand(0, 1, 1)
nnoremap <expr><silent> <Plug>(star-g#) <SID>GetCommand(0, 0, 1)
