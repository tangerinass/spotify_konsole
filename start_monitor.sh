# !/bin/bash
DIR=$HOME/Scripts/spotify
TMP_DIR=$DIR/tmp

sh $DIR/monitor_dbus.sh > /dev/null &
