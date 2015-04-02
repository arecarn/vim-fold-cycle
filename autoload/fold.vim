let g:D = 0
function! fold#find_end()

    " maybe don't always skip current level
    " find end of fold path not last end of of the last fold path

    let line = line('.')
    let fold_level = foldlevel(line)

    if fold_level == 0
        return -1
    endif

    "skip current level
    let i = 1
    while fold_level == foldlevel(line + i)
        let i = i + 1
    endwhile

    let done = 0
    while !done


        let level = foldlevel(line + i)

        if level <= fold_level
            return line + i - 1
        endif

        let i = i + 1
    endwhile
endfunction


function! fold#do_fold_function(fold_keys, line) abort

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
endfunction

function! fold#is_last(line) abort
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
endfunction

function! fold#find_previouse(line) abort
    return fold#do_fold_function('zk', a:line)
endfunction

function! fold#find_branch_end(line) abort
    return fold#do_fold_function(']z', a:line)
endfunction


function! fold#find_next(line) abort
    return fold#do_fold_function('zj', a:line)
endfunction


function! fold#find_max_unfolded() abort
    let current_line = line('.')

    if fold#is_last(current_line)
        let fold_level = foldlevel(current_line - 1)
    else
        let fold_level = foldlevel(current_line)
    endif

    let branch_end = fold#find_branch_end(current_line) "if this return -1 wat do?

    let line = current_line
    let max_fold_level = fold_level

    if g:D | echomsg string("branch_end = " . branch_end) | endif

    while line < branch_end
        if g:D | echomsg string("line = " . line) | endif

        let new_line = fold#find_next(line) "if this return -1 wat do?

        if new_line == -1
            if g:D | echomsg string("new_line = " . new_line) | endif
            if g:D | echomsg string("return early") | endif
            return max_fold_level
        else
            let line = new_line
        endif

        if (foldlevel(line) > max_fold_level) && (foldclosed(line) == -1)
            let max_fold_level = foldlevel(line)
        endif
    endwhile

    if g:D | echomsg string("return late") | endif
    if current_line == line
        return -1
    else
        return max_fold_level
    endif
endfunction

function! fold#find_max_folded() abort
    let current_line = line('.')

    if fold#is_last(current_line)
        let fold_level = foldlevel(current_line - 1)
    else
        let fold_level = foldlevel(current_line)
    endif

    let fold_level = foldlevel(current_line)

    let branch_end = fold#find_branch_end(current_line) "if this return -1 wat do?
    if branch_end == -1
        if g:D | echomsg string("branch_end = " . branch_end) | endif
        if g:D | echomsg string("return super early") | endif
        return -2
    endif


    let line = current_line
    let max_fold_level = -1

    if g:D | echomsg string("branch_end = " . branch_end) | endif

    while line < branch_end
        if g:D | echomsg string("line = " . line) | endif

        let new_line = fold#find_next(line) "if this return -1 wat do?

        if new_line == -1
            if g:D | echomsg string("new_line = " . new_line) | endif
            if g:D | echomsg string("max_fold_level = " . max_fold_level) | endif
            if g:D | echomsg string("return early") | endif
            return max_fold_level
        else
            let line = new_line
        endif

        if (foldlevel(line) > max_fold_level) && (foldclosed(line) != -1)
            let max_fold_level = foldlevel(line)
        endif
    endwhile

    if g:D | echomsg string("return late") | endif
    if current_line == line
        return -1
    else
        return max_fold_level
    endif
endfunction

function! fold#open() abort
    let to_open = fold#find_max_folded()

    if g:D | echomsg string("max folded = " . to_open) | endif
    let line = line('.')
    let branch_end = fold#find_branch_end(line) "if this return -1 wat do?

    if to_open == -2
        if g:D | echomsg string("opening for some reason") | endif
        foldopen
    endif

    if to_open == -1 || to_open == 0
        if g:D | echomsg string("closing all folds") | endif
        execute line . ',' . branch_end . "foldclose!"
        return
    endif


    while line < branch_end
        if foldlevel(line) == to_open
            if g:D | echomsg string("opening line " . line) | endif
            execute line . 'foldopen'
        endif
        let line = fold#find_next(line)
        if line == -1
            return
        endif
    endwhile

endfunction



function! fold#close() abort
    let to_fold = fold#find_max_unfolded()

    if to_fold == -1 || to_fold == 0
        if g:D | echomsg string("opening all folds") | endif
        foldopen!
        return
    endif

    let line = line('.')

    let branch_end = fold#find_branch_end(line) "if this return -1 wat do?


    while line < branch_end
        if foldlevel(line) == to_fold
            if g:D | echomsg string("folding line " . line) | endif
            execute line . 'foldclose'
        endif
        let line = fold#find_next(line)
        if line == -1
            return
        endif
    endwhile

endfunction



" when current cursor is at the start of a fold

" on each of the lowest fold levels make sure they are closed


" find the start of each fold

" if all the lowest fold levels are closed consider the next up and close
" those
"
"
" states
"
" 1 all closed
" 2 all 1 level folds open
" 3 all 2 level folds open
" n all n level folds open
"
" if not one of these states return to state 1

