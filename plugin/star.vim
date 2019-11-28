""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"    https://github.com/linjiX/vim-star                      "
"             _                         _                    "
"     __   __(_) _ __ ___          ___ | |_  __ _  _ __      "
"     \ \ / /| || '_ ` _ \  _____ / __|| __|/ _` || '__|     "
"      \ V / | || | | | | ||_____|\__ \| |_| (_| || |        "
"       \_/  |_||_| |_| |_|       |___/ \__|\__,_||_|        "
"                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('g:loaded_star')
    finish
endif
let g:loaded_star = 1

let g:star_echo_search_pattern = get(g:, 'star_echo_search_pattern', 1)
let g:star_keep_cursor_pos = get(g:, 'star_keep_cursor_pos', 0)

vnoremap <expr><silent> <Plug>(star-*) star#Command(1, 1, 0)
vnoremap <expr><silent> <Plug>(star-#) star#Command(1, 0, 0)
nnoremap <expr><silent> <Plug>(star-*) star#Command(0, 1, 0)
nnoremap <expr><silent> <Plug>(star-#) star#Command(0, 0, 0)
nnoremap <expr><silent> <Plug>(star-g*) star#Command(0, 1, 1)
nnoremap <expr><silent> <Plug>(star-g#) star#Command(0, 0, 1)
