$packageName = 'autohotkey'
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
$url = "http://l.autohotkey.net/AutoHotkey_Lw.zip"
$url64 = "http://l.autohotkey.net/AutoHotkey_Lw64.zip"
$compiler = "http://l.autohotkey.net/Ahk2Exe_L.zip"
$help = "http://l.autohotkey.net/AutoHotkey_L_Help.zip"

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    Install-ChocolateyZipPackage $packageName $url $appDir $url64
    Install-ChocolateyZipPackage $packageName $compiler $appDir
    Install-ChocolateyZipPackage $packageName $help $appDir

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
