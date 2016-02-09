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

New-Item -Type Directory -Path $appDir | Out-Null

$wc = New-Object System.Net.WebClient

$wc.DownloadFile("$url/Nimble.psd1", "$appdir\Nimble.psd1")

(Import-LocalizedData -BaseDirectory $appDir -FileName "Nimble.psd1").FileList | ForEach-Object {
    $wc.DownloadFile("$url/$_", "$appdir\$_")
}

Get-ChildItem $appDir | UnBlock-File
