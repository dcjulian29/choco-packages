$packageName = "wmiexplorer"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$url = "http://www.hostmonitor.biz/download/wmiexplorer.zip"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try {
    if (Test-Path $appDir) {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    mkdir $appDir | Out-Null

    if (-not (Test-Path $downloadPath)) {
        mkdir $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$appDir\"

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
