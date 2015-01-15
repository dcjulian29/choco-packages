$packageName = "git-myconfiguration"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path "$env:ProgramFiles\Git") {
        $git = "$env:ProgramFiles\Git\bin\git.exe"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\Git") {
        $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
    }

    ##### Core Settings
    & $git config --global user.name "Julian Easterling"
    & $git config --global core.autocrlf "true"
    & $git config --global core.safecrlf "false"
    & $git config --global core.filemode "false"
    & $git config --global push.default "upstream"
    & $git config --global help.format "html"

    ##### Command Aliases
    & $git config --global alias.rc "rebase --continue"
    & $git config --global alias.ra "rebase --abort"
    & $git config --global alias.amend "commit --amend"
    & $git config --global alias.bl "blame -w -M -C"
    & $git config --global alias.lastref "rev-parse --short HEAD"
    & $git config --global alias.lasttag "describe --tags --abbrev=0"
    & $git config --global alias.undo "reset head~"
	& $git config --global alias.unstage "reset HEAD"
	& $git config --global alias.discard "reset HEAD --hard"
	& $git config --global alias.ci "commit"
	& $git config --global alias.co "checkout"
	& $git config --global alias.br "branch"
	& $git config --global alias.st "status -sb"
	& $git config --global alias.ls "ls-files"
    & $git config --global alias.ignored "ls-files --others --exclude-standard --ignored"
	& $git config --global alias.df "diff"
	& $git config --global alias.dc "diff --cached"
    & $git config --global alias.changes "diff --stat -r"
    & $git config --global alias.sync "!git pull && git push"

    ##### Log Related Aliases
    & $git config --global alias.ld "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --date=relative"
	& $git config --global alias.la "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an)%Creset' --date=short"
	& $git config --global alias.lqd "log --pretty=format:'%Cred%h%Creset %Cgreen(%cr)%Creset %s' --date=short"
	& $git config --global alias.lqa "log --pretty=format:'%Cred%h%Creset %Cgreen(%an)%Creset %s'"
	& $git config --global alias.lall "log -p"
	& $git config --global alias.oneline "log --pretty=oneline"
    & $git config --global alias.standup "!git log --since yesterday --author ``git config user.email`` --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --date=relative"
    & $git config --global alias.lastcommit "log --max-count=1"
    & $git config --global alias.who "shortlog -s -e --"

    ##### Git Flow Aliases
    & $git config --global alias.gffs "flow feature start"
    & $git config --global alias.gfff "flow feature finish"
    & $git config --global alias.gfrs "flow release start"
    & $git config --global alias.gfrf "flow release finish"

    ##### Colorization
    & $git config --global color.ui "true"
    & $git config --global color.branch "auto"
    & $git config --global color.diff "auto"
    & $git config --global color.status "auto"

    & $git config --global color.branch.current "cyan"
    & $git config --global color.branch.local "yellow"
    & $git config --global color.branch.remote "magenta"

    & $git config --global color.diff.meta "yellow bold"
    & $git config --global color.diff.frag "magenta bold"
    & $git config --global color.diff.old "red bold"
    & $git config --global color.diff.new "green bold"
    & $git config --global color.diff.whitespace "red reverse"

    & $git config --global color.status.added "green"
    & $git config --global color.status.changed "red"
    & $git config --global color.status.untracked "cyan"

    ##### Diff/Merge Tools
    & $git config --global diff.renamelimit "0"
    & $git config --global diff.tool "kdiff3"
    & $git config --global merge.tool "kdiff3"
    & $git config --global difftool.prompt "false"
    & $git config --global mergetool.prompt "false"

    & $git config --global difftool.kdiff3.path "C:/tools/apps/kdiff/kdiff3.exe"
    & $git config --global difftool.kdiff3.cmd "C:/tools/apps/kdiff/kdiff3.exe '${$}LOCAL' '${$}REMOTE'"
    & $git config --global difftool.kdiff3.keepBackup "false"
    & $git config --global difftool.kdiff3.trustExitCode "false"

    & $git config --global mergetool.kdiff3.path "C:/tools/apps/kdiff/kdiff3.exe"
    & $git config --global mergetool.kdiff3.keepBackup "false"
    & $git config --global mergetool.kdiff3.trustExitCode "false"

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
