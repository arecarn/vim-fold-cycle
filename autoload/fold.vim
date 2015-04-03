""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Original Author: Ryan Carney
" License: WTFPL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" BOILER PLATE {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:save_cpo = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


" PUBLIC FUNCTIONS {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" when current cursor is at the start of a fold
"
" on each of the lowest fold levels make sure they are closed
"
" find the start of each fold
"
" if all the lowest fold levels are closed consider the next up and close
" those
"
" states
"
" 1 all closed
" 2 all 1 level folds open
" 3 all 2 level folds open
" n all n level folds open
"
" if not one of these states return to state 1
"
function! fold#open() abort "{{{2
    let to_open = s:find_max_folded()

    if g:fold_debug | echomsg string("max folded = " . to_open) | endif
    let line = line('.')
    let branch_end = s:find_branch_end(line) "if this return -1 wat do?

    if to_open == -2
        if g:fold_debug | echomsg string("opening for some reason") | endif
        foldopen
    endif

    if to_open == -1 || to_open == 0
        if g:fold_debug | echomsg string("closing all folds") | endif
        execute line . ',' . branch_end . "foldclose!"
        return
    endif


    while line < branch_end
        if foldlevel(line) == to_open
            if g:fold_debug | echomsg string("opening line " . line) | endif
            execute line . 'foldopen'
        endif
        let line = s:find_next(line)
        if line == -1
            return
        endif
    endwhile

endfunction "}}}2


function! fold#close() abort "{{{2
    let to_fold = s:find_max_unfolded()

    if to_fold == -1 || to_fold == 0
        if g:fold_debug | echomsg string("opening all folds") | endif
        foldopen!
        return
    endif

    let line = line('.')

    let branch_end = s:find_branch_end(line) "if this return -1 wat do?


    while line < branch_end
        if foldlevel(line) == to_fold
            if g:fold_debug | echomsg string("folding line " . line) | endif
            execute line . 'foldclose'
        endif
        let line = s:find_next(line)
        if line == -1
            return
        endif
    endwhile

endfunction "}}}2


function! fold#clean_fold(foldchar) "{{{2
    "TODO handle wide chars with visual col
    let line = getline(v:foldstart)

    if &foldmethod == 'marker'
        let foldmarker = substitute(&foldmarker, '\zs,.*', '', '')
        let cmt = substitute(&commentstring, '\zs%s.*', '', '')
        let line = substitute(line, '\s*'. '\('.cmt.'\)\?'. '\s*'.foldmarker.'\d*\s*', '', 'g')
    endif

    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    let foldtextstart = strpart(line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(a:foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn

    return foldtextstart . repeat(a:foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction "}}}2


function! fold#fold_text() "{{{2
    let line = getline(v:foldstart)
    " Foldtext ignores tabstop and shows tabs as one space,
    " so convert tabs to 'tabstop' spaces so text lines up
    let ts = repeat(' ',&tabstop)
    let line = substitute(line, '\t', ts, 'g')
  let numLines = v:foldend - v:foldstart + 1
    return line.' ['.numLines.' lines]'
endfunction "}}}2


function! fold#get_potion_fold(lnum) "{{{2
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let this_indent = s:indent_level(a:lnum)
    let next_indent = s:indent_level(s:next_non_blank_line(a:lnum))

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>' . next_indent
    endif
endfunction "}}}2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


" PRIVATE FUNCTIONS {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:do_fold_function(fold_keys, line) abort "{{{2

    if type(a:line) == type('')
        let current_line = line(a:line)
    else
        let current_line = a:line
    endif

    let view = winsaveview()
    execute current_line
    execute 'normal! ' . a:fold_keys
    let line = line('.')
    call winrestview(view)

    if  line == current_line
        return -1
    else
        return line
    endif
endfunction "}}}2


function! s:is_last(line) abort "{{{2
    if type(a:line) == type('')
        let current_line = line(a:line)
    else
        let current_line = a:line
    endif

    let view = winsaveview()
    normal! zj
    normal! zk
    let line = line('.')
    call winrestview(view)

    if  line == current_line
        return 1
    else
        return 0
    endif
endfunction "}}}2


function! s:find_branch_end(line) abort "{{{2
    return s:do_fold_function(']z', a:line)
endfunction "}}}2


function! s:find_next(line) abort "{{{2
    return s:do_fold_function('zj', a:line)
endfunction "}}}2


function! s:find_max_unfolded() abort "{{{2
    let current_line = line('.')

    if s:is_last(current_line)
        let fold_level = foldlevel(current_line - 1)
    else
        let fold_level = foldlevel(current_line)
    endif

    let branch_end = s:find_branch_end(current_line) "if this return -1 wat do?

    let line = current_line
    let max_fold_level = fold_level

    if g:fold_debug | echomsg string("branch_end = " . branch_end) | endif

    while line < branch_end
        if g:fold_debug | echomsg string("line = " . line) | endif

        let new_line = s:find_next(line) "if this return -1 wat do?

        if new_line == -1
            if g:fold_debug | echomsg string("new_line = " . new_line) | endif
            if g:fold_debug | echomsg string("return early") | endif
            return max_fold_level
        else
            let line = new_line
        endif

        if (foldlevel(line) > max_fold_level) && (foldclosed(line) == -1)
            let max_fold_level = foldlevel(line)
        endif
    endwhile

    if g:fold_debug | echomsg string("return late") | endif
    if current_line == line
        return -1
    else
        return max_fold_level
    endif
endfunction "}}}2


function! s:find_max_folded() abort "{{{2
    let current_line = line('.')

    if s:is_last(current_line)
        let fold_level = foldlevel(current_line - 1)
    else
        let fold_level = foldlevel(current_line)
    endif

    let fold_level = foldlevel(current_line)

    let branch_end = s:find_branch_end(current_line) "if this return -1 wat do?
    if branch_end == -1
        if g:fold_debug | echomsg string("branch_end = " . branch_end) | endif
        if g:fold_debug | echomsg string("return super early") | endif
        return -2
    endif


    let line = current_line
    let max_fold_level = -1

    if g:fold_debug | echomsg string("branch_end = " . branch_end) | endif

    while line < branch_end
        if g:fold_debug | echomsg string("line = " . line) | endif

        let new_line = s:find_next(line) "if this return -1 wat do?

        if new_line == -1
            if g:fold_debug | echomsg string("new_line = " . new_line) | endif
            if g:fold_debug | echomsg string("max_fold_level = " . max_fold_level) | endif
            if g:fold_debug | echomsg string("return early") | endif
            return max_fold_level
        else
            let line = new_line
        endif

        if (foldlevel(line) > max_fold_level) && (foldclosed(line) != -1)
            let max_fold_level = foldlevel(line)
        endif
    endwhile

    if g:fold_debug | echomsg string("return late") | endif
    if current_line == line
        return -1
    else
        return max_fold_level
    endif
endfunction "}}}2


function! s:indent_level(lnum) "{{{2
    return indent(a:lnum) / &shiftwidth
endfunction "}}}2


function! s:next_non_blank_line(lnum) "{{{2
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction "}}}2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


" BOILER PLATE {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:save_cpo
unlet s:save_cpo
" vim:foldmethod=marker
" vim: textwidth=78
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
