"TODO handle wide chars with visual col
function! CleanFold(foldchar)
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    " let a:foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('|' . repeat(a:foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(a:foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(a:foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
