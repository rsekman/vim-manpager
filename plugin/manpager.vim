let g:manpager#man_stack = []
function! manpager#Man(...)
    let l:manpage = a:000[-1]
    if a:0 > 1
        let l:manpage = printf('%s(%s)', a:2, a:1)
    endif
    let l:manbuff = bufnr(l:manpage)
    if l:manbuff > -1
        exe 'b' l:manbuff
        return
    endif

    let l:cmd = ['MAN_KEEP_FORMATTING=1', 'MANPAGER=cat', 'man'] + a:000
    enew
    call append(line(0), systemlist(join(l:cmd)))
    set ft=man
    call manpager#PrepManPager(l:manpage)
endfunction

function! manpager#CursorMan()
    let l:word = substitute(expand('<cWORD>'), '\%x1', '', 'g')
    let l:manpage = matchlist(l:word, '\v(%(\w|-)*)\((\d)\)')
    call manpager#Man(l:manpage[3], l:manpage[1])
endfunction

function! manpager#PrepManPager(man)
    setlocal modifiable
    if !empty(a:man)
        exe "file" a:man
    endif
    silent keepp %s/\(_\b.\)\{2,}/\="\2".substitute(submatch(0),'_\b\(.\)','\1','g')."\2"/ge
    undojoin | silent keepp %s/\(\$\)\?\(.\b.\)\+/\="\1".substitute(submatch(0),'.\b\(.\)','\1','g')."\1"/ge
    0
    setlocal nomodified
    setlocal nomodifiable
endfunction

autocmd StdinReadPost * call manpager#PrepManPager($MAN_PN)

command -buffer -nargs=+ Man :call manpager#Man(<f-args>)
