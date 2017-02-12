$packageName = "vim"

$version="vim80"
$subversion = "069"
$w32="$($version)-$($subversion)w32.zip"
$rt="$($version)-$($subversion)rt.zip"
$gv = "g$($version)-$($subversion).zip"

$vim = "ftp://ftp.vim.org/pub/vim/pc/$w32"
$vimrt = "ftp://ftp.vim.org/pub/vim/pc/$rt"
$gvim = "ftp://ftp.vim.org/pub/vim/pc/$gv"

$downloadPath = "$($env:TEMP)\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $vim "$downloadPath\$w32"
Download-File $vimrt "$downloadPath\$rt"
Download-File $gvim "$downloadPath\$gv"

Unzip-File "$downloadPath\$w32" $downloadPath
Unzip-File "$downloadPath\$rt" $downloadPath

# GVIM has some files that are duplicate of ones from the Runtime...
#   will extract to separate directory and the force the copy of files.
Unzip-File "$downloadPath\$gv" "$downloadPath\gv"
Copy-Item "$downloadPath\gv\*" $downloadPath -Force -Recurse

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item -Path $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$downloadPath\vim\$version\*" -Destination "$appDir\" -Recurse -Container

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

if (Test-Path "$env:ProgramFiles\Git") {
    $git = "$env:ProgramFiles\Git\bin\git.exe"
}

if (Test-Path "${env:ProgramFiles(x86)}\Git") {
    $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
}

if (Test-Path $git) {
    & $git config --global core.editor "'$appdir\vim.exe'"
}

if (Test-Elevation) {
    . $PSScriptRoot\postInstall.ps1
} else {
    Invoke-ElevatedScript { . $PSScriptRoot\postInstall.ps1 }
}
