$packageName = "gitflow"
$release = "1.7.0"
$gitflow = "https://github.com/petervanderdoes/gitflow/archive/$release.zip"
$getoptbin = "http://sourceforge.net/projects/gnuwin32/files/util-linux/2.14.1/util-linux-ng-2.14.1-bin.zip/download"
$getoptdll = "http://sourceforge.net/projects/gnuwin32/files/util-linux/2.14.1/util-linux-ng-2.14.1-dep.zip/download"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (Test-Path "$env:ProgramFiles\Git") {
        $git = "$env:ProgramFiles\Git"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\Git") {
        $git = "${env:ProgramFiles(x86)}\Git"
    }

    Start-ChocolateyProcessAsAdmin "Get-ChildItem -Path '$git' -Include 'git-flow*','gitflow-*','gitflow*' -Recurse | Remove-Item -Recurse -Force"
    Start-ChocolateyProcessAsAdmin "Get-ChildItem -Path '$git' -Include 'getopt.exe','libintl3.dll','libiconv2.dll' -Recurse | Remove-Item -Recurse -Force"

    if (!(Test-Path $downloadPath)) {
        New-Item -ItemType directory $downloadPath -Force
    }

    # Download and copy getopt.exe & libintl3.dll & libiconv2.dll
    Get-ChocolateyWebFile $packageName "$downloadPath\bin.zip" $getoptbin
    Get-ChocolateyWebFile $packageName "$downloadPath\dep.zip" $getoptdll

    Get-ChocolateyUnzip "$downloadPath\bin.zip" "$downloadPath\"
    Get-ChocolateyUnzip "$downloadPath\dep.zip" "$downloadPath\"

    Start-ChocolateyProcessAsAdmin "Get-ChildItem -Path $downloadPath -Include 'getopt.exe','libintl3.dll','libiconv2.dll' -Recurse | Copy-Item -Destination '$git\bin' -Force"

    Get-ChocolateyWebFile $packageName "$downloadPath\gitflow.zip" $gitflow
    Get-ChocolateyUnzip "$downloadPath\gitflow.zip" "$downloadPath\"

    $installGitFlow = Join-Path "$downloadPath\gitflow-$release" "contrib\msysgit-install.cmd"
    
    Start-ChocolateyProcessAsAdmin "& '$installGitFlow' '$git'"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
