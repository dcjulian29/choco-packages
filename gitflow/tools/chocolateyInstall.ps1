$packageName = "gitflow"
$release = "1.8.0"
$gitflow = "https://github.com/petervanderdoes/gitflow-avh/archive/$release.zip"
$getoptbin = "http://sourceforge.net/projects/gnuwin32/files/util-linux/2.14.1/util-linux-ng-2.14.1-bin.zip/download"
$getoptdll = "http://sourceforge.net/projects/gnuwin32/files/util-linux/2.14.1/util-linux-ng-2.14.1-dep.zip/download"
$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path "$env:ProgramFiles\Git") {
    $git = "$env:ProgramFiles\Git"
}

if (Test-Path "${env:ProgramFiles(x86)}\Git") {
    $git = "${env:ProgramFiles(x86)}\Git"
}

if (Test-ProcessAdminRights) {
    Get-ChildItem -Path "$git" -Include 'git-flow*','gitflow-*','gitflow*' -Recurse | Remove-Item -Recurse -Force
    Get-ChildItem -Path "$git" -Include 'getopt.exe','libintl3.dll','libiconv2.dll' -Recurse | Remove-Item -Recurse -Force
} else {
    Start-ChocolateyProcessAsAdmin "Get-ChildItem -Path '$git' -Include 'git-flow*','gitflow-*','gitflow*' -Recurse | Remove-Item -Recurse -Force"
    Start-ChocolateyProcessAsAdmin "Get-ChildItem -Path '$git' -Include 'getopt.exe','libintl3.dll','libiconv2.dll' -Recurse | Remove-Item -Recurse -Force"
}

if (!(Test-Path $downloadPath)) {
    New-Item -ItemType directory $downloadPath -Force | Out-Null
}

# Download and copy getopt.exe & libintl3.dll & libiconv2.dll
Get-ChocolateyWebFile $packageName "$downloadPath\bin.zip" $getoptbin
Get-ChocolateyWebFile $packageName "$downloadPath\dep.zip" $getoptdll

Get-ChocolateyUnzip "$downloadPath\bin.zip" "$downloadPath\"
Get-ChocolateyUnzip "$downloadPath\dep.zip" "$downloadPath\"

if (Test-Path "$git\usr\bin") {
    $git = "$git\usr\bin"
} else {
    $git = "$git\bin"
}

if (Test-ProcessAdminRights) {
    Get-ChildItem -Path $downloadPath -Include 'getopt.exe','libintl3.dll','libiconv2.dll' -Recurse | Copy-Item -Destination "$git" -Force
} else {
    Start-ChocolateyProcessAsAdmin "Get-ChildItem -Path $downloadPath -Include 'getopt.exe','libintl3.dll','libiconv2.dll' -Recurse | Copy-Item -Destination '$git' -Force"
}

Get-ChocolateyWebFile $packageName "$downloadPath\gitflow.zip" $gitflow
Get-ChocolateyUnzip "$downloadPath\gitflow.zip" "$downloadPath\"

$downloadPath = "$downloadPath\$packageName-avh-$release"

if (Test-ProcessAdminRights) {
    Get-ChildItem -Path $downloadPath -Include 'git-flow*','gitflow-*','gitflow*' -Recurse | Copy-Item -Destination "$git" -Force
} else {
    Start-ChocolateyProcessAsAdmin "Get-ChildItem -Path $downloadPath -Include 'git-flow*','gitflow-*','gitflow*' -Recurse | Copy-Item -Destination '$git' -Force"
}
