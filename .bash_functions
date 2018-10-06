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

