##################
## User Aliases ##
##################

# Maintenance
alias crc='vim ~/.bashrc'
alias cenv='vim ~/.env'
alias calias='vim ~/.bash_aliases'
alias cfunctions='vim ~/.bash_functions'
alias rlrc='. ~/.bashrc'

alias update-now='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

alias hosts='sudo vim /etc/hosts'
alias ssh-hosts='vim ~/.ssh/config'

# Goto
alias win='cd $WIN_HOME'
alias work='cd "$SRC_DIR"'
alias plfm-go='cd $PLATFORM_GO_SRC_DIR'
alias plfm='cd $SRC_PLAT'
alias plfm-test='cd /install/platform-test'

# My remote drives aliases
alias mount-samba-drive='sudo mount -t cifs -o credentials=~/.smbcredentials,rw,nosetuids,noperm'
alias umount-samba-drive='sudo umount'
alias mount-backup='mount-samba-drive //10.4.0.10/eusebio.olalde /mnt/backup'
alias umount-backup='umount-samba-drive /mnt/backup'
alias mount-BETest='mount-samba-drive //10.4.0.10/betest ~/betest'
alias umount-BETest='umount-samba-drive ~/betest'

# Sync aliases
alias sync-install-ignore='vim /install/.rsyncignore'
alias docker-sync='rsync -Cavz $SRC_DIR/docker.git/. docker-ws:/src/docker.git --exclude-from=$SRC_DIR/.rsyncignore --delete-before'

# Archimides
alias latest-tag-as="curl -s 'https://archimedes.indexexchange.com:9666/components?component=AS' | python -c 'import json, sys, re; print (json.load(sys.stdin)[0][\"newest\"][\"tag\"])'"

# Git
alias git-log='git log --pretty=format:"[%h] %ae, %ar: %s" --stat'
alias reset-branch='git fetch --all && git reset --hard origin/$(parse_git_branch) && git pull'
alias prune-branches='git fetch --all --prune && git branch -vv | grep ": gone]" | awk "{print \$1}" | xargs git branch -D'

# Docker aliases
alias rmdi='docker images -q -f "dangling=true" | xargs docker rmi'
alias rmec='docker ps -a -q -f "status=exited"  | xargs docker rm'
alias rmdv='docker volume ls -qf dangling=true  | xargs -r docker volume rm'
alias dex='docker exec -it'
alias dcw='docker-compose -f workstation.yaml'
alias dcp='docker-compose -f production.yaml'

