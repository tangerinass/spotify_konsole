# !/bin/bash
source $(dirname "$0")/common.sh

profile="Custom3"
access_token=$(sh $DIR/spotify_token.sh)
args=$*


case "$1" in

    "-ps")
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause > /dev/null
        exit 0
        ;;

    "-next")
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next > /dev/null
        exit 0
        ;;

    "-prev")
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous > /dev/null
        exit 0
        ;;


    "-r"|"refresh")
        sh $DIR/spotify_bg.sh
        exit 0
        ;;

    "-lyrics"|"-l")
        artist=$(qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata \
            | grep artist \
            | cut -d ":" -f 3- | cut -b 1 --complement \
            | jq -sRr @uri)

        title=$(qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata \
            | grep title \
            | cut -d ":" -f 3- | cut -b 1 --complement \
            | jq -sRr @uri)

        resp=$(\
            curl -s -X GET \
            "https://api.lyrics.ovh/v1/$artist/$title" \
            -H "Content-Type: application/json")

        lyrics=$( echo $resp | jq .lyrics)
        printf "$lyrics\n"
        exit 0
        ;;

    "-list")
        resp=$(curl -s -X GET \
            "https://api.spotify.com/v1/me/playlists" \
            -H "Authorization: Bearer $access_token")
        
        echo $resp | jq ".items.[] | .name"

        exit 0
        ;;

    "-start")
        name=$(echo -n $args | cut -d " " -f 1 --complement)

        resp=$(curl -s -X GET \
            "https://api.spotify.com/v1/me/playlists" \
            -H "Authorization: Bearer $access_token")

        id=$(echo $resp | jq '.items.[] | select(.name|test("'$name'")) | .id' -r)
        
        uri="spotify:playlist:$id"
        
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop > /dev/null
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri $uri > /dev/null
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play > /dev/null
        exit 0
        ;;
esac

track=$(echo -n $args | jq -sRr @uri)

resp=$(\
    curl -s -X GET \
    "https://api.spotify.com/v1/search?q=$track&type=track&limit=1" \
    -H "Authorization: Bearer $access_token")

uri=$(echo $resp | jq .tracks.items.[0].uri)


qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop > /dev/null
qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri $uri > /dev/null
qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play > /dev/null
