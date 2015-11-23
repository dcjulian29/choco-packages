$packageName = "markdown-edit"
$installerType = "MSI"
$installerArgs = '/qb SKIPFRAMEWORKCHECK="1"'
$version = "v1.16.0"
$url = "https://github.com/mike-ward/Markdown-Edit/releases/download/$version/MarkdownEditSetup.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
