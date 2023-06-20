augroup diffstatus
    autocmd!
    au BufWritePost * lua require('diffstatus').update()
    au BufEnter * lua require('diffstatus').update()
augroup END
