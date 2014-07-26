if exist %USERPROFILE%\Documents\WindowsPowerShell rmdir %USERPROFILE%\Documents\WindowsPowerShell
mklink /J %USERPROFILE%\Documents\WindowsPowerShell %SYSTEMDRIVE%\tools\powershell

if not exist %APPDATA%\PowerShellModules mkdir %APPDATA%\PowerShellModules

if exist %USERPROFILE%\Documents\WindowsPowerShell\Modules rmdir %USERPROFILE%\Documents\WindowsPowerShell\Modules
mklink /J %USERPROFILE%\Documents\WindowsPowerShell\Modules %APPDATA%\PowerShellModules
