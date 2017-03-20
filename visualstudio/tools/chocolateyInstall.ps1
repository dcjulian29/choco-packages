$packageName = "visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

$env:SEE_MASK_NOZONECHECKS = 1

if ($env:chocolateyInstallArguments) {
    $arguments = ($env:chocolateyInstallArguments).ToLower()
}

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

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait

Remove-Item env:SEE_MASK_NOZONECHECKS -Force
