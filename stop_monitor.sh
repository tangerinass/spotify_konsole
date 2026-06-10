# !/bin/bash
DIR=$HOME/Scripts/spotify
TMP_DIR=$DIR/tmp

pid=$(cat $TMP_DIR/kill.pid)

kill -- $pid
