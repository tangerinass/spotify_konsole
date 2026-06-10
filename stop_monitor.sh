# !/bin/bash
source $(dirname "$0")/common.sh

echo $TMP_DIR
pid=$(cat $TMP_DIR/kill.pid)

kill -- $pid
