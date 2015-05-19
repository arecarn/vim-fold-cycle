""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Original Author: Ryan Carney
" License: WTFPL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" BOILER PLATE {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_clean_fold")
    finish
else
    let g:loaded_clean_fold = 1
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" GLOBALS {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:fold_debug = get(g:, 'fold_debug', 0)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" MAPPINGS {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <script> <Plug>(fold-open) :<C-u>call fold#open()<CR>
if !hasmapto('<Plug>(fold-open)')
    nmap <expr><unique><CR> expand('%') ==# "[Command Line]" ? "\<CR>" : "<Plug>(fold-open)"
endif

nnoremap <silent> <script> <Plug>(fold-close) :<C-u>call fold#close()<CR>
if !hasmapto('<Plug>(fold-close)')
    nmap <unique> <BS> <Plug>(fold-close)
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" BOILER PLATE {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:save_cpo
unlet s:save_cpo
" vim:foldmethod=marker
" vim: textwidth=78
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
