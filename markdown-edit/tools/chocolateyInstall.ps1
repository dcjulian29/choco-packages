$packageName = "markdown-edit"
$installerType = "MSI"
$installerArgs = '/qb SKIPFRAMEWORKCHECK="1"'
$version = "v1.31"
$url = "https://github.com/mike-ward/Markdown-Edit/releases/download/$version/MarkdownEditSetup.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-Path "$($env:PUBLIC)\Desktop\Markdown Edit.lnk") {
    Remove-Item "$($env:PUBLIC)\Desktop\Markdown Edit.lnk" -Force
}


if (Test-Path "$($env:USERPROFILE)\Desktop\Markdown Edit.lnk") {
    Remove-Item "$($env:USERPROFILE)\Desktop\Markdown Edit.lnk" -Force
}
