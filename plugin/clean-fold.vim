"TODO handle wide chars with visual col
function! CleanFold(foldchar)
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
endfunction

function! MyFoldText()
    let line = getline(v:foldstart)
    " Foldtext ignores tabstop and shows tabs as one space,
    " so convert tabs to 'tabstop' spaces so text lines up
    let ts = repeat(' ',&tabstop)
    let line = substitute(line, '\t', ts, 'g')
  let numLines = v:foldend - v:foldstart + 1
    return line.' ['.numLines.' lines]'
endfunction
