if exist "%USERPROFILE%\Documents\Visual Studio 2015\Projects" rmdir "%USERPROFILE%\Documents\Visual Studio 2015\Projects"
mklink /J "%USERPROFILE%\Documents\Visual Studio 2015\Projects" %SYSTEMDRIVE%\home\projects

if exist "%USERPROFILE%\Documents\SQL Server Management Studio\Projects" rmdir "%USERPROFILE%\Documents\SQL Server Management Studio\Projects"
mklink /J "%USERPROFILE%\Documents\SQL Server Management Studio\Projects" %SYSTEMDRIVE%\home\projects

