# !/bin/bash

DIR=$HOME/Scripts/spotify
TMP_DIR=$DIR/tmp

access_token=$(sh $DIR/spotify_token.sh)

resp=$(curl -s -X GET \
	"https://api.spotify.com/v1/me/player/queue" \
	-H "Authorization: Bearer $access_token")


curr=$(echo $resp | jq '.currently_playing.album.images.[0].url' -r)

name=$(echo $curr | cut -d "/" -f 5)

curl "$curr" -s -o $TMP_DIR/$name.jpeg

sh -c "$DIR/spotify_set_bg.sh $name" &

images=$(echo $resp | jq '.queue.[].album.images.[].url ' -r)
limit=5

index=0

for image in $images; do
	name=$(echo $image | cut -d "/" -f 5)
	curl $image -s -o $TMP_DIR/$name.jpeg

	((index++))

	if [ $index -gt $limit ]; then
		break
	fi
done
