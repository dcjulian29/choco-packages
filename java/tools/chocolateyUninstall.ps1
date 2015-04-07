$packageName = "java"
$searchFilter = { ($_.GetValue('DisplayName') -like '*Java*') }  

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    $uninstallPaths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall', 
        'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') 

    foreach ($path in $uninstallPaths) { 
        if (Test-Path $path) { 
            Get-ChildItem $path | Where-Object $searchFilter | `
                Where-Object { $_.GetValue('UninstallString') } | `
                Foreach-Object { 
                    Start-Process -Wait `
                        "${env:WINDIR}\System32\msiexec.exe" "/x $($_.PSChildName) /qb"
                }
        } 
    } 

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
