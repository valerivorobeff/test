" Этот файл подключает к vim плагины и делает другие настройки для работы с
" кодом C/C++.
"
" Чтобы все заработало:
" 1. curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 2. sudo apt install universal-ctags clangd nodejs
" 3. Этот файл положить в $HOME/.vimrc
" 4. В vim выполнить :PlugInstall
"
" Для того чтобы работал поиск, в корне проекта выполнить ctags -R .
"
" ========== НАЧАЛО ФАЙЛА ==========
" Установите leader клавиши ПЕРВЫМИ!
"let mapleader = " "
"let maplocalleader = " "

" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When this option is enabled, vi will use spaces instead of tabs
set tabstop     =4
"set softtabstop =0
set shiftwidth  =4
set smarttab
set expandtab
"set autoindent
set smartindent

" Автоформатирование при сохранении C/C++ файлов (для vim-clang-format)
autocmd FileType c,cpp nnoremap <buffer> <Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer> <Leader>cf :ClangFormat<CR>

nnoremap <C-Left> :tabprevious<CR>                                                                            
nnoremap <C-Right> :tabnext<CR>
"nnoremap <C-j> :tabprevious<CR>                                                                            
"nnoremap <C-k> :tabnext<CR>
"inoremap jj <ESC>

call plug#begin('~/.vim/plugged')

" Здесь перечисляем плагины

" Навигация
Plug 'preservim/nerdtree'  " Файловый менеджер
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP клиент
Plug 'jiangmiao/auto-pairs'  " Автоматические скобки
Plug 'liuchengxu/vista.vim' " Просмотр функций и классов

" Синтаксис и форматирование
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'

" Утилиты
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'

call plug#end()

" NERDTree
" Открытие/закрытие NERDTree
nnoremap <C-n> :NERDTreeFocus<CR>
"nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Закрыть vim если NERDTree последнее окно
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Airline
let g:airline#extensions#tabline#enabled = 1 " Показывать вкладки
" Настройки вкладок
let g:airline#extensions#tabline#formatter = 'unique_tail'
"let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_close_button = 1

" Переключение между буферами
nnoremap <silent> <Tab> :bn<CR>
nnoremap <silent> <S-Tab> :bp<CR>

" Clang format
let g:clang_format#code_style = "google"  " или "llvm", "webkit"
let g:clang_format#auto_format = 1  " Автоформатирование

" Vista настройки
"let g:vista_default_executive = 'coc'  " Использовать coc.nvim для анализа
let g:vista_default_executive = 'ctags'  " Использовать ctags для C кода
let g:vista_executive_for = {
  \ 'c': 'ctags',
  \ 'cpp': 'ctags',
  \ }

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]  " Иконки для иерархии
let g:vista#renderer#enable_icon = 1  " Показывать иконки
let g:vista_sidebar_width = 40
let g:vista_close_on_jump = 1

" Показывать только текущий тег (структуру/функцию)
let g:vista_stay_on_open = 0

" Автоматически обновлять Vista при изменениях
let g:vista_update_on_text_changed = 1

" Горячие клавиши для Vista
nnoremap <leader>v :Vista!!<CR>
nnoremap <C-v> :Vista!!<CR>
nnoremap <leader>vf :Vista finder<CR>

" Настройки для C/C++
let g:vista#executives = ['coc', 'ctags', 'lcn', 'vim_lsp']

" Coc навигация
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Всплывающая документация через coc
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Отключить inlay hints
let g:coc_inlay_hint_enable = 0

nmap <silent> K :call ShowDocumentation()<CR>
nnoremap <silent> <C-k> :call CocActionAsync('doHover')<CR>

" Автодополнение
inoremap <silent><expr> <c-space>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" ========== Горячие клавиши ==========

" Сохранение в нормальном режиме
nnoremap <F2> :w<CR>

" Переключение между .h и .c файлами
nnoremap <F4> :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>

" Быстрая сборка C файла
autocmd FileType c nnoremap <F5> :w<CR>:!gcc -Wall -Wextra % -o %:r && ./%:r<CR>
autocmd FileType c nnoremap <F6> :w<CR>:!make<CR>
autocmd FileType c nnoremap <F8> :w<CR>:!make run<CR>

" Поиск по проекту
nnoremap <leader>g :vimgrep // **/*.c **/*.h<left><left><left><left><left><left><left><left><left><left>

