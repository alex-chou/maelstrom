syntax enable
set showcmd                         " display incomplete commands
set nu
filetype plugin indent on           " load file type plugins + indentation

"" Whitespace
set nowrap                          " don't wrap lines
set tabstop=4 shiftwidth=4          " a tab is two spaces (or set this to 4)
set expandtab                       " use spaces, not tabs
set backspace=indent,eol,start      " backspace through everything in insert mode

" Searching
set hlsearch                        " highlight matches
set incsearch                       " incremental searching
set ignorecase                      " searches are case insensitive...
set smartcase                       " ... unless they contain at least one capital letter

"" Color Scheme
colorscheme slate

"" Font
if has('gui_running')
    set guifont=Consolas:h9:cANSI
endif

set history=1000
set wildmenu
set wildmode=list:longest
set title

set wrap
set linebreak
set nolist

let g:haddock_browser = "/usr/local/bin/chrome"
