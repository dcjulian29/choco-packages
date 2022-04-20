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
  "${env:TEMP}\posh-go.zip"
  "${env:TEMP}\Go-Shell-master"
) | ForEach-Object {
  if (Test-Path $_) {
      Remove-Item $_ -Recurse -Force
  }
}

Invoke-WebRequest -Uri $url -UseBasicParsing `
  -OutFile "${env:TEMP}\scripts-powershell-main.zip"

Invoke-WebRequest -Uri $binUrl -UseBasicParsing `
  -OutFile "${env:TEMP}\scripts-binaries-master.zip"

Microsoft.PowerShell.Archive\Expand-Archive -Path "${env:TEMP}\scripts-powershell-main.zip" `
  -DestinationPath "${env:TEMP}\" -Force

Microsoft.PowerShell.Archive\Expand-Archive -Path "${env:TEMP}\scripts-binaries-master.zip" `
  -DestinationPath "${env:TEMP}\" -Force

if (-not (Test-Path $binDir)) {
  New-Item -Type Directory -Path $binDir | Out-Null
}

if (-not (Test-Path $poshDir)) {
  New-Item -Path $poshDir -ItemType Directory | Out-Null
}

if (-not (Test-Path $pwshDir)) {
  New-Item -ItemType SymbolicLink -Path $docDir -Name PowerShell -Target $poshDir
}

if (-not (Test-Path $modulesDir)) {
  New-Item -Path $modulesDir -ItemType Directory | Out-Null
}

#------------------------------------------------------------------------------

Write-Output "Installing binary scripts to '$binDir' ..."

Copy-Item -Path "${env:TEMP}\scripts-binaries-master\*" -Destination $binDir -Recurse -Force

Remove-Item -Path "${env:TEMP}\scripts-binaries-master" -Recurse -Force
Remove-Item -Path "${env:TEMP}\scripts-binaries-master.zip" -Force

if (Test-Path "${env:SYSTEMDRIVE}\tools\binaries") {
  Remove-Item -Path "${env:SYSTEMDRIVE}\tools\binaries" -Recurse -Force
}

#------------------------------------------------------------------------------

if (Test-Path "$poshDir\Profile.ps1") {
  Write-Output "Removing previous installed profile..."

  @(
    "$poshDir\Microsoft.PowerShell_profile.ps1"
    "$poshDir\Microsoft.VSCode_profile.ps1"
    "$poshDir\profile.ps1"
  ) | ForEach-Object {
    if (Test-Path $_) {
      Remove-Item -Path $_ -Force -ErrorAction SilentlyContinue
    }
  }
}

Write-Output "Installing profile to '$poshDir' ..."

@(
  "${env:TEMP}\scripts-powershell-main\Microsoft.PowerShell_profile.ps1"
  "${env:TEMP}\scripts-powershell-main\Microsoft.VSCode_profile.ps1"
  "${env:TEMP}\scripts-powershell-main\profile.ps1"
) | ForEach-Object {
  Copy-Item -Path $_ -Destination $poshDir -Recurse -Force
}

Remove-Item -Path "${env:TEMP}\scripts-powershell-main.zip" -Force
Remove-Item -Path "${env:TEMP}\scripts-powershell-main" -Recurse -Force

Write-Output "Checking modules path for '$modulesDir' ..."

if ((-not ($env:PSModulePath).Contains($modulesDir))) {
  Write-Output "Adding '$modulesDir' to modules path..."

  $userPath = $modulesDir + ";" `
    + [Environment]::GetEnvironmentVariable('PSModulePath', 'User')
  $machinePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

  $env:PSModulePath = $userPath + ";" + $machinePath

  Get-Module -ListAvailable | Out-Null

  Invoke-Expression "[Environment]::SetEnvironmentVariable('PSModulePath', '$userPath', 'User')"
}

#------------------------------------------------------------------------------

Invoke-WebRequest -Uri "https://github.com/cameronharp/Go-Shell/archive/master.zip" `
  -UseBasicParsing -OutFile "${env:TEMP}\posh-go.zip"

Microsoft.PowerShell.Archive\Expand-Archive -Path "${env:TEMP}\posh-go.zip" `
  -DestinationPath "${env:TEMP}\" -Force

if (Test-Path "$modulesDir\go") {
  Write-Output "Removing previous version of posh-go..."
  Remove-Item "$modulesDir\go" -Recurse -Force
}

New-Item -Type Directory -Path "$modulesDir\go" | Out-Null

Copy-Item -Path "${env:TEMP}\Go-Shell-master\*" -Destination "$modulesDir\go"

Remove-Item -Path "${env:TEMP}\posh-go.zip" -Force
Remove-Item -Path "${env:TEMP}\Go-Shell-master" -Recurse -Force

#------------------------------------------------------------------------------

if ((Get-Module PackageManagement -ListAvailable | Measure-Object).Count -gt 1) {
  Import-Module PackageManagement -RequiredVersion `
    "$((Get-Module PackageManagement -ListAvailable `
      | Sort-Object Version -Descending `
      | Select-Object -First 1).Version.ToString())"
} else {
  Import-Module PackageManagement
}

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Verbose

if ((Get-Module PowershellGet -ListAvailable | Measure-Object).Count -gt 1) {
  Import-Module PowerShellGet -RequiredVersion `
    "$((Get-Module PowershellGet -ListAvailable `
      | Sort-Object Version -Descending `
      | Select-Object -First 1).Version.ToString())"
} else {
  Import-Module PowerShellGet
}

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -Verbose

if (-not (Get-PSRepository -Name "dcjulian29-powershell" -ErrorAction SilentlyContinue)) {
  Register-PSRepository -Name "dcjulian29-powershell" `
    -SourceLocation "https://www.myget.org/F/dcjulian29-powershell/api/v2" -Verbose
} else {
  Set-PSRepository -Name "dcjulian29-powershell" `
    -SourceLocation "https://www.myget.org/F/dcjulian29-powershell/api/v2" -Verbose
}

Set-PSRepository -Name "dcjulian29-powershell" -InstallationPolicy Trusted -Verbose

#------------------------------------------------------------------------------

Push-Location $PSScriptRoot

(Get-Content "thirdparty.json" | ConvertFrom-Json) | ForEach-Object {
  Write-Output "`n--------------------------------------`n"
  if (($_ -eq "PackageManagement") -or ($_ -eq "PowerShellGet")) {
    # These two are a little different as their base version is manually installed.
    continue
  }

  if (Get-Module -Name $_ -ListAvailable -ErrorAction SilentlyContinue) {
    Write-Output "Updating third-party '$_' module...`n"
    Update-Module -Name $_ -Verbose -Confirm:$false
  } else {
    Write-Output "Installing third-party '$_' module...`n"
    Install-Module -Name $_ -Verbose -AllowClobber
  }
}

(Get-Content "mine.json" | ConvertFrom-Json) | ForEach-Object {
  Write-Output "`n--------------------------------------`n"
  if (Get-Module -Name $_ -ListAvailable -ErrorAction SilentlyContinue) {
    Write-Output "Updating my '$_' module...`n"
    Update-Module -Name $_ -Verbose -Confirm:$false
  } else {
    Write-Output "Installing my '$_' module...`n"
    Install-Module -Name $_ -Repository "dcjulian29-powershell" -Verbose -AllowClobber
  }
}

Pop-Location

Get-Module -ListAvailable | Out-Null

Write-Output "============================================================================"

Write-Output (Get-InstalledModule `
  | Select-Object Name,Version,PublishedDate,RepositorySourceLocation `
  | Sort-Object PublishedDate -Descending `
  | Format-Table | Out-String)

Write-Output "============================================================================"
Write-Output " "

#------------------------------------------------------------------------------

Write-Output "Importing all available modules to make sure assemblies are loaded..."

Get-Module -ListAvailable | Import-Module -ErrorAction SilentlyContinue | Out-Null

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

Set-Content -Path "$poshDir\installed.txt" -Value "$(Get-Date)" -Force
