# vim-star

Improved vim star search

## Features

-   Support `*` search in visual mode
-   Make the cursor jump to the **current** match's beginning
-   Support `[count]*` command

## Installation

with vim-plug

```vim
Plug 'linjiX/vim-star'
```

## Usage

```vim
vmap <silent> * <Plug>(star-*)
vmap <silent> # <Plug>(star-#)
nmap <silent> * <Plug>(star-*)
nmap <silent> # <Plug>(star-#)
nmap <silent> g* <Plug>(star-g*)
nmap <silent> g# <Plug>(star-g#)
```

## About cursor positon

Vim's original behavior of `*` will make the cursor jump to the **next** match's beginning.  
This plugin will make the cursor jump to the **current** match's beginning by default.

Some people prefer keeping the cursor positon unchanged when using `*`.  
But in this case, I need to press 'N' twice to jump to the previous match
(first 'N' for jumping to the current match, second for the previous match).  
That is why I prefer making the cursor to the current match's beginning.

If you still prefer keeping the cursor positon unchanged, you can

```vim
" Keep the cursor positon unchanged when use * to search
let g:star_keep_cursor_pos = 1
```

## Combine with vim-searchindex

[vim-searchindex](https://github.com/google/vim-searchindex)
is for display the number of search matches & index of a current match.

```vim
" Install vim-searchindex
Plug 'google/vim-searchindex'
```

```vim
" Avoid the echo blink by disabling this plugin's echo
let g:star_echo_search_pattern = 0

" Use 'SearchIndex' from vim-searchindex to display the number of search matches & index
vmap <silent> * <Plug>(star-*):SearchIndex<CR>
vmap <silent> # <Plug>(star-#):SearchIndex<CR>
nmap <silent> * <Plug>(star-*):SearchIndex<CR>
nmap <silent> # <Plug>(star-#):SearchIndex<CR>
nmap <silent> g* <Plug>(star-g*):SearchIndex<CR>
nmap <silent> g# <Plug>(star-g#):SearchIndex<CR>
```

## Related Works & References

-   [vim-visual-star-search](https://github.com/bronson/vim-visual-star-search)
-   [vim-asterisk](https://github.com/haya14busa/vim-asterisk)
-   [vim-visualstar](https://github.com/thinca/vim-visualstar)
-   [starsearch.vim](https://github.com/darfink/starsearch.vim)
