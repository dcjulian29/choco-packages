$packageName = "posh-pester"
$version = "3.3.2"
$url = "https://codeload.github.com/pester/Pester/zip/$version"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\pester"
$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)" -Recurse -Force
    }

    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$version.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$version.zip" "$downloadPath\"

    $source = "$downloadPath\Pester-$version"
    New-Item -Type Directory -Path $appDir | Out-Null

    Copy-Item -Path "$source\Pester.ps*" -Destination "$appDir"
    New-Item -Type Directory -Path "$appDir\en-US" | Out-Null
    Copy-Item -Path "$source\en-US\*" -Destination "$appDir\en-US"
    New-Item -Type Directory -Path "$appDir\Functions" | Out-Null
    Copy-Item -Path "$source\Functions\*" -Destination "$appDir\Functions" -Recurse

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
