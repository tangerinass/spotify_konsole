# !/bin/bash
source $(dirname "$0")/common.sh

sh $DIR/monitor_dbus.sh > /dev/null &
