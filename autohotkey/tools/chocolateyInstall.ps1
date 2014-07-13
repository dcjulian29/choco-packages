$packageName = 'autohotkey'
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$url = "http://ahkscript.org/download/ahk-u32.zip"
$url64 = "http://ahkscript.org/download/ahk-u64.zip"
$compiler = "http://ahkscript.org/download/ahk2exe.zip"
$help = "http://ahkscript.org/download/1.1/AutoHotkeyHelp.zip"

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
