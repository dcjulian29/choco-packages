$packageName = "ruby"
$installerArgs = "/silent /dir=""${env:SYSTEMDRIVE}\ruby"" /tasks=""addtk,assocfiles"""
$url = "https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3.exe"
$url64 = "https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3-x64.exe"

$downloadPath = "$env:TEMP\$packageName\"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

Invoke-ElevatedCommand "$downloadPath\$packageName.exe" -ArgumentList $installerArgs -Wait

$env:PATH = "${env:PATH};${env:SYSTEMDRIVE}\ruby\bin"

& gem install bundle

Invoke-ElevatedScript {
    $mklink = "cmd.exe /c mklink"
    $links = @(
        "ruby"
    )

    $scripts = @(
        "gem"
        "bundle"
    )

    foreach ($link in $links) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
        }

        Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.exe' '$env:SYSTEMDRIVE\ruby\bin\$link.exe'"
    }

    foreach ($link in $scripts) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.cmd") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.cmd").Delete()
        }

        Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.cmd' '$env:SYSTEMDRIVE\ruby\bin\$link.cmd'"
    }
}
