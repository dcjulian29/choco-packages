$packageName = "visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$arguments = ($env:chocolateyInstallArguments).ToLower()

switch ($arguments) {
    "community" {
        $url = "http://download.microsoft.com/download/D/2/3/D23F4D0F-BA2D-4600-8725-6CCECEA05196/vs_community_ENU.exe"
        break
    }

    "professional" {
        $url = "http://download.microsoft.com/download/D/2/8/D28D3B41-BF4A-409A-AFB5-2C82C216D4E1/vs_professional_ENU.exe"
        break
    }

    default {
        $url = "http://download.microsoft.com/download/C/7/8/C789377D-7D49-4331-8728-6CED518956A0/vs_enterprise_ENU.exe"
        break
    }
}

$update = "http://download.microsoft.com/download/4/8/f/48f0645f-51b6-4733-b808-63e640cddaec/vs2015.3.exe"

if (Test-Path 'HKLM:\SOFTWARE\Wow6432Node' ) {
    $path = 'HKLM:\SOFTWARE\Wow6432Node'
} else {
    $path = 'HKLM:\SOFTWARE\'
}

$installDir = "$path\Microsoft\VisualStudio"

if (Get-ChildItem $installDir -ErrorAction SilentlyContinue `
        | ? { ($_.PSChildName -match "^14.0$") } `
        | ? {$_.property -contains "InstallDir"}) {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $update -validExitCodes @(0, 3010)
} else {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes @(0, 3010)
}
