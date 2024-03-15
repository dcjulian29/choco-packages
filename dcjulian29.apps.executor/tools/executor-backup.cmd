@echo off

set EXECUTOR=%TEMP%\executor

set EXDIR=%SYSTEMDRIVE%\etc\executor
set BVER=%date:~-4,4%%date:~-10,2%%date:~-7,2%
set BVER=%BVER%_%time:~0,2%%time:~3,2%%time:~6,2%
set BVER=%BVER: =0%

echo Backing up original executor.ini file...
copy %EXDIR%\executor.ini %EXDIR%\backup\%BVER%.ini

echo.
pause
