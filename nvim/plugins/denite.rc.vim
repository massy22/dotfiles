"------------------------------------
" denite.nvim
"------------------------------------

" Change default prompt
call denite#custom#option('default', {
      \ 'prompt': '>',
      \ 'cursor_wrap': 'short',
      \ })

call denite#custom#source('_', 'matchers', ['matcher_cpsm'])

" Change mapping in denite buffer
call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ 'jj',
      \ '<denite:enter_mode:normal>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ 'kk',
      \ '<denite:enter_mode:normal>',
      \ 'noremap'
      \)


" key mappings
nnoremap    [denite]   <Nop>
nmap    f [denite]

" source file
nnoremap <silent> [denite]f :<C-u>Denite file <CR>

" source file with buffer dir
nnoremap <silent> [denite]d :<C-u>DeniteBufferDir  file <CR>

" source file with project dir
nnoremap <silent> [denite]p :<C-u>DeniteProjectDir file <CR>

" source file_mru
nnoremap <silent> [denite]u :<C-u>Denite file_mru <CR>

" source file_rec
nnoremap <silent> [denite]r :<C-u>Denite file_rec <CR>

" source buffer
nnoremap <silent> [denite]b :<C-u>Denite file <CR>

" source help
nnoremap <silent> [denite]h :<C-u>DeniteCursorWord help <CR>

nnoremap  [denite]w :<C-u>DeniteCursorWord grep <CR>

" Ripgrep command on grep source
 call denite#custom#var('grep', 'command', ['rg'])
 call denite#custom#var('grep', 'default_opts',
     \ ['--vimgrep', '--no-heading','-S'])
 call denite#custom#var('grep', 'recursive_opts', [''])
 call denite#custom#var('grep', 'final_opts', [])
