####################
## User Functions ##
####################

start_agent() {
    pgrep -f /usr/bin/ssh-agent | xargs kill &> /dev/null
    echo "Starting new SSH agent..."
    /usr/bin/ssh-agent > ${SSH_ENV}
    echo "succeeded..."
    chmod 600 ${SSH_ENV}
    . ${SSH_ENV} > /dev/null
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(..*\)/\1/'
}

parse_git_tag() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(..*\)/\1/' -e 's/.*at \(.*\))/\1/'
}

rb-create () {
    local fromCommit=$1
    local toCommit=$2
    local branch=`parse_git_branch`
    
    #echo $branch $fromCommit $toCommit
    rbt post --server rb.internal.casalemedia.com --branch $branch $fromCommit $toCommit
}

rb-update () {
    local reqID=$1
    local fromCommit=$2
    local toCommit=$3
    
    #echo $reqID $fromCommit $toCommit
    rbt post -u -r $reqID --server rb.internal.casalemedia.com $fromCommit $toCommit
}

# Find DC associated with a server
server-info() {
    if [ -z "$1" ]; then
        echo 'Must specify an argument';
        return 1;
    fi
    ssh db-dumper "mysql Viper2_dumper -t -e 'select hostName, ip, servers.status as serverStatus, name as dcName, pdcID, dcID, dataCenters.status as dcStatus, dcProfileServers.ascdbTarget from servers join dataCenters using (dcID) join dcProfileServers using (serverID) where hostName like \"$1.%\";'"
}

dc-info() {
    if [ -z "$1" ]; then
        echo 'Must specify an argument';
        return 1;
    fi
    ssh db-dumper "mysql Viper2_dumper -t -e 'select clusterID, type, name as dcName, pdcID, dcID, dataCenters.status as dcStatus from dcStorageClusters join dataCenters using (dcID) where dcID=$1;'"
}

sync-src() {
    local syncDir=$(readlink -f ${1:-.})
    local dest=docker-ws:/src/$(basename $syncDir)
    local defaultExclude=$(readlink -f ~/.rsyncignore)
    
    local cmd="rsync -Cavz $syncDir/ $dest/ --exclude-from=$defaultExclude --exclude-from=$syncDir/.rsyncignore --delete-before"
    
    echo "Do you want to sync $syncDir to $dest? [y/n]"
    read answer
    if [ $answer = "y" ]; then
        #echo $cmd
        eval $cmd
        return 0
    else
        echo "Aborting sync to docker-ws"
        return 1
    fi
}

sync-src-old() {
    local syncDir=$(readlink -f ${1:-.})
    local dest=docker-ws-old:/src/$(basename $syncDir)
    local defaultExclude=$(readlink -f ~/.rsyncignore)
    
    local cmd="rsync -Cavz $syncDir/ $dest/ --exclude-from=$defaultExclude --exclude-from=$syncDir/.rsyncignore --delete-before"
    
    echo "Do you want to sync $syncDir to $dest? [y/n]"
    read answer
    if [ $answer = "y" ]; then
        #echo $cmd
        eval $cmd
        return 0
    else
        echo "Aborting sync to docker-ws"
        return 1
    fi
}

sync-with-dockerVM() {
    local syncDir=$(readlink -f ${1:-.})
    
    if [ "$syncDir" = "/" ]; then
        echo "Not safe to sync on '/'"
        return 1
    fi
    
    local destDir=${2:-/tmp}
    echo $destDir
    local dest=docker-ws:$destDir
    
    if [ "$destDir" = "/" ]; then
        echo "Not safe to sync on '/'"
        return 1
    fi
    
    local defaultExclude=$(readlink -f ~/.rsyncignore)
    
    local cmd="rsync -Cavz $syncDir/ $dest/ --exclude-from=$defaultExclude --exclude-from=$syncDir/.rsyncignore --delete-before"
    
    echo "Do you want to sync $syncDir to $dest? [y/n]"
    read answer
    if [ $answer = "y" ]; then
        #echo $cmd
        eval $cmd
        return 0
    else
        echo "Aborting sync to docker-ws"
        return 1
    fi
}

sync-install() {
    sync-with-dockerVM '' $(readlink -f ${1:-.})
}
