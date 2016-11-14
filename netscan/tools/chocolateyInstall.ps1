$packageName = "netscan"
$url = "http://www.softperfect.com/download/freeware/netscan.zip"
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

# Need to "Open Web Page" since they seem to have a redirect when you go directly to URL...
$web = New-Object Net.WebClient
$web.DownloadString("http://www.softperfect.com/products/networkscanner/") | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

if (Test-Path "${env:ProgramFiles}") {
    $bits = "32-Bit"
}

if (Test-Path "${env:ProgramFiles(x86)}") {
    $bits = "64-Bit"
}

Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

if (-not (Test-Path $downloadPath\$bits)) {
    Write-Error "Zip file downloaded is corrupt!"
} else {
    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null

    Get-ChildItem -Path $downloadPath\$bits -Include $keep -Recurse | Copy-Item -Destination "$appDir"
}
