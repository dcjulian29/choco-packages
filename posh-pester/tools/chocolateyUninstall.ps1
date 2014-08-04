$packageName = "posh-pester"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\pester"

try {
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
