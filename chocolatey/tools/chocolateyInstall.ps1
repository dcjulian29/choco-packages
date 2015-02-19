$packageName = "chocolatey"
$version = "0.9.8.33"
$url = "https://chocolatey.org/api/v2/package/chocolatey/$version"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path $downloadPath) {
        Write-Output "Removing previously downloaded chocolatey install files..."
        Remove-Item -Path $downloadPath -Recurse -Force
    }

    New-Item -Type Directory -Path $downloadPath | Out-Null

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    if (Test-ProcessAdminRights) {
        & "$downloadPath\tools\chocolateyInstall.ps1"
        icacls.exe "${env:CHOCOLATEYINSTALL}" --% /grant Everyone:(OI)(CI)F /T
    } else {
        Start-ChocolateyProcessAsAdmin "$downloadPath\tools\chocolateyInstall.ps1"
        Start-ChocolateyProcessAsAdmin "`$p='Everyone:(OI)(CI)F';icacls.exe '${env:CHOCOLATEYINSTALL}' /grant `$p /T"
    }

    # I prefer to use my private repository and want "all" users to use the same repository
    (Get-Content "${env:CHOCOLATEYINSTALL}\chocolateyinstall\chocolatey.config") `
        -replace '<source id="chocolatey" value="https://chocolatey.org/api/v2/" />', `
                 '<source id="dcjulian29" value="https://www.myget.org/F/dcjulian29-chocolatey" />' `
        | Set-Content "${env:CHOCOLATEYINSTALL}\chocolateyinstall\chocolatey.config"

    # I think the next two lines are unprofessional and I have had a difficult time explaining the joke 
    # when I demonstrate this tool to others at work. Luckily, thanks to open source nature of this project,
    # I can patch my local installed to remove these lines...

    (Get-Content "${env:CHOCOLATEYINSTALL}\chocolateyinstall\helpers\functions\Write-ChocolateyFailure.ps1") `
        -replace 'Boo to the chocolatey gods!', '' `
        | Set-Content "${env:CHOCOLATEYINSTALL}\chocolateyinstall\helpers\functions\Write-ChocolateyFailure.ps1"

    (Get-Content "${env:CHOCOLATEYINSTALL}\chocolateyinstall\helpers\functions\Write-ChocolateySuccess.ps1") `
        -replace 'The chocolatey gods have answered your request!', '' `
        | Set-Content "${env:CHOCOLATEYINSTALL}\chocolateyinstall\helpers\functions\Write-ChocolateySuccess.ps1"

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
