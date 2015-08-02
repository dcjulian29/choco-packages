$packageName = "dotnet"
$installerType = "EXE"
$installerArgs = "/passive /norestart"
$url = "http://download.microsoft.com/download/6/F/9/6F9673B1-87D1-46C4-BF04-95F24C3EB9DA/enu_netfx/NDP46-KB3045557-x86-x64-AllOS-ENU_exe/NDP46-KB3045557-x86-x64-AllOS-ENU.exe"
$errorCode = @(0, 3010)

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$path = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
$release = "393295"

$compare = (Get-ItemProperty -LiteralPath $Path).psbase.members | `
                ForEach-Object { $_.name } | `
                Compare-Object "Release" -IncludeEqual -ExcludeDifferent

if ($compare -ne $null) {
    if ($compare.SideIndicator -like "==") {
        $installed = (Get-ItemProperty $path -Name Release -ErrorAction SilentlyContinue).Release

        if ($release.Contains($installed)) {
            Write-Output ".Net Framework 4.6 is already installed on this system."
        } else {
            Install-ChocolateyPackage $packageName $installerType $installerArgs $url `
                -ValidExitCodes $errorCode
        }
    }
}
