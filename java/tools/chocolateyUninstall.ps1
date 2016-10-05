$searchFilter = {
    (($_.GetValue('DisplayName') -like '*Java*') `
    -and `
    ( -not ($_.GetValue('DisplayName') -like '*JavaScript*')))
}

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

Invoke-ElevatedScript -ScriptBlock {
    $links = @(
    "java"
    "javaw"
    "javaws"
    )

    foreach ($link in $links) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
        }
    }
}
