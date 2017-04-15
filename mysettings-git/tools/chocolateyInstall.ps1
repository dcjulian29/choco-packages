$packageName = "git-myconfiguration"

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
& $git config --global branch.autosetuprebase "always"

##### Command Aliases
& $git config --global --replace-all alias.rc "rebase --continue"
& $git config --global --replace-all alias.ra "rebase --abort"
& $git config --global --replace-all alias.amend "commit --amend"
& $git config --global --replace-all alias.bl "blame -w -M -C"
& $git config --global --replace-all alias.lastref "rev-parse --short HEAD"
& $git config --global --replace-all alias.lasttag "describe --tags --abbrev=0"
& $git config --global --replace-all alias.undo "reset head~"
& $git config --global --replace-all alias.unstage "reset HEAD"
& $git config --global --replace-all alias.discard "reset HEAD --hard"
& $git config --global --replace-all alias.ci "commit"
& $git config --global --replace-all alias.co "checkout"
& $git config --global --replace-all alias.br "branch"
& $git config --global --replace-all alias.st "status -sb"
& $git config --global --replace-all alias.ls "ls-files"
& $git config --global --replace-all alias.ignored "ls-files --others --exclude-standard --ignored"
& $git config --global --replace-all alias.df "diff"
& $git config --global --replace-all alias.dc "diff --cached"
& $git config --global --replace-all alias.changes "diff --stat -r"
& $git config --global --replace-all alias.sync "!git pull && git push"
& $git config --global --replace-all alias.incoming "!git remote update -p; git whatchanged ..@{u}"
& $git config --global --replace-all alias.outgoing "whatchanged ..@{u}"
& $git config --global --replace-all alias.visual "!gitk"
& $git config --global --replace-all alias.packageid "rev-parse --short=12 HEAD"
& $git config --global --replace-all alias.release "!f() { git log $1..$2 --pretty=format:""%s"" --no-merges; }; f"
& $git config --global --replace-all alias.open "!explorer ``git config remote.origin.url``"
& $git config --global --replace-all alias.browse "!git open"
& $git config --global --replace-all alias.aliases "!git config --get-regexp 'alias.*' | sort"
& $git config --global --replace-all alias.topic-start "'!branch=`$1; git pull; git checkout -b ""`$branch""; git push -u origin ""`$branch""'"
& $git config --global --replace-all alias.cm "commit --message"
& $git config --global --replace-all alias.cleanest "clean -ffdx"
& $git config --global --replace-all alias.refs-by-date "for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname:short)'"
& $git config --global --replace-all alias.orphans "fsck --full"
& $git config --global --replace-all alias.whorank "shortlog --summary --numbered --no-merges"
& $git config --global --replace-all alias.undo-commit "reset --soft HEAD~1"
& $git config --global --replace-all alias.root "rev-parse --show-toplevel"
& $git config --global --replace-all alias.prune-all "!""git prune --expire=now; git reflog expire --expire-unreachable=now --rewrite --all"""
& $git config --global --replace-all alias.repack-all "repack -a -d -f --depth=300 --window=300 --window-memory=1g"
& $git config --global --replace-all alias.optimize "!""git prune-all; git repack-all"""
& $git config --global --replace-all alias.clean-merged "!git remote | xargs -n 1 git remote prune"

##### Log Related Aliases
& $git config --global --replace-all alias.ld "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --date=relative"
& $git config --global --replace-all alias.la "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an)%Creset' --date=short"
& $git config --global --replace-all alias.lqd "log --pretty=format:'%Cred%h%Creset %Cgreen(%cr)%Creset %s' --date=short"
& $git config --global --replace-all alias.lqa "log --pretty=format:'%Cred%h%Creset %Cgreen(%an)%Creset %s'"
& $git config --global --replace-all alias.lall "log -p"
& $git config --global --replace-all alias.oneline "log --pretty=oneline"
& $git config --global --replace-all alias.standup "!git log --since yesterday --author ``git config user.email`` --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --date=relative"
& $git config --global --replace-all alias.lastcommit "log --max-count=1"
& $git config --global --replace-all alias.who "shortlog -s -e --"
& $git config --global --replace-all alias.log-refs "log --all --graph --decorate --oneline --simplify-by-decoration --no-merges"
& $git config --global --replace-all alias.log-fetched "log --oneline HEAD..origin/master"
    
##### Git Flow Aliases
& $git config --global --replace-all alias.gffs "flow feature start"
& $git config --global --replace-all alias.gfff "flow feature finish"
& $git config --global --replace-all alias.gfrs "flow release start"
& $git config --global --replace-all alias.gfrf "flow release finish"
& $git config --global gitflow.feature.finish.no-ff "true"

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

& $git config --global difftool.kdiff3.path "C:/Program Files/KDiff3/kdiff3.exe"
& $git config --global difftool.kdiff3.keepBackup "false"
& $git config --global difftool.kdiff3.trustExitCode "false"

& $git config --global mergetool.kdiff3.path "C:/Program Files/KDiff3/kdiff3.exe"
& $git config --global mergetool.kdiff3.keepBackup "false"
& $git config --global mergetool.kdiff3.trustExitCode "false"
