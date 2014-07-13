$packageName = "npp-scriptcs"

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
        $cmd = "Remove-Item '$($plugin)\CSScriptNpp' -Recurse -Force;Remove-Item '$($plugin)\CSScriptNpp.dll' -Force"

        Start-ChocolateyProcessAsAdmin $cmd
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
