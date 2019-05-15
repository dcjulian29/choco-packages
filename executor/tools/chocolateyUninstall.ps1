$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$key = Get-Item $location

if ($null -ne $key.GetValue("Executor", $null)) {
    Remove-ItemProperty -Path $location -Name "Executor"
}
