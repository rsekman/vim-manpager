setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile

setlocal nowrap
setlocal conceallevel=3
setlocal concealcursor=nvic

if exists("b:did_manpager")
	finish
endif
let b:did_manpager = 1
exec "setlocal iskeyword+=\x1,\x2,_"

nnoremap <buffer> q :q!<CR>
nnoremap <buffer> <Space> <PageDown>
nnoremap <buffer> <CR>  :call manpager#CursorMan()<CR>
nnoremap <buffer> K  :call manpager#CursorMan()<CR>

command! MANPAGER :call  manpager#PrepManPager($MAN_PN)
