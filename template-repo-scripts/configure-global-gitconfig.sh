# !/bin/sh

# core
git config --global core.autocrlf input
git config --global core.editor "code --wait"

# diff
git config --global --type bool diff.mnemonicPrefix true
git config --global --type bool diff.renames true
git config --global diff.tool code
git config --global difftool.code.cmd "code --wait --diff \$LOCAL \$REMOTE"

# fetch
git config --global --type bool fetch.prune true
git config --global fetch.recurseSubmodules on-demand

# init
git config --global init.defaultBranch main

# log
git config --global --type bool log.abbrevCommit true
git config --global --type bool log.follow true

# merge
git config --global merge.tool code
git config --global mergetool.code.cmd "code --wait --merge \$LOCAL \$REMOTE \$BASE \$MERGED"
git config --global --type bool mergetool.code.keepBackup false
git config --global --type bool mergetool.code.keepTemporaries false

# rebase
git config --global --type bool rebase.updateRefs true

# safe
git config --global --add safe.directory '*'

# status
git config --global --type bool status.submoduleSummary true

# tag
git config --global tag.sort -version:refname

# versionsort
git config --global --replace-all versionsort.prereleaseSuffix "-beta"
git config --global --add versionsort.prereleaseSuffix "-pre"
git config --global --add versionsort.prereleaseSuffix "-rc"
git config --global --add versionsort.prereleaseSuffix ".beta"
git config --global --add versionsort.prereleaseSuffix ".pre"
git config --global --add versionsort.prereleaseSuffix ".rc"

# alias
git config --global alias.aliases "!git config --get-regexp alias | sed -re 's/alias\\.(\\S*)\\s(.*)$/\\1 = \\2/g'"
git config --global alias.branches 'branch -a'
git config --global alias.delete-local-merged "!git fetch && git branch --merged | egrep -v 'main' | xargs git branch -d"
git config --global alias.logg 'log --graph --decorate --oneline --date=relative --all'
git config --global alias.remotes 'remote -v'
git config --global alias.review-local '!git logg @{push}..'
git config --global alias.tags 'tag -l'
git config --global alias.uncommit 'reset --soft HEAD~1'
git config --global alias.untrack 'rm --cache --'
