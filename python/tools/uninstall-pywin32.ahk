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
