#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, RegEx

; Uninstall any previous versions...
uninstaller = %A_SYSTEMDRIVE%\python\Removepywin32.exe

IfExist, %uninstaller%
{
    Sleep, 1000
	Run, "%uninstaller%" -u "%A_SYSTEMDRIVE%\python\pywin32-wininst.log"

	WinWait, Please confirm,, 30
	IfWinExist
	{
		BlockInput, On
		Sleep, 250
		WinActivate
		Send, {ALTDOWN}y{ALTUP}
		BlockInput, Off
	}

	WinWait, Uninstall Finished,, 30
	IfWinExist
	{
		BlockInput, On
		Sleep, 250
		WinActivate
		Send, {ENTER}
		BlockInput, Off
	}
}

; Install
installer = %A_Temp%\chocolatey\python\pywin32.exe
Sleep, 1000
Run, %installer%

WinWaitActive, Setup,, 30
IfWinExist
{
    Loop, 3
    {
        BlockInput, On
        Sleep, 250
        WinActivate, Setup
        Send, {ALTDOWN}n{ALTUP}
    }
}

WinWaitActive, Setup,Postinstall script finished, 60
IfWinExist
{
    BlockInput, On
    Sleep, 250
    WinActivate, Setup
    Send, {ENTER}
}
