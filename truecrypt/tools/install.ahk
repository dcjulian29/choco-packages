#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, RegEx

; Uninstall any previous versions...
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")
truecryptUninstaller = %A_ProgramFiles%\TrueCrypt\TrueCrypt Setup.exe
truecryptUninstallerx86 = %ProgramFilesX86%\TrueCrypt\TrueCrypt Setup.exe

IfExist, %truecryptUninstaller%
{
    Sleep, 1000
	Run, "%truecryptUninstaller%" /u
	installed = 1
}

IfExist, %truecryptUninstallerx86%
{
    Sleep, 1000
	Run, "%truecryptUninstallerx86%" /u
	installed = 1
}

if (installed = 1)
{
	WinWait, TrueCrypt Setup,, 30
	IfWinExist
	{
		BlockInput, On
		Sleep, 250
		WinActivate
		Send, {ALTDOWN}r{ALTUP}{ALTDOWN}u{ALTUP}
		BlockInput, Off
	}

    WinWaitActive, TrueCrypt Setup, successfully uninstalled, 30
    IfWinExist 
    {
        BlockInput, On
        Sleep, 250
        WinActivate
        Send, {Enter}
		Sleep, 250
		Send, {ENTER}
        BlockInput, Off
    }
}

; Install
truecryptInstaller = %A_Temp%\chocolatey\truecrypt\truecryptInstall.exe
Sleep, 1000
Run, %truecryptInstaller%

WinWait, TrueCrypt Setup [\d\.\w]+,, 30

IfWinExist TrueCrypt Setup [\d\.\w]+
{
    WinActivate
    BlockInput, On
    Sleep, 250
    WinActivate
    Send, {ALTDOWN}a{ALTUP}{ALTDOWN}n{ALTUP}
    Sleep, 250
    Send, {ALTDOWN}n{ALTUP}
    Sleep, 250
    Send, {ALTDOWN}r{ALTUP}{ALTDOWN}i{ALTUP}
    BlockInput, Off
}

WinWaitActive, TrueCrypt Setup$,, 30
IfWinExist 
{
    BlockInput, On
    Sleep, 250
    WinActivate
    Send, {Enter}
    BlockInput, Off
}

WinWaitActive, TrueCrypt Setup [\d\.\w]+,, 30
IfWinExist 
{
    BlockInput, On
    Sleep, 250
    WinActivate
    Send, {ALTDOWN}f{ALTUP}
    BlockInput, Off
}

WinWaitActive, TrueCrypt Setup$,, 30
IfWinExist 
{
    BlockInput, On
    Sleep, 250
    WinActivate
    Send, {ALTDOWN}n{ALTUP}
    BlockInput, Off
}
