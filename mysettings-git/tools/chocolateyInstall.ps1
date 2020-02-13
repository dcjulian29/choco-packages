if (Test-Path "$env:ProgramFiles\Git") {
    $git = "$env:ProgramFiles\Git\bin\git.exe"
}

if (Test-Path "${env:ProgramFiles(x86)}\Git") {
    $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
}

$config = @{
##### Core Settings
    "user.name" = "Julian Easterling"

    "core.autocrlf" = "true"
    "core.excludesfile" = "~/.gitignore"
    "core.safecrlf" = "false"
    "core.filemode" = "false"
    "core.editor" = "\""C:/Program Files/notepad++/notepad++.exe\"" -multiInst -nosession"

    "push.default" = "upstream"
    "help.format" = "html"
    "branch.autosetuprebase" = "always"
    "pull.rebase" = "true"
    "fetch.prune" = "true"
    "rebase.autoStash" = "false"
    "i18n.filesEncoding" = "us-ascii"

##### Command Aliases
    "alias.a" = "add"
    "alias.assume" = "update-index --assume-unchanged"
    "alias.assumed" = "!git ls-files -v | grep ^h | cut -c 3-"
    "alias.aliases" = "!git config --get-regexp 'alias.*' | sort"
    "alias.amend" = "commit --amend"
    "alias.bl" = "blame -w -M -C"
    "alias.branches" = "branch -a"
    "alias.br" = "branch"
    "alias.c" = "commit"
    "alias.ca" = "commit --amend -C HEAD"
    "alias.changed" = "status -sb"
    "alias.changes" = "diff --stat -r"
    "alias.ci" = "commit"
    "alias.clean" = "clean -ffdx"
    "alias.cm" = "commit --message"
    "alias.co" = "checkout"
    "alias.cob" = "checkout -b"
    "alias.d" = "diff"
    "alias.dc" = "diff --cached"
    "alias.df" = "diff"
    "alias.discard" = "reset HEAD --hard"
    "alias.f" = "fetch"
    "alias.ignored" = "ls-files --others --exclude-standard --ignored"
    "alias.incoming" = "!git remote update -p; git whatchanged ..@{u}"
    "alias.lasttag" = "describe --tags --abbrev=0"
    "alias.lastref" = "rev-parse --short HEAD"
    "alias.nuke" = "!git reset --hard HEAD && git clean -d -f"
    "alias.open" = "!start ``git config remote.origin.url``"
    "alias.optimize" = "!""git orphans; git prune-all; git repack-all"""
    "alias.orphans" = "fsck --full"
    "alias.outgoing" = "whatchanged ..@{u}"
    "alias.p" = "push"
    "alias.pp" = "!git pull && git push"
    "alias.packageid" = "rev-parse --short=12 HEAD"
    "alias.prune" = "fetch --prune"
    "alias.prune-all" = "!""git prune --expire=now; git reflog expire --expire-unreachable=now --rewrite --all"""
    "alias.prune-merged" = "!""git fetch -p; git branch -vv | grep ': gone]' | gawk '{print `$1}' | xargs git branch -D"""
    "alias.remotes" = "remote -v show"
    "alias.repack-all" = "repack -a -d -f --depth=300 --window=300 --window-memory=1g"
    "alias.refs-by-date" = "for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname:short)'"
    "alias.release-notes" = "!f() { git log `$1..`$2 --pretty=format:""%s"" --no-merges; }; f"
    "alias.root" = "rev-parse --show-toplevel"
    "alias.s" = "status"
    "alias.st" = "status"
    "alias.stats" = "diff --stat"
    "alias.stashes" = "stash list"
    "alias.sync" = "!git pull && git push"
    "alias.summary" = "status -u -s"
    "alias.tags" = "tag"
    "alias.topic-start" = "!f() { git up; git cob `$1; git push -u origin `$1;}; f"
    "alias.undo-commit" = "reset --soft HEAD~1"
    "alias.unstage" = "reset HEAD --"
    "alias.up" = "!git pull --rebase --prune $@ && git submodule update --init --recursive"
    "alias.visual" = "!gitk"
    "alias.wdiff" = "diff --word-diff"

##### Log Related Aliases
    "alias.last" = "log -1 HEAD"
    "alias.lastcommit" = "log --max-count=1"
    "alias.lq" = "log --pretty=format:'%Cred%h%Creset %s'"
    "alias.lqa" = "log --pretty=format:'%Cred%h%Creset %Cgreen(%an)%Creset %s'"
    "alias.lqd" = "log --pretty=format:'%Cred%h%Creset %Cgreen(%cr)%Creset %s' --date=short"
    "alias.standup" = "!git log --since yesterday --author ``git config user.email`` --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --date=relative"
    "alias.who" = "shortlog -s -e --"
    "alias.whorank" = "shortlog --summary --numbered --no-merges"
    "alias.plog" = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s' --abbrev-commit --date=relative --branches"
    "alias.ploa" = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an)%Creset' --date=short --branches"
    "alias.plod" = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --date=relative --branches"
    "today" = "log --stat --since='1 day ago' --graph --pretty=oneline --abbrev-commit --date=relative"

##### Git Flow Aliases and Settings
    "alias.gffs" = "flow feature start"
    "alias.gfff" = "flow feature finish"
    "alias.gfrs" = "flow release start"
    "alias.gfrf" = "flow release finish"

    "gitflow.feature.finish.no-ff" = "true"

##### Colorization
    "color.ui" = "true"
    "color.branch" = "auto"
    "color.diff" = "auto"
    "color.status" = "auto"

    "color.branch.current" = "cyan"
    "color.branch.local" = "yellow"
    "color.branch.remote" = "magenta"

    "color.diff.meta" = "yellow bold"
    "color.diff.frag" = "magenta bold"
    "color.diff.old" = "red bold"
    "color.diff.new" = "green bold"
    "color.diff.whitespace" = "red reverse"

    "color.status.added" = "green"
    "color.status.changed" = "red"
    "color.status.untracked" = "cyan"

##### Diff Settings
    "mergetool.prompt" = "false"
    "mergetool.keepBackup" = "false"
    "mergetool.keepTemporaries" = "false"

    "merge.tool" = "winmerge"

    "mergetool.winmerge.name" = "WinMerge"
    "mergetool.winmerge.trustExitCode" = "true"
    "mergetool.winmerge.cmd" = "\""C:/Program Files/WinMerge/winmergeu.exe\"" -e -u  -wl -wr -fm -dl \""Mine: `$LOCAL\"" -dm \""Merged: `$BASE\"" -dr \""Theirs: `$REMOTE\"" \""`$LOCAL\"" \""`$BASE\"" \""`$REMOTE\"" -o \""`$MERGED\"""
    "mergetool.winmerge.path" = "C:/Program Files/WinMerge/winmergeu.exe"

    "diff.tool" = "winmerge"
    "diff.guitool" = "winmerge"

    "difftool.winmerge.name" = "WinMerge"
    "difftool.winmerge.trustexitcode" = "true"
    "difftool.winmerge.cmd" = "\""C:/Program Files/WinMerge/winmergeu.exe\"" -e -u \""`$LOCAL\"" \""`$REMOTE\"""
    "difftool.winmerge.path" = "C:/Program Files/WinMerge/winmergeu.exe"
}

$config.Keys | ForEach-Object {
    Write-Verbose "$_ = $($config[$_])"
    & $git config --global --replace-all $_ $config[$_]
}
