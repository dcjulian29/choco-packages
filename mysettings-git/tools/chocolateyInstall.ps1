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
& $git config --global --replace-all alias.assume "update-index --assume-unchanged"
& $git config --global --replace-all alias.assumed "!git ls-files -v | grep ^h | cut -c 3-"
& $git config --global --replace-all alias.aliases "!git config --get-regexp 'alias.*' | sort"
& $git config --global --replace-all alias.amend "commit --amend"
& $git config --global --replace-all alias.bl "blame -w -M -C"
& $git config --global --replace-all alias.branches "branch -a"
& $git config --global --replace-all alias.br "branch"
& $git config --global --replace-all alias.changes "diff --stat -r"
& $git config --global --replace-all alias.ci "commit"
& $git config --global --replace-all alias.clean "clean -ffdx"
& $git config --global --replace-all alias.cm "commit --message"
& $git config --global --replace-all alias.co "checkout"
& $git config --global --replace-all alias.cob "checkout -b"
& $git config --global --replace-all alias.dc "diff --cached"
& $git config --global --replace-all alias.df "diff"
& $git config --global --replace-all alias.discard "reset HEAD --hard"
& $git config --global --replace-all alias.ignored "ls-files --others --exclude-standard --ignored"
& $git config --global --replace-all alias.incoming "!git remote update -p; git whatchanged ..@{u}"
& $git config --global --replace-all alias.lasttag "describe --tags --abbrev=0"
& $git config --global --replace-all alias.lastref "rev-parse --short HEAD"
& $git config --global --replace-all alias.nuke "!git reset --hard HEAD && git clean -d -f"
& $git config --global --replace-all alias.open "!start ``git config remote.origin.url``"
& $git config --global --replace-all alias.optimize "!""git orphans; git prune-all; git repack-all"""
& $git config --global --replace-all alias.orphans "fsck --full"
& $git config --global --replace-all alias.outgoing "whatchanged ..@{u}"
& $git config --global --replace-all alias.p "push"
& $git config --global --replace-all alias.packageid "rev-parse --short=12 HEAD"
& $git config --global --replace-all alias.prune-all "!""git prune --expire=now; git reflog expire --expire-unreachable=now --rewrite --all"""
& $git config --global --replace-all alias.prune-merged "!""git fetch -p; git branch -vv | grep ': gone]' | gawk '{print `$1}' | xargs git branch -D"""
& $git config --global --replace-all alias.repack-all "repack -a -d -f --depth=300 --window=300 --window-memory=1g"
& $git config --global --replace-all alias.refs-by-date "for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname:short)'"
& $git config --global --replace-all alias.release-notes "!f() { git log $1..$2 --pretty=format:""%s"" --no-merges; }; f"
& $git config --global --replace-all alias.root "rev-parse --show-toplevel"
& $git config --global --replace-all alias.stashes "stash list"
& $git config --global --replace-all alias.sync "!git pull && git push"
& $git config --global --replace-all alias.summary "status -u -s"
& $git config --global --replace-all alias.tags "tag"
& $git config --global --replace-all alias.topic-start "!f() { git up; git cob `$1; git push -u origin `$1;}; f"
& $git config --global --replace-all alias.undo-commit "reset --soft HEAD~1"
& $git config --global --replace-all alias.assumed "!git ls-files -v | grep ^h | cut -c 3-"
& $git config --global --replace-all alias.up "!git pull --rebase --prune $@ && git submodule update --init --recursive"
& $git config --global --replace-all alias.visual "!gitk"

##### Log Related Aliases
& $git config --global --replace-all alias.la "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an)%Creset' --date=short"
& $git config --global --replace-all alias.lastcommit "log --max-count=1"
& $git config --global --replace-all alias.ld "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --date=relative"
& $git config --global --replace-all alias.lqa "log --pretty=format:'%Cred%h%Creset %Cgreen(%an)%Creset %s'"
& $git config --global --replace-all alias.lqd "log --pretty=format:'%Cred%h%Creset %Cgreen(%cr)%Creset %s' --date=short"
& $git config --global --replace-all alias.standup "!git log --since yesterday --author ``git config user.email`` --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --date=relative"
& $git config --global --replace-all alias.who "shortlog -s -e --"
& $git config --global --replace-all alias.whorank "shortlog --summary --numbered --no-merges"
    
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
