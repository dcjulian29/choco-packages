$packageName = "truecrypt"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$downloadPath = "$env:TEMP\chocolatey\truecrypt"
$installer = "$downloadPath\truecryptInstall.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

# The A-HOLES at the truecrypt site try to obfusicate the download link for the installer as well as not providing an option to do automated installs... There "hiding" of the download and installer options seem counter-intuitive to the open-source nature of their project...
$hostUrl = "http://www.truecrypt.org/download/transient"
$file = "TrueCrypt%20Setup%207.1a.exe"

# I would have used the Invoke-WebRequest but something keeps poping the web browser
# which opens the web browser to the page. so.... I just do it old-fashion string matching...
# $page = Invoke-WebRequest -Uri http://www.truecrypt.org/downloads)
# $linkId = ($page.InputFields | where { $_.outerHtml.contains("LinkT") }).value
$web = New-Object Net.WebClient
$page = $web.DownloadString("http://www.truecrypt.org/downloads")

if ($page -match "<input type=`"hidden`" name=`"LinkT`" value=`"[^`"]+`">") {
    $line = [xml]"$($Matches[0])</input>"
    $linkId = $line.input.value
} else {
    throw "Could not detirmine download link."
}

$url = "$hostUrl/$linkId/$file"

try
{
    if (!(Test-Path $downloadPath)) {
        New-Item -ItemType directory $downloadPath -Force
    }

    Get-ChocolateyWebFile $packageName $installer $url

    if (Test-Path "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe") {
        $ahkExe = "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe"
        $ahkScript = "$toolDir\install.ahk"

        Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript" -noSleep
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
