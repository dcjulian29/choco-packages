$packageName = "sourcetree"
$installerType = "EXE"
$installerArgs = "/passive"
$url = "https://downloads.atlassian.com/software/sourcetree/windows/SourceTreeSetup_1.8.3.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

# On my Dev VMs, I have a pre-configured folder with licensing and configuration...
if (-not (Test-Path "$env:USERPROFILE\AppData\Local\Atlassian")) {
    if (Test-Path "C:\etc\sourcetree") {
        New-Item -ItemType Directory "$env:USERPROFILE\AppData\Local\Atlassian" | Out-Null
        Copy-Item -Recurse "C:\etc\sourcetree\*" $appProfile
    }
}
