$packageName = "vlc"
$installerType = "exe"
$installerArgs = "/L=1033 /S"
$url = "http://get.videolan.org/vlc/2.2.4/win32/vlc-2.2.4-win32.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    if (Test-ProcessAdminRights) {
        Remove-Item "$($env:PUBLIC)\Desktop\VLC media player.lnk" -Force
    } else {
        Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\VLC media player.lnk' -Force"
    }


    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
