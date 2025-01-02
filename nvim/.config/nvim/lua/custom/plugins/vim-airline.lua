return {
  'vim-airline/vim-airline',
  lazy = false,
  dependencies = {
    'vim-airline/vim-airline-themes',
  },
  init = function()
    -- airline
    vim.cmd('let g:airline_powerline_fonts = 1')
    vim.cmd("let g:airline_theme='dark'")
    vim.cmd('let g:airline#extensions#whitespace#enabled=0')
    vim.cmd('let g:airline#extensions#wordcount#enabled=0')
    vim.cmd('let g:airline#extensions#syntastic#enabled=1')
    vim.cmd("let g:airline_section_c=''")
    vim.cmd('let g:airline_skip_empty_sections = 1')

    -- tabline configuration
    vim.cmd('let g:airline#extensions#tabline#enabled=1')
    vim.cmd('let g:airline#extensions#tabline#show_splits=0')
    vim.cmd('let g:airline#extensions#tabline#show_buffers=1')
    vim.cmd('let g:airline#extensions#tabline#show_tabs=0')
    vim.cmd('let g:airline#extensions#tabline#exclude_preview=1')
    vim.cmd('let g:airline#extensions#tabline#show_tab_nr=1')
    vim.cmd('let g:airline#extensions#tabline#tab_nr_type=1')
    vim.cmd('let g:airline#extensions#tabline#show_tab_type=1')
    vim.cmd("let g:airline#extensions#tabline#fnamemod=':t'")
    vim.cmd('let g:airline#extensions#tabline#fnamecollapse=1')
    vim.cmd('let g:airline#extensions#tabline#buffer_min_count=0')
    vim.cmd('let g:airline#extensions#tabline#show_close_button=0')
    -- removes leading "tabs>"
    vim.cmd("let airline#extensions#tabline#tabs_label = ''")
  end,
}
