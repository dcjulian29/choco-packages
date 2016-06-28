$packageName = "visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/6/4/7/647EC5B1-68BE-445E-B137-916A0AE51304/vs_enterprise.exe"
$update = "http://download.microsoft.com/download/4/8/f/48f0645f-51b6-4733-b808-63e640cddaec/vs2015.3.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path 'HKLM:\SOFTWARE\Wow6432Node' ) {
    $path = 'HKLM:\SOFTWARE\Wow6432Node'
} else {
    $path = 'HKLM:\SOFTWARE\'
}

$installDir = "$path\Microsoft\VisualStudio"

if (Get-ChildItem $installDir -ErrorAction SilentlyContinue `
        | ? { ($_.PSChildName -match "^14.0$") } `
        | ? {$_.property -contains "InstallDir"}) {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $update -validExitCodes @(0, 3010)
} else {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes @(0, 3010)
}
