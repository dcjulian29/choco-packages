if exist "%USERPROFILE%\Documents\Visual Studio 2015\Projects" SET PROJECTS=true

if "%PROJECTS%" == "true" rmdir "%USERPROFILE%\Documents\Visual Studio 2015\Projects"
if "%PROJECTS%" == "true" mklink /J "%USERPROFILE%\Documents\Visual Studio 2015\Projects" %SYSTEMDRIVE%\code

if exist "%USERPROFILE%\Documents\SQL Server Management Studio" SET SQL=true

if "%SQL%" == "true" rmdir "%USERPROFILE%\Documents\SQL Server Management Studio"
if "%SQL%" == "true" mklink /J "%USERPROFILE%\Documents\SQL Server Management Studio" %SYSTEMDRIVE%\code
