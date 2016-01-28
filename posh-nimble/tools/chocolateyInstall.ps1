$packageName = "posh-nimble"
$url = "https://raw.github.com/jrich523/NimblePowerShell/master/"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\Nimble"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir)
{
  Write-Output "Removing previous version of package..."
  Remove-Item "$($appDir)" -Recurse -Force
}

$wc = New-Object System.Net.WebClient

$wc.DownloadFile("$url/Nimble.psd1", "$appdir\Nimble.psd1")

Push-Location

Set-Location $appDir

(Import-LocalizedData -FileName Nimble.psd1).FileList | For-EachObject {
    $wc.DownloadFile("$url/$_", "$appdir\$_")
}

Get-ChildItem | UnBlock-File

Pop-Location
