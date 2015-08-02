$packageName = "vim"
$vim = "ftp://ftp.vim.org/pub/vim/pc/vim74w32.zip"
$vimrt = "ftp://ftp.vim.org/pub/vim/pc/vim74rt.zip"
$gvim = "ftp://ftp.vim.org/pub/vim/pc/gvim74.zip"

$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\vim74w32.zip" $vim
Get-ChocolateyWebFile $packageName "$downloadPath\vim74rt.zip" $vimrt
Get-ChocolateyWebFile $packageName "$downloadPath\gvim74.zip" $gvim

Get-ChocolateyUnzip "$downloadPath\vim74w32.zip" "$downloadPath\"
Get-ChocolateyUnzip "$downloadPath\vim74rt.zip" "$downloadPath\"
Get-ChocolateyUnzip "$downloadPath\gvim74.zip" "$downloadPath\"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item -Path $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$downloadPath\vim\vim74\*" -Destination "$appDir\" -Recurse -Container

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

if (Test-ProcessAdminRights) {
    . $toolDir\postInstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
}
