#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, RegEx

; Uninstall any previous versions...
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")
winpcapUninstaller = %A_ProgramFiles%\WinPcap\Uninstall.exe
winpcapUninstallerx86 = %ProgramFilesX86%\WinPcap\Uninstall.exe

IfExist, %winpcapUninstaller%
{
    Sleep, 1000
	Run, %winpcapUninstaller%
	installed = 1
}

IfExist, %winpcapUninstallerx86%
{
    Sleep, 1000
	Run, %winpcapUninstallerx86%
	installed = 1
}

if (installed = 1)
{
	WinWait, WinPcap [\d\.]+ Uninstall,, 30
	IfWinExist
	{
		BlockInput, On
		Sleep, 250
		WinActivate
		Send, {Enter}
		BlockInput, Off
	}

	WinWait, WinPcap [\d\.]+ Uninstall, has been uninstalled, 30
    IfWinExist
    {
        BlockInput, On
        Sleep, 250
        WinActivate
        Send, {Enter}
        BlockInput, Off
    }
}

; Install WinPcap
winpcapInstaller = %A_Temp%\chocolatey\winpcap\winpcapInstall.exe
Sleep, 1000
Run, %winpcapInstaller%

WinWait, WinPcap [\d\.]+ Setup,, 30

Loop, 3
{
	gosub, setupForward
}

WinWait, WinPcap [\d\.]+ Setup, has been installed, 30
IfWinExist 
{
    BlockInput, On
    Sleep, 250
    WinActivate
    Send, {Enter}
    BlockInput, Off
}

ExitApp

setupForward:

IfWinExist WinPcap [\d\.]+ Setup
{
    WinActivate
    BlockInput, On
    Sleep, 250
    WinActivate
    Send, {Enter}
    BlockInput, Off
}

return
