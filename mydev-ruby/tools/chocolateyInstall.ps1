$packageName = "mydev-ruby"

& gem install jekyll

Invoke-ElevatedScript {
    $mklink = "cmd.exe /c mklink"

    $scripts = @(
        "jekyl"
        "rake"
    )

    foreach ($link in $scripts) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.bat") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.bat").Delete()
        }

        Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.bat' '$env:SYSTEMDRIVE\ruby\bin\$link.bat'"
    }
}
