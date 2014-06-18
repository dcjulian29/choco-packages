$packageName = "npp-scriptcs"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$url = "https://csscriptnpp.codeplex.com/downloads/get/865641"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path "C:\Program Files (x86)\Notepad++")
    {
        $plugin = "C:\Program Files (x86)\Notepad++\plugins"
    }
    
    if (Test-Path "C:\Program Files\Notepad++")
    {
        $plugin = "C:\Program Files\Notepad++\plugins"
    }

    if (Test-Path "$($plugin)\CSScriptNpp")
    {
        $cmd = "Remove-Item '$($plugin)\CSScriptNpp' -Recurse -Force;" `
            + "Remove-Item '$($plugin)\CSScriptNpp.dll' -Force"

        Start-ChocolateyProcessAsAdmin $cmd
    }

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$($downloadPath)\$($packagename).zip" $url
    Get-ChocolateyUnzip "$($downloadPath)\$($packagename).zip" "$($downloadPath)\"

    if (-not (Test-Path $($plugin))) {
        New-Item -Type Directory -Path $plugin | Out-Null
    }

    $cmd = "Copy-Item -Path '$($downloadPath)\Plugins\*' -Recurse -Destination '$plugin\' -Container"

    Start-ChocolateyProcessAsAdmin $cmd

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
