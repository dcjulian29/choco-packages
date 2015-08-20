$packageName = "gitflow"

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
