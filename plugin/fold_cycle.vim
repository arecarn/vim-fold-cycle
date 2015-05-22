""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Original Author: Ryan Carney
" License: WTFPL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" BOILER PLATE {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_fold_cycle")
    finish
else
    let g:loaded_fold_cycle= 1
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" GLOBALS {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:fold_debug = get(g:, 'fold_cycle_debug', 0)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" MAPPINGS {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <script> <Plug>(fold-cycle-open) :<C-u>call fold_cycle#open()<CR>
if !hasmapto('<Plug>(fold-cycle-open)')
    nmap <expr><unique><CR> expand('%') ==# "[Command Line]" ? "\<CR>" : "<Plug>(fold-cycle-open)"
endif

nnoremap <silent> <script> <Plug>(fold-cycle-close) :<C-u>call fold_cycle#close()<CR>
if !hasmapto('<Plug>(fold-cycle-close)')
    nmap <unique> <BS> <Plug>(fold-cycle-close)
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" BOILER PLATE {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:save_cpo
unlet s:save_cpo
" vim:foldmethod=marker
" vim: textwidth=78
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
