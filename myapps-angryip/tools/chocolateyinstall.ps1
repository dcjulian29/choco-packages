# One-time package rename
if (Test-Path "../../angryip-julian") {
    Remove-Item -Path "../../angryip-julian" -Recurse -Force
    return
}

$version = "${env:ChocolateyPackageVersion}"
$url = "https://github.com/angryip/ipscan/releases/download/$version/ipscan-win64-$version.exe"
$app = "${env:ChocolateyInstall}\bin\ipscan.exe"

if (Test-Path $app) {
    Write-Output "Removing previous version of package..."
    Remove-Item -Path $app -Force
}

Invoke-WebRequest -Uri $url -OutFile $app -UseBasicParsing
