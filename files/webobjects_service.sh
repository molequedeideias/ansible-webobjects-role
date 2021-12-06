#!/bin/bash

# chkconfig: - 90 20
# description: Provides WebObjects services

# Source function library.
. /etc/rc.d/init.d/functions

NEXT_ROOT="/opt"
export NEXT_ROOT

USER=appserver

# See how we were called.
case "$1" in
    start)
        echo -n "Starting wotaskd and Monitor... "
        su $USER -c "$NEXT_ROOT/webobjects/tools/wotaskd.woa/wotaskd -Xmx256m -WOPort 1085 -WODeploymentConfigurationDirectory /opt/webobjects/config > /var/log/webobjects/wotaskd.log 2>&1 &"
        su $USER -c "$NEXT_ROOT/webobjects/tools/JavaMonitor.woa/JavaMonitor -Xmx256m -WOPort 56789 -WODeploymentConfigurationDirectory /opt/webobjects/config > /var/log/webobjects/JavaMonitor.log 2>&1 &"
        echo -e "\nYou can see the logs of each app running..."
        echo -e "  tail -f /var/log/webobjects/wotaskd.log"
        echo -e "  tail -f /var/log/webobjects/JavaMonitor.log\n"
        ;;
    stop)
        echo -n "Shutting down wotaskd and Monitor... "
        kill `ps aux | awk '/WOPort 1085/ && !/awk/ {print $2}'`
        kill `ps aux | awk '/WOPort 56789/ && !/awk/ {print $2}'`
        echo
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        echo -n "Usage: $0 {start|stop|restart}"
        exit 1
esac

if [ $# -gt 1 ]; then
    shift
    $0 $*
fi

exit 0
