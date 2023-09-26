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
for /f "usebackq delims=" %%O in (`dir /b /ad %USERPROFILE%`) do (
  for /f "usebackq delims=" %%D in (`dir /b /ad %USERPROFILE%\%%O 2^>nul`) do (
    if [%%D] EQU [etc] (
      if exist "%USERPROFILE%\%%O\%%D\executor" (
        copy /V %EXECUTOR%\executor.ini %USERPROFILE%\%%O\%%D\executor\executor.ini
        echo %EXECUTOR%\executor.ini --^> %USERPROFILE%\%%O\%%D\executor\executor.ini
      )
    )
  )
)

:EOF

echo.
pause
