$major = [System.Environment]::OSVersion.Version.Major
$minor = [System.Environment]::OSVersion.Version.Minor

if ($major -eq 6) {
    if ($minor -eq 1 ) {
        $packageName = "rsat-win7"
        $url = "http://download.microsoft.com/download/4/F/7/4F71806A-1C56-4EF2-9B4F-9870C4CFD2EE/Windows6.1-KB958830-x86-RefreshPkg.msu"
        $url64 = "http://download.microsoft.com/download/4/F/7/4F71806A-1C56-4EF2-9B4F-9870C4CFD2EE/Windows6.1-KB958830-x64-RefreshPkg.msu"
    }

    if ($minor -eq 2 ) {
        $packageName = "rsat-win8"
        $url = "http://download.microsoft.com/download/1/8/E/18EA4843-C596-4542-9236-DE46F780806E/Windows8.1-KB2693643-x86.msu"
        $url64 = "http://download.microsoft.com/download/1/8/E/18EA4843-C596-4542-9236-DE46F780806E/Windows8.1-KB2693643-x64.msu"
    }
}

$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (-not (Test-Path $downloadPath))
{
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

if ($packageName) {
    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.msu" $url $url64

#Wait for next process.
    & "$downloadPath\$packageName.msu" /quiet /noreboot

    & dism.exe /online /enable-feature `
        /featurename:RemoteServerAdministrationTools `
        /featurename:RemoteServerAdministrationTools-Roles `
        /featurename:RemoteServerAdministrationTools-Roles-CertificateServices `
        /featurename:RemoteServerAdministrationTools-Roles-CertificateServices-CA `
        /featurename:RemoteServerAdministrationTools-Roles-AD `
        /featurename:RemoteServerAdministrationTools-Roles-AD-DS `
        /featurename:RemoteServerAdministrationTools-Roles-AD-DS-SnapIns `
        /featurename:RemoteServerAdministrationTools-Roles-AD-DS-AdministrativeCenter `
        /featurename:RemoteServerAdministrationTools-Roles-AD-Powershell `
        /featurename:RemoteServerAdministrationTools-Roles-DHCP `
        /featurename:RemoteServerAdministrationTools-Roles-DNS `
        /featurename:RemoteServerAdministrationTools-Roles-FileServices `
        /featurename:RemoteServerAdministrationTools-Roles-FileServices-Dfs `
        /featurename:RemoteServerAdministrationTools-Roles-FileServices-Fsrm `
        /featurename:RemoteServerAdministrationTools-Roles-FileServices-StorageMgmt `
        /featurename:RemoteServerAdministrationTools-Features `
        /featurename:RemoteServerAdministrationTools-Features-Clustering `
        /featurename:RemoteServerAdministrationTools-Features-GP `
        /featurename:RemoteServerAdministrationTools-Features-LoadBalancing 

    if (($major -eq 6 ) -and ($minor -eq 1)) {
        & dism.exe /online /enable-feature `
            /featurename:RemoteServerAdministrationTools-Roles-HyperV `
    }

    if (($major -eq 6 ) -and ($minor -eq 2)) {
        & dism.exe /online /enable-feature `
            /featurename:Microsoft-Hyper-V-Management-Clients `
            /featurename:Microsoft-Hyper-V-Management-PowerShell
    }
}
