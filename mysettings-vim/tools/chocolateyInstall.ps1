$packageName = "mysettings-vim"

if (Test-Path "${env:USERPROFILE}\_vimrc") {
    Remove-Item "${env:USERPROFILE}\_vimrc" -Force
}

Set-Content -Path "${env:USERPROFILE}\_vimrc" -Value @"
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set number      " show line numbers
set showcmd     " show command in bottom bar
set wildmenu        " visual autocomplete for command menu
set lazyredraw      " redraw only when we need to.
set showmatch       " highlight matching [{()}]
set hlsearch        " highlight matches
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
set ignorecase      " case-insensitive search
set ruler       " display cursor position in bottom bar
set backspace=indent,eol,start  " make backspace work as expected on Windows.
syntax enable
color slate
if has("gui_running")
    set lines=40 columns=120
    set guifont=Consolas\ 16
endif
autocmd Filetype gitcommit setlocal spell textwidth=72
hi def link gitcommitSummary Normal
hi def link gitcommitBlank Normal 
"@

$vim = $(Find-ProgramFiles 'vim\vim80\vim.exe') -replace '\\','/'
$git = Find-ProgramFiles 'Git\bin\git.exe'

if ((Test-Path "$env:ProgramFiles\Git") -or (Test-Path "${env:ProgramFiles(x86)}\Git")) {
    & $git config --global core.editor "'$vim'"
}
