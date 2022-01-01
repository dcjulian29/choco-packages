$url = "https://codeload.github.com/mbadolato/iTerm2-Color-Schemes/zip/master"

if (-not (Test-Path $env:TEMP\iTerm2-Color-Schemes.zip)) {
    (New-Object System.Net.WebClient).DownloadFile("$url", "${env:TEMP}\iTerm2-Color-Schemes.zip")
}

if (Test-Path $env:TEMP\iTerm2-Color-Schemes-master) {
    Remove-Item $env:TEMP\iTerm2-Color-Schemes-master -Recurse -Force
}

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("${env:TEMP}\iTerm2-Color-Schemes.zip", $env:TEMP)

Copy-Item -Path $env:TEMP\iTerm2-Color-Schemes-master\schemes\* `
    -Destination $env:ChocolateyInstall\lib\colortool\content\schemes\ `
    -Recurse -Force

# Sometimes color settings get set based on subkeys in HKCU:\Console, remove them
Remove-Item -Path HKCU:\Console\* -Recurse -Force

$cmd = "$env:WINDIR\system32\reg.exe import $PSScriptRoot\registry.reg"

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"

cmd /c "ColorTool.exe -b purplepeter.itermcolors"

# Install My "Nerd" Font
$font = "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/CascadiaCode/Regular/complete/Caskaydia%20Cove%20Regular%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.otf"

Invoke-WebRequest -Uri $font `
    -OutFile "$env:TEMP\Caskaydia Cove Regular Nerd Font Complete Mono Windows Compatible.otf"

Install-Font -Path "$env:TEMP\Caskaydia Cove Regular Nerd Font Complete Mono Windows Compatible.otf"

Remove-Item -Path "$env:TEMP\Caskaydia Cove Regular Nerd Font Complete Mono Windows Compatible.otf" -Force
