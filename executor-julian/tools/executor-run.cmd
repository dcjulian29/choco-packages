@echo off

setlocal

set EXETC=%SYSTEMDRIVE%\etc\executor
set EXDST=%TEMP%\executor

if exist %EXDST% (
    echo Stopping the running Executor process...
    taskkill /IM executor.exe
  
    ping 127.0.0.1 -n 2 >NUL

    echo Removing existing temporary files...
    rmdir /s /q %EXDST% >nul
    ping 127.0.0.1 -n 2 >NUL
    if exist %EXDST% (
        echo ...
        rmdir /s /q %EXDST% >nul
    )

    if exist %EXDST% (
        echo A process has a lock on the directory, please remove it manually.
        pause
        
        :: One more try...
        rmdir /s /q %EXDST% >nul
    )
)

if not exist %EXDST$ (
    mkdir %EXDST%
)

if exist %EXETC%\executor.ini (
    copy /Y %EXETC%\executor.ini %EXDST% >nul
)

copy %~dp0\executor.exe %EXDST% >nul
copy %~dp0\defaulticon.ico %EXDST% >nul
copy %~dp0\hookwinr.dll %EXDST% >nul

pushd %EXDST%

:: "touch" all of the files so that they do not appear to be "older than 7 days" when the
:: dir-clean-temp script runs...

for /R "." %%G in (.) do (
  pushd %%G

  for /f "delims=|" %%F in ('dir /B /A:-D .') do (
    copy "%%F" +,, >nul
  )

  popd
)

echo Starting Executor

start %EXDST%\Executor.exe -s

popd

endlocal
