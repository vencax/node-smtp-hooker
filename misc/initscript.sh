#!/bin/sh -e

### BEGIN INIT INFO
# Provides:          smtp-hooker
# Short-Description: SMTP incomming server with hooks
### END INIT INFO

. /lib/lsb/init-functions

test $DEBIAN_SCRIPT_DEBUG && set -v -x

NAME=smtp-hooker
PIDFILE=/var/run/$NAME.pid
DESC="SMTP incomming server with hooks"


start () {
  STATUS=0
  # Check to see if it's already started...
  if test -e $PIDFILE ; then
    log_failure_msg "Already running (PID file exists)"
  else
    forever start --pidFile $PIDFILE -l /var/log/$NAME.log -a -m 1 --uid "$NAME" -c $NODE_PATH/node-smtp-hooker/main.js
  fi
  log_end_msg $STATUS
}
stop () {
  forever stop "$NAME"
  log_end_msg 0
}

case "$1" in
start)
  log_action_begin_msg "Starting $NAME"

  start
  exit ${STATUS:-0}
  ;;
stop)
  log_action_begin_msg "Stopping $NAME"
  stop
  ;;
# Only 'reload'
reload|force-reload)
  log_action_begin_msg "Reloading $NAME"
  kill -s USR1 `cat $PIDFILE`
  ;;
restart)
  stop
  start
  ;;
status)
  if test -e $PIDFILE ; then
    log_failure_msg "$NAME running (PID = `cat $PIDFILE`)"
  else
    log_failure_msg "$NAME stopped"
  fi
  ;;
*)
  echo "Usage: $0 {start|stop|reload|restart|status}" >&2
  exit 1
  ;;
esac

exit 0

# vim:set ai sts=2 sw=2 tw=0: