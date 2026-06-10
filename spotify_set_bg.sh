# !/bin/bash
source $(dirname "$0")/common.sh

profile="Custom3"

image=$( ls $TMP_DIR | grep $1 )

cp $TMP_DIR/$image $TMP_DIR/bg_image.jpeg

# listar todas as sessoes com "custom3" e dar refresh a essas sessoes
sessions=$(qdbus $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_WINDOW sessionList)
session_num=$(qdbus $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_WINDOW sessionCount)

index=1

done=0

for session in $sessions; do
	qdbus $KONSOLE_DBUS_SERVICE /Sessions/$session setProfile Default >> /dev/null
done

for session in $sessions; do
	qdbus $KONSOLE_DBUS_SERVICE /Sessions/$session setProfile $profile >> /dev/null
done
