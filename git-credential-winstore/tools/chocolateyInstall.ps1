$packageName = "git-credential-winstore"
$url = "https://gitcredentialstore.codeplex.com/downloads/get/672532"
$downloadPath = "${env:TEMP}\chocolatey\$packageName"
$appDir = "${env:SYSTEMDRIVE}\tools\apps\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path "$env:ProgramFiles\Git") {
        $git = "$env:ProgramFiles\Git\bin\git.exe"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\Git") {
        $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
    }

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.exe" $url

    if (Test-Path $appDir) {
        Write-Output "Removing previous version of package..."
        Remove-Item -Path $appDir -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null

    Copy-Item -Path "$downloadPath\$packageName.exe" -Destination "$appDir\"

    & $git config --global credential.helper "!'$appdir\git-credential-winstore.exe'"

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
