trap [System.Exception] {
  "Exception: {0}" -f $_.Exception.Message
  [Environment]::Exit(1)
}

$ErrorActionPreference = "Stop"

$docDir = Join-Path -Path $env:UserProfile -ChildPath Documents
$poshDir = Join-Path -Path $docDir -ChildPath WindowsPowerShell
$pwshDir = Join-Path -Path $docDir -ChildPath PowerShell
$modulesDir = Join-Path -Path $poshDir -ChildPath Modules
$binDir = Join-Path -Path $env:SYSTEMDRIVE -ChildPath bin
$binUrl = "https://github.com/dcjulian29/scripts-binaries/archive/refs/heads/master.zip"
$url = "https://github.com/dcjulian29/scripts-powershell/archive/refs/heads/main.zip"

@(
  "${env:TEMP}\scripts-powershell-main.zip"
  "${env:TEMP}\scripts-powershell-main"
  "${env:TEMP}\scripts-binaries-master.zip"
  "${env:TEMP}\scripts-binaries-master"
) | ForEach-Object {
  if (Test-Path $_) {
      Remove-Item $_ -Recurse -Force
  }
}

Invoke-WebRequest -Uri $url -UseBasicParsing `
  -OutFile "${env:TEMP}\scripts-powershell-main.zip"

Invoke-WebRequest -Uri $binUrl -UseBasicParsing `
  -OutFile "${env:TEMP}\scripts-binaries-master.zip"

Add-Type -AssemblyName System.IO.Compression.FileSystem

[System.IO.Compression.ZipFile]::ExtractToDirectory("${env:TEMP}\scripts-powershell-main.zip", "${env:TEMP}")
[System.IO.Compression.ZipFile]::ExtractToDirectory("${env:TEMP}\scripts-binaries-master.zip", "${env:TEMP}")

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

if (Test-Path "${env:SYSTEMDRIVE}\tools\binaries") {
  Remove-Item -Path "${env:SYSTEMDRIVE}\tools\binaries" -Recurse -Force
}

#------------------------------------------------------------------------------

if (Test-Path "$poshDir\Profile.ps1") {
    Remove-Item -Path $modulesDir -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$poshDir\Scripts" -Recurse -Force -ErrorAction SilentlyContinue

    Get-ChildItem -Path $poshDir -Recurse |
        Select-Object -ExpandProperty FullName |
        Remove-Item -Force -ErrorAction SilentlyContinue
}

Get-ChildItem -Path "${env:TEMP}\scripts-powershell-main" -Recurse |
    Where-Object { $_.FullName -notlike "*Test-Scripts.ps1" } |
    Where-Object { $_.FullName -notlike "*README.md" } |
    Copy-Item -Force -Destination { $_.FullName -replace [regex]::Escape("${env:TEMP}\scripts-powershell-main"), $poshDir }

Remove-Item -Path "${env:TEMP}\scripts-powershell-main.zip" -Force
Remove-Item -Path "${env:TEMP}\scripts-powershell-main" -Recurse -Force

if ((-not ($env:PSModulePath).Contains($modulesDir))) {
  $userPath = $modulesDir + ";" `
    + [Environment]::GetEnvironmentVariable('PSModulePath', 'User')
  $machinePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

  $env:PSModulePath = $userPath + ";" + $machinePath

  Get-Module -ListAvailable | Out-Null

  Invoke-Expression "[Environment]::SetEnvironmentVariable('PSModulePath', '$userPath', 'User')"
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
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Verbose

if ((Get-Module PowershellGet -ListAvailable | Measure-Object).Count -gt 1) {
  Import-Module PowerShellGet -RequiredVersion `
    "$((Get-Module PowershellGet -ListAvailable `
      | Sort-Object Version -Descending `
      | Select-Object -First 1).Version.ToString())"
} else {
  Import-Module PowerShellGet
}

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

if (-not (Get-PSRepository -Name "dcjulian29-powershell" -ErrorAction SilentlyContinue)) {
  Register-PSRepository -Name "dcjulian29-powershell" `
    -SourceLocation "https://www.myget.org/F/dcjulian29-powershell/api/v2"
} else {
  Set-PSRepository -Name "dcjulian29-powershell" `
    -SourceLocation "https://www.myget.org/F/dcjulian29-powershell/api/v2"
}

Set-PSRepository -Name "dcjulian29-powershell" -InstallationPolicy Trusted

#------------------------------------------------------------------------------

(Get-Content "$PSScriptRoot\thirdparty.json" | ConvertFrom-Json) | ForEach-Object {
  Write-Output "`n--------------------------------------`n"
  if (($_ -eq "PackageManagement") -or ($_ -eq "PowerShellGet")) {
    # These two are a little different as their base version is manually installed.
    if ((Get-Module $_ -ListAvailable).Version.ToString() -eq "1.0.0.1") {
      Write-Output "Overriding Upgrade! Will install latest version of '$_' module...`n"
      Install-Module -Name $_ -Verbose -Force -AllowClobber
      continue
    }
  }

  if (Get-Module -Name $_ -ListAvailable -ErrorAction SilentlyContinue) {
    Write-Output "Updating third-party '$_' module...`n"
    Update-Module -Name $_  -Verbose -Confirm:$false -AllowClobber
  } else {
    Write-Output "Installing third-party '$_' module...`n"
    Install-Module -Name $_ -Verbose -AllowClobber
  }
}

Write-Output "`n`n============================================================================`n`n"

(Get-Content "$PSScriptRoot\mine.json" | ConvertFrom-Json) | ForEach-Object {
  Remove-Item "$modulesDir\$_" -Recurse -Force

  if (Get-Module -Name $_ -ListAvailable -ErrorAction SilentlyContinue) {
    Write-Output "Updating my '$_' module..."
    Update-Module -Name $_ -Verbose -Confirm:$false -AllowClobber
  } else {
    Write-Output "Installing my '$_' module..."
    Install-Module -Name $_ -Repository "dcjulian29-powershell" -Verbose -AllowClobber
  }

  Write-Output "`n--------------------------------------`n"
}

Get-Module -ListAvailable | Out-Null

Write-Output (Get-InstalledModule `
  | Select-Object Name,Version,PublishedDate,RepositorySourceLocation `
  | Sort-Object PublishedDate -Descending `
  | Format-Table | Out-String)

Write-Output "`n`n============================================================================`n`n"

#------------------------------------------------------------------------------

Write-Output "Importing all available modules to make sure assemblies are loaded..."

Get-Module -ListAvailable | Import-Module -ErrorAction SilentlyContinue

Write-Output "Making sure all runtime assemblies are pre-compiled if necessary..."

$env:PATH = "$([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory());${env:PATH}"

[AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
  $path = $_.Location
  if ($path) {
    $name = Split-Path $path -Leaf
    Write-Output "Running ngen.exe on '$name'..."
    ngen.exe install $path /nologo | Out-Null
  }
}
