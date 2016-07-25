$packageName = "mysettings-devvm"

$packages = @(
    "mydev-powershell",
    "mydev-scm",
    "mydev-tools",
    "mydev-nodejs",
    "mydev-python",
    "mydev-database",
    "mydev-visualstudio",
    "mydev-buildtools",
    "mysettings-devenv"
)

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$devvmpackage = (Get-ChildItem "$($env:ChocolateyInstall)\lib" `
    | Select-Object basename).basename `
    | Where-Object { $_.StartsWith($packageName) }

if ($devvmpackage.Count -gt 1) {
    Write-Warning "This package has already been installed, It is not meant to be used to upgrade..."
    exit
}

if (Test-Path "$env:WINDIR\Setup\Scripts\choco.log") {
    Copy-Item "$env:WINDIR\Setup\Scripts\choco.log" `
        "$env:SYSTEMDRIVE\home\vm\logs\$($env:COMPUTERNAME)-choco.log" -Force
}

if (Test-Path "$env:WINDIR\Setup\Scripts\install.log") {
    Copy-Item "$env:WINDIR\Setup\Scripts\install.log" `
        "$env:SYSTEMDRIVE\home\vm\logs\$($env:COMPUTERNAME)-install.log" -Force
}

if (Test-Path "$env:WINDIR\Setup\Scripts\SetupComplete.log") {
    Copy-Item "$env:WINDIR\Setup\Scripts\SetupComplete.log" `
        "$env:SYSTEMDRIVE\home\vm\logs\$($env:COMPUTERNAME)-SetupComplete.log" -Force
}
    
foreach ($package in $packages) {
    $logFile = "$env:SYSTEMDRIVE\home\vm\logs\$($env:COMPUTERNAME)-$package.log"
    choco.exe install $package -y | Tee-Object -FilePath $logFile
    
    # Now lets check for errors...
    if (Get-Content $logFile | Select-String -Pattern "\[ERROR\]") {
        Write-Warning "An error occurred during the last package ($package) install..."
        Write-Warning "Review the log file: $logFile"
        Write-Warning "And then decide whether to continue..."
        
        Read-Host "Press Enter to continue with next package"
    }
}

Import-Module "${env:USERPROFILE}\Documents\WindowsPowerShell\Modules\go\go.psm1"
Set-Alias -Name go -Value gd

go -Key "etc" -delete
go -Key "etc" -SelectedPath "${env:SYSTEMDRIVE}\etc" -add
go -Key "documents" -delete
go -Key "documents" -SelectedPath "${env:USERPROFILE}\documents" -add
go -Key "docs" -delete
go -Key "docs" -SelectedPath "${env:USERPROFILE}\documents" -add
go -Key "pictures" -delete
go -Key "pictures" -SelectedPath "${env:USERPROFILE}\pictures" -add
go -Key "pics" -delete
go -Key "pics" -SelectedPath "${env:USERPROFILE}\pictures" -add
go -Key "videos" -delete
go -Key "videos" -SelectedPath "${env:USERPROFILE}\videos" -add
go -Key "desktop" -delete
go -Key "desktop" -SelectedPath "${env:USERPROFILE}\desktop" -add
go -Key "downloads" -delete
go -Key "downloads" -SelectedPath "$env:USERPROFILE\downloads" -add

$import = "Import-StartLayout -LayoutPath $env:SYSTEMDRIVE\etc\StartScreenLayout.xml -MountPath $env:SYSTEMDRIVE\"

if (Test-Path "$env:SYSTEMDRIVE\etc\StartScreenLayout.xml" ) {
    if (Test-ProcessAdminRights) {
        Invoke-Expression $import
    } else {
        Start-ChocolateyProcessAsAdmin $import
    }
}
