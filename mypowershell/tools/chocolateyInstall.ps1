$docDir = Join-Path -Path $env:UserProfile -ChildPath Documents
$poshDir = Join-Path -Path $docDir -ChildPath WindowsPowerShell
$pwshDir = Join-Path -Path $docDir -ChildPath PowerShell
$modulesDir = Join-Path -Path $poshDir -ChildPath Modules
$binDir = Join-Path -Path $env:SYSTEMDRIVE -ChildPath bin

$version = "${env:ChocolateyPackageVersion}"
$repo = "scripts-powershell"

$binUrl = "https://github.com/dcjulian29/scripts-binaries/archive/refs/heads/master.zip"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"

$file = "$repo-$version"

@(
  "${env:TEMP}\$file.zip"
  "${env:TEMP}\$file"
  "${env:TEMP}\scripts-binaries-master.zip"
  "${env:TEMP}\scripts-binaries-master"
) | ForEach-Object {
  if (Test-Path $_) {
      Remove-Item $_ -Recurse -Force
  }
}

(New-Object System.Net.WebClient).DownloadFile("$url", "${env:TEMP}\$file.zip")
(New-Object System.Net.WebClient).DownloadFile("$binUrl", "${env:TEMP}\scripts-binaries-master.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("${env:TEMP}\$file.zip", ${env:TEMP})
[System.IO.Compression.ZipFile]::ExtractToDirectory("${env:TEMP}\scripts-binaries-master.zip", ${env:TEMP})

if (-not (Test-Path $binDir)) {
  New-Item -Type Directory -Path $binDir | Out-Null
}

if (-not (Test-Path $poshDir)) {
  New-Item -Path $poshDir -ItemType Directory | Out-Null
}

if (-not (Test-Path $pwshDir)) {
  New-Item -ItemType SymbolicLink -Path $docDir -Name PowerShell -Target $poshDir
}

#------------------------------------------------------------------------------

Copy-Item -Path "${env:TEMP}\scripts-binaries-master\*" -Destination $binDir -Recurse -Force

Remove-Item -Path "${env:TEMP}\scripts-binaries-master" -Recurse -Force
Remove-Item -Path "${env:TEMP}\scripts-binaries-master.zip" -Force

#------------------------------------------------------------------------------

if (Test-Path "$poshDir\Profile.ps1") {
    Write-Output "Removing previous version of package..."

    Remove-Item -Path $modulesDir -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$poshDir\Scripts" -Recurse -Force -ErrorAction SilentlyContinue

    Get-ChildItem -Path $poshDir -Recurse |
        Select-Object -ExpandProperty FullName |
        Remove-Item -Force -ErrorAction SilentlyContinue
}

Get-ChildItem -Path "${env:TEMP}\$file" -Recurse |
    Where-Object { $_.FullName -notlike "*Test-Scripts.ps1" } |
    Where-Object { $_.FullName -notlike "*README.md" } |
    Copy-Item -Force -Destination { $_.FullName -replace [regex]::Escape("${env:TEMP}\$file"), $poshDir }

Remove-Item -Path "${env:TEMP}\$file.zip" -Force
Remove-Item -Path "${env:TEMP}\$file" -Recurse -Force

if ((-not ($env:PSModulePath).Contains($modulesDir))) {
    $PSModulePath = "$modulesDir;$([Environment]::GetEnvironmentVariable('PSModulePath', 'User'))"

    $env:PSModulePath = $PSModulePath + [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

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

if (Test-Path "$modulesDir\go") {
  Write-Output "Removing previous version of posh-go..."
  Remove-Item "$modulesDir\go" -Recurse -Force
}

New-Item -Type Directory -Path "$modulesDir\go" | Out-Null

Copy-Item -Path "${env:TEMP}\Go-Shell-master\*" -Destination "$modulesDir\go"

Remove-Item -Path "${env:TEMP}\posh-go.zip" -Force
Remove-Item -Path "${env:TEMP}\Go-Shell-master" -Recurse -Force

#------------------------------------------------------------------------------

Import-Module PackageManagement
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

if ((Get-Module PowershellGet -ListAvailable | Measure-Object).Count -gt 1) {
  Import-Module PowerShellGet -RequiredVersion `
    "$((Get-Module PowershellGet -ListAvailable `
      | Sort-Object Version `
      | Select-Object -First 1).Version.ToString())"
} else {
  Import-Module PowerShellGet
}

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Register-PSRepository -Name "dcjulian29-powershell" `
  -SourceLocation "https://www.myget.org/F/dcjulian29-powershell/api/v2"

Set-PSRepository -Name "dcjulian29-powershell" -InstallationPolicy Trusted

#------------------------------------------------------------------------------

$originalProgressPreference = $ProgressPreference
$ProgressPreference = "SilentlyContinue"

(Get-Content "$PSScriptRoot\thirdparty.json" | ConvertFrom-Json) | ForEach-Object {
  Write-Output "`n`n--------------------------------------"
  Write-Output "Installing third-party '$_' module..."
    Install-Module -Name $_ -AllowClobber -Force -Verbose
}

(Get-Content "$PSScriptRoot\mine.json" | ConvertFrom-Json) | ForEach-Object {
  Write-Output "`n`n--------------------------------------"
  Write-Output "Installing my '$_' module..."
  Remove-Item "$modulesDir\$_" -Recurse -Force
  Install-Module -Name $_ -Repository "dcjulian29-powershell" -AllowClobber -Force -Verbose
}

$ProgressPreference = $originalProgressPreference

if (Test-Path "${env:ProgramFiles}\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1") {
  Remove-Item -Path "${env:ProgramFiles}\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1" `
    -Recurse -Force -ErrorAction SilentlyContinue
}

if (Test-Path "${env:ProgramFiles}\WindowsPowerShell\Modules\PackageManagement\1.0.0.1") {
  Remove-Item -Path "${env:ProgramFiles}\WindowsPowerShell\Modules\PackageManagement\1.0.0.1" `
    -Recurse -Force -ErrorAction SilentlyContinue
}

Get-Module -ListAvailable | Out-Null

Write-Output "`n`n--------------------------------------"

Get-InstalledModule `
  | Select-Object Name,Version,PublishedDate,RepositorySourceLocation `
  | Sort-Object PublishedDate -Descending `
  | Format-Table | Out-String | Write-Host

#------------------------------------------------------------------------------

Write-Output "Making sure all runtime assemblies are pre-compiled if necessary..."

$env:PATH = "$([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory());${env:PATH}"

[AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
  $path = $_.Location
  if ($path) {
    $name = Split-Path $path -Leaf
    Write-Host -ForegroundColor Yellow "`r`nRunning ngen.exe on '$name'"
    ngen.exe install $path /nologo
  }
}
