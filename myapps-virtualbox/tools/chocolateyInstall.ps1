﻿$version = "7.0.2"
$build = 154219
$log = "virtualbox-$(([Guid]::NewGuid()).Guid).log"
$url = "https://download.virtualbox.org/virtualbox/$version/VirtualBox-$version-$build-Win.exe"
$props = @(
    "/i"
    "${env:TEMP}\VirtualBox-$version-r$build.msi"
    "/passive"
    "/norestart"
    "/l* $log"
    "VBOX_INSTALLDESKTOPSHORTCUT=0"
    "VBOX_INSTALLQUICKLAUNCHSHORTCUT=0"
    "VBOX_REGISTERFILEEXTENSIONS=1"
    "VBOX_START=0"
)

Push-Location $env:TEMP

Invoke-WebRequest -Uri $url -OutFile "${env:TEMP}\virtualbox.exe"

Invoke-Expression "virtualbox.exe -extract -silent"

Invoke-Expression "msiexec.exe $($props -join ' ')"

Get-Content $log

Pop-Location