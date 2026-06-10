# !/bin/bash
source $(dirname "$0")/common.sh

res=$(pgrep spotify)
if [[ "$res" == "" ]]; then
	echo "Spotify not running"
	exit 1
fi

dbus-monitor --profile --session "type=signal, sender=org.mpris.MediaPlayer2.spotify, member=PropertiesChanged" |
while read line; do
	image=$(qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | grep artUrl | cut -d " " -f 1 --complement)

	if [[ -z "$DBUS_PID" ]]; then
		DBUS_PID=$(pgrep -P $$ -x dbus-monitor)
		echo $DBUS_PID > $TMP_DIR/kill.pid 
	fi
	res=$(ls $TMP_DIR | grep $(echo $image | cut -d "/" -f 5))

	if [[ "$res" != "" ]]; then
		sh -c "$DIR/spotify_set_bg.sh $res"
	else
		rm $TMP_DIR/*.jpeg -f
		sh $DIR/spotify_prep_images.sh
	fi
	done
