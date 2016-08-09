$packageName = "dotnet"
$installerType = "EXE"
$installerArgs = "/passive /norestart"
$url = "https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
$errorCode = @(0, 3010)

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$path = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'

$release = "394271"
$release10 = "394254"

$compare = (Get-ItemProperty -LiteralPath $Path).psbase.members | `
                ForEach-Object { $_.name } | `
                Compare-Object "Release" -IncludeEqual -ExcludeDifferent

if ($compare -ne $null) {
    if ($compare.SideIndicator -like "==") {
        $installed = (Get-ItemProperty $path -Name Release -ErrorAction SilentlyContinue).Release

        if ($release.Contains($installed) -or $release10.Contains($installed)) {
            Write-Output ".Net Framework 4.6.1 is already installed on this system."
        } else {
            Install-ChocolateyPackage $packageName $installerType $installerArgs $url `
                -ValidExitCodes $errorCode
        }
    }
}
