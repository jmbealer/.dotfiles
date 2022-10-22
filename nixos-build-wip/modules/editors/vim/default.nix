{pkgs, ...}: { programs.vim = {
  enable = true;

  plugins = with pkgs.vimPlugins; [
    vim-gruvbox8
    # gruvbox-material
    # base16-vim
    # awesome-vim-colorschemes
    onedark-vim

    vim-airline
    vim-airline-themes
    vim-airline-clock
    vim-diminactive
    vim-lastplace
    vim-signify
    vim-startify
    vim-which-key

    vim-repeat
    surround
    vim-unimpaired
    commentary
    vim-eunuch
    # sleuth
    targets-vim
    delimitMate

    coc-nvim
    vim-lsp
    vim-polyglot
    vim-nix

    lf-vim
    vim-floaterm

    indentLine


    # vimspector

  ];

  # settings = { ignorecase = true; };
  extraConfig = ''

    " colorscheme gruvbox-material
    colorscheme gruvbox8_hard
    " let g:gruvbox_material_background = 'hard'
    " let g:gruvbox_material_enable_bold = 1
    " let g:gruvbox_material_enable_italic = 1
    " let g:gruvbox_material_transparent_background = 1

    set autoindent
    set autowrite
    set number
    set relativenumber
    " set norelativenumber
    set cursorline
    set ruler " see ruf for formatting
    set showmode
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
    set smartindent
    set smarttab
    " better ascii friendly listchars
    set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
    " mark trailing spaces as errors
    if has("match")
      match ErrorMsg '\s\+$'
    endif
    set textwidth=72
    set expandtab
    " makes ~ effectively invisible
    "highlight NonText guifg=bg
    "set spell
    " more risky, but cleaner
    set nobackup
    set noswapfile
    set nowritebackup
    set icon
    " center the cursor always on the screen
    set scrolloff=999
    " highlight search hits
    set hlsearch
    set incsearch
    set linebreak
    " avoid most of the 'Hit Enter ...' messages
    set shortmess=aoOtTI
    " prevents truncated yanks, deletes, etc.
    set viminfo='20,<1000,s1000
    " wrap around when searching
    set wrapscan
    " Just the defaults, these are changed per filetype by plugins.
    " Most of the utility of all of this has been superceded by the use of
    " modern simplified pandoc for capturing knowledge source instead of
    " arbitrary raw text files.
    set fo+=t   " don't auto-wrap text using text width
    set fo+=c   " autowrap comments using textwidth with leader
    "set fo-=r   " don't auto-insert comment leader on enter in insert
    set fo+=r   " don't auto-insert comment leader on enter in insert
    "set fo-=o   " don't auto-insert comment leader on o/O in normal
    set fo+=o   " don't auto-insert comment leader on o/O in normal
    set fo+=q   " allow formatting of comments with gq
    "set fo-=w   " don't use trailing whitespace for paragraphs
    "set fo-=a   " disable auto-formatting of paragraph changes
    "set fo-=n   " don't recognized numbered lists
    set fo+=j   " delete comment prefix when joining
    "set fo-=2   " don't use the indent of second paragraph line
    "set fo-=v   " don't use broken 'vi-compatible auto-wrapping'
    "set fo-=b   " don't use broken 'vi-compatible auto-wrapping'
    set fo+=l   " long lines not broken in insert mode
    "set fo+=m   " multi-byte character line break support
    "set fo+=M   " don't add space before or after multi-byte char
    "set fo-=B   " don't add space between two multi-byte chars
    set fo+=1   " don't break a line after a one-letter word

    " stop complaints about switching buffer with changes
    set hidden
    " command history
    set history=100
    " here because plugins and stuff need it
    if has("syntax")
      syntax enable
    endif
    " faster scrolling
    set ttyfast
    " allow sensing the filetype
    filetype plugin on
    " high contrast for streaming, etc.
    set background=dark

    au FileType bash set sw=2
    " Edit/Reload vimr configuration file
    nnoremap confe :e $HOME/.vimrc<CR>
    nnoremap confr :source $HOME/.vimrc<CR>

    set ruf=%30(%=%#LineNr#%.50F\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %p%%%)


    " make Y consitent with D and C (yank til end)
    map Y y$

    " better command-line completion
    set wildmenu

    " disable search highlighting with <C-L> when refreshing screen
    nnoremap <C-L> :nohl<CR><C-L>

    " enable omni-completion
    set omnifunc=syntaxcomplete#Complete


    " disable arrow keys (vi muscle memory)
    "noremap <up> :echoerr "Umm, use k instead"<CR>
    "noremap <down> :echoerr "Umm, use j instead"<CR>
    "noremap <left> :echoerr "Umm, use h instead"<CR>
    " noremap <right> :echoerr "Umm, use l instead"<CR>
    " inoremap <up> <NOP>
    " inoremap <down> <NOP>
    " inoremap <left> <NOP>
    " inoremap <right> <NOP>
    "
    " better use of arrow keys, number increment/decrement
    nnoremap <up> <C-a>
    nnoremap <down> <C-x>

    " Better page down and page up
    noremap <C-n> <C-d>
    noremap <C-p> <C-b>

    " Set TMUX window name to name of file
    "au fileopened * !tmux rename-window TESTING


    "mappings
    noremap s b
    noremap t j
    noremap n k
    noremap b w

    noremap w s
    noremap j t
    noremap k n

    noremap S B
    noremap T }
    noremap N {
    noremap B W

    noremap B B
    noremap W S
    noremap J T
    noremap K N

    let mapleader=" "
    noremap <leader>fs :write!<cr>
    noremap <leader>qq :quit!<cr>
    noremap <leader>qa :quitall!<cr>

    noremap <leader>ot :term<cr>

    noremap <leader>ws <c-w>h
    noremap <leader>wt <c-w>j
    noremap <leader>wn <c-w>k
    noremap <leader>wb <c-w>l

    noremap <leader>wd <c-w>q
    noremap <leader>wv <c-w>v
    noremap <leader>wh <c-w>s

    noremap <leader>wrs :vertical resize -2<cr>
    noremap <leader>wrt :resize +2<cr>
    noremap <leader>wrn :resize -2<cr>
    noremap <leader>wrb :vertical resize +2<cr>


    source ~/dotfiles/modules/editors/vim/vimrc

    packadd! vimspector

    let g:vimspector_enable_mappings = 'HUMAN'
    nmap <leader>dd :call vimspector#Launch()<cr>
    nmap <leader>dx :VimspectorReset<cr>
    nmap <leader>de :VimspectorEval
    nmap <leader>dw :VimspectorWatch
    nmap <leader>do :VimspectorShowOutput

let g:vimspector_base_dir='/home/jb/.vim/pack/vimspector/opt/vimspector'
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ]

let g:lf_replace_netrw = 1 " Open lf when vim opens a directory

  '';
};
}
