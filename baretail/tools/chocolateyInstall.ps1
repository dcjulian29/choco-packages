$packageName = 'baretail'
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
$url = "http://www.baremetalsoft.com/baretail/download.php?p=m"

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    if (-not $(Test-Path $appDir)) {
        mkdir $appDir
    }

    Get-ChocolateyWebFile $packageName "$appDir\baretail.exe" $url 

    $exe = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\postInstall.ps1"
    Start-ChocolateyProcessAsAdmin ". $exe"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
