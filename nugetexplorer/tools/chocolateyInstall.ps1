$packageName = "nugetexplorer"
$url = "http://npe.codeplex.com/downloads/get/827368"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path $appDir) {
      Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    Install-ChocolateyZipPackage $packageName $url $appDir

    $testType = (cmd /c assoc ".nupkg")
    if ($testType -ne $null) {
        $fileType = $testType.Split("=")[1]
    } else {
        $fileType = "Nuget.Package"
        $cmd = "cmd /c assoc .nupkg=$fileType"
        if (Test-ProcessAdminRights) {
            Invoke-Expression $cmd
        } else {
            Start-ChocolateyProcessAsAdmin $cmd
        }
    }

    $cmd = "cmd /c ftype $fileType=`"$($appDir)\NuGetPackageExplorer.exe`" %1"

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
