$version = $env:chocolateyPackageVersion
$revision = 3803
$sha256 = "9024b3b01b3883af3e12c3023ca9f7569893d25bb8154d785ac5737c7fff3ac9"

# ---- Install

$installArgs = @{
  PackageName    = $env:chocolateyPackageName
  FileType       = "EXE"
  SilentArgs     = "/S /AUTOSTARTUP=1 /RESTART=0"
  url            = "https://github.com/rainmeter/rainmeter/releases/download/v$version.$revision/Rainmeter-$version.exe"
  checksum       = $sha256
  checksumType   = "sha256"
  ValidExitCodes = @(0, 3010)
}

Install-ChocolateyPackage @installArgs

# ---- Configuration

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
