$docDir = Join-Path -Path $env:UserProfile -ChildPath Documents
$poshDir = Join-Path -Path $docDir -ChildPath WindowsPowerShell
$pwshDir = Join-Path -Path $docDir -ChildPath PowerShell
$version = "${env:ChocolateyPackageVersion}"
$repo = "scripts-powershell"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"
$file = "$repo-$version"

if (Test-Path "${env:TEMP}\$file") {
    Remove-Item "${env:TEMP}\$file" -Recurse -Force
}

(New-Object System.Net.WebClient).DownloadFile("$url", "${env:TEMP}\$file.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("${env:TEMP}\$file.zip", ${env:TEMP})

if (Test-Path "$poshDir\Profile.ps1") {
    Write-Output "Removing previous version of package..."

    Remove-Item -Path "$poshDir\MyModules" -Recurse -Force

    Get-ChildItem -Path $poshDir -Recurse |
        Select-Object -ExpandProperty FullName |
        Where-Object { $_ -notlike "$poshDir\Modules*" } |
        Remove-Item -Force
}

if (-not (Test-Path $poshDir)) {
    New-Item -Path $poshDir -ItemType Directory | Out-Null
}

if (-not (Test-Path $pwshDir)) {
    New-Item -ItemType SymbolicLink -Path $docDir -Name PowerShell -Target $poshDir
}

Get-ChildItem -Path "${env:TEMP}\$file" -Recurse |
    Where-Object { $_.FullName -notlike "*Test-Scripts.ps1" } |
    Where-Object { $_.FullName -notlike "*README.md" } |
    Copy-Item -Force -Destination { $_.FullName -replace [regex]::Escape("${env:TEMP}\$file"), $poshDir }

Remove-Item -Path "${env:TEMP}\$file.zip" -Force
Remove-Item -Path "${env:TEMP}\$file" -Recurse -Force

if (-not (Test-Path "$(Split-Path $profile)\Modules")) {
    New-Item -Type Directory -Path "$(Split-Path $profile)\Modules" | Out-Null
}

if ((-not ($env:PSModulePath).Contains("$(Split-Path $profile)\Modules"))) {
    $env:PSModulePath = "$(Split-Path $profile)\Modules;$($env:PSModulePath)"

    Get-Module -ListAvailable | Out-Null

    Invoke-Expression "[Environment]::SetEnvironmentVariable('PSModulePath', '$PSModulePath', 'User')"
}

if ((-not ($env:PSModulePath).Contains("$(Split-Path $profile)\MyModules"))) {
    $PSModulePath = "$(Split-Path $profile)\MyModules;$($env:PSModulePath)"

    $env:PSModulePath = $PSModulePath

    Get-Module -ListAvailable | Out-Null

    Invoke-Expression "[Environment]::SetEnvironmentVariable('PSModulePath', '$PSModulePath', 'User')"
}

#------------------------------------------------------------------------------

if (Test-Path "${env:TEMP}\posh-go.zip") {
  Remove-Item "${env:TEMP}\posh-go.zip" -Force | Out-Null
}

Download-File "https://github.com/cameronharp/Go-Shell/archive/master.zip" `
  "${env:TEMP}\posh-go.zip"

if (Test-Path "${env:TEMP}\Go-Shell-master") {
  Remove-Item -Path "${env:TEMP}\Go-Shell-master" -Recurse -Force
}

Unzip-File "${env:TEMP}\posh-go.zip" "${env:TEMP}\"

if (Test-Path "$poshDir\Modules\go") {
  Write-Output "Removing previous version of posh-go..."
  Remove-Item "$poshDir\Modules\go" -Recurse -Force
}

New-Item -Type Directory -Path "$poshDir\Modules\go" | Out-Null

Copy-Item -Path "${env:TEMP}\Go-Shell-master\*" -Destination "$poshDir\Modules\go"

Remove-Item -Path "${env:TEMP}\posh-go.zip" -Force
Remove-Item -Path "${env:TEMP}\Go-Shell-master" -Recurse -Force

#------------------------------------------------------------------------------

Import-Module PackageManagement -RequiredVersion 1.0.0.1
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Import-Module PowerShellGet -RequiredVersion 1.0.0.1
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -Force

#------------------------------------------------------------------------------

@(
  "PackageManagement"
  "PowerShellGet"
  "PSSlack"
  "BurntToast"
  "CredentialManager"
  "MicrosoftTeams"
  "NtpTime"
  "PSScriptAnalyzer"
  "7Zip4Powershell"
  "SHiPS"
  "Trackyon.Utils"
  "VSTeam"
  "Pscx"
  "Posh-ACME"
  "PsIni"
  "PSWriteHTML"
  "AnsibleVault"
  "PowerShellForGitHub"
  "GitlabCli"
  "Lability"
  "PSRule"
  "Grok-Test"
) | ForEach-Object {
    Write-Output "Installing $_ module..."
    Install-Module -Name $_ -AllowClobber -Force
}

Get-InstalledModule
