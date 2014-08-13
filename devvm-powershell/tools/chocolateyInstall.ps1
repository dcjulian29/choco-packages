$packageName = "devvm-powershell"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {

    Import-Module "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\go\go.psm1"
    go -key "projects" -selectedPath "C:\home\projects" -add
    go -key "etc" -selectedPath "C:\home\vm\etc" -add
    go -key "home" -selectedPath "$($env:USERPROFILE)" -add
    go -key "downloads" -selectedPath "$($env:USERPROFILE)\Downloads" -add
    go -key "docs" -selectedPath "$($env:USERPROFILE)\Documents" -add
    go -key "documents" -selectedPath "$($env:USERPROFILE)\Documents" -add
    go -key "pics" -selectedPath "$($env:USERPROFILE)\Pictures" -add
    go -key "pictures" -selectedPath "$($env:USERPROFILE)\Pictures" -add
    go -key "videos" -selectedPath "$($env:USERPROFILE)\Videos" -add
    go -key "desktop" -selectedPath "$($env:USERPROFILE)\Desktop" -add

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
