Set-ExecutionPolicy -Scope LocalMachine RemoteSigned -Force

if (Test-Path "${env:SYSTEMDRIVE}\Program Files (x86)") {
    $PF32 = "${env:SYSTEMDRIVE}\Program Files (x86)"
} else {
    $PF32 = "${env:SYSTEMDRIVE}\Program Files"
}

setx.exe /m PF32 $PF32

Invoke-WebRequest "https://chocolatey.org/install.ps1" -UseBasicParsing | Invoke-Expression

choco source remove -n"chocolatey"

choco source add --name 'dcjulian29-chocolatey' `
  --source 'https://www.myget.org/F/dcjulian29-chocolatey/api/v2' `
  --priority 2

choco source add --name 'choco' `
  --source 'https://chocolatey.org/api/v2' `
  --priority 3

choco config set --name "commandExecutionTimeoutSeconds" --value "3600"
