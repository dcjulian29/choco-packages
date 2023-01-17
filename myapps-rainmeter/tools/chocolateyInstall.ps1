Download-File -Url "https://github.com/rainmeter/rainmeter/releases/download/v4.5.17.3700/Rainmeter-4.5.17.exe" `
  -Destination $env:TEMP\rainmeter.exe

Start-Process -FilePath $env:TEMP\rainmeter.exe -ArgumentList @(
   "/S", "/AUTOSTARTUP=1", "/RESTART=0" ) -NoNewWindow -Wait

if (-not (Test-Path $env:APPDATA\Rainmeter)) {
  New-Item -Path $env:APPDATA\Rainmeter -ItemType Directory | Out-Null
}

if (Test-Path $env:SystemDrive\etc\rainmeter\$env:COMPUTERNAME\rainmeter.ini) {
  if (Get-Process -Name Rainmeter -ErrorAction SilentlyContinue) {
    Stop-Process -Name Rainmeter -Force
  }

  if (Test-Path $env:APPDATA\Rainmeter\Rainmeter.ini) {
    Remove-Item -Path $env:APPDATA\Rainmeter\Rainmeter.ini -Force

    if (Test-Path $env:APPDATA\Rainmeter\Layouts) {
      Remove-Item -Path $env:APPDATA\Rainmeter\Layouts -Recurse -Force
    }

    if (Test-Path $env:APPDATA\Rainmeter\Plugins) {
      Remove-Item -Path $env:APPDATA\Rainmeter\Plugins -Recurse -Force
    }
  }

  Push-Location $env:SystemDrive\etc\rainmeter\$env:COMPUTERNAME

  Copy-Item -Path "rainmeter.ini" -Destination "${env:APPDATA}\Rainmeter\Rainmeter.ini"
  Copy-Item -Path "./Layouts" -Destination "${env:APPDATA}\Rainmeter" -Recurse
  Copy-Item -Path "./Plugins" -Destination "${env:APPDATA}\Rainmeter" -Recurse

  if (Test-Path $env:USERPROFILE\Documents\Rainmeter) {
    Remove-Item -Path $env:USERPROFILE\Documents\Rainmeter -Recurse -Force
  }

  Pop-Location

  Start-Process -FilePath "${env:ProgramFiles}\Rainmeter\Rainmeter.exe"
}
