@echo off

set EXECUTOR=%TEMP%\executor

set EXDIR=%SYSTEMDRIVE%\etc\executor
set BVER=%date:~-4,4%%date:~-10,2%%date:~-7,2%
set BVER=%BVER%_%time:~0,2%%time:~3,2%%time:~6,2%
set BVER=%BVER: =0%

echo Backing up original executor.ini file...
copy %EXDIR%\executor.ini %EXDIR%\backup\%BVER%.ini

echo.
echo Copying new master executor.ini file...
for /f "usebackq delims=" %%O in (`dir /b /ad %SYSTEMDRIVE%\home`) do (
    for /f "usebackq delims=" %%D in (`dir /b /ad %SYSTEMDRIVE%\home\%%O`) do (
        if [%%D] EQU [etc] (
            if exist "%SYSTEMDRIVE%\home\%%O\%%D\executor" (
                echo %EXECUTOR%\executor.ini --^> %SYSTEMDRIVE%\home\%%O\%%D\executor\executor.ini
                copy /V %EXECUTOR%\executor.ini %SYSTEMDRIVE%\home\%%O\%%D\executor\executor.ini
            )
        )
    )
)

if exist "%SYSTEMDRIVE%\home\enclara\etc\executor\executor.ini" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -NoLogo -Command "(gc '%SYSTEMDRIVE%\home\enclara\etc\executor\executor.ini') -replace '^browser=$', 'browser=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' | Out-File -encoding ASCII '%SYSTEMDRIVE%\home\enclara\etc\executor\executor.ini'"
)

:EOF

echo.
pause
