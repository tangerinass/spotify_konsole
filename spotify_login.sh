# !/bin/bash
source $(dirname "$0")/common.sh

source $DIR/.env/VARS.sh

access_token_file=$TMP_DIR/access_token.txt
response_file=$TMP_DIR/response.html

uri="http://127.0.0.1:8888/callback"

scope="playlist-read-private%20playlist-read-collaborative%20user-read-private%20user-read-email%20user-read-currently-playing%20user-read-playback-state"

url="https://accounts.spotify.com/authorize?response_type=code&client_id=$CLIENT_ID_SPOTIFY&redirect_uri=$uri&show_dialog=true&scope=$scope"

firefox "$url" &

http_request=$(nc -l -p 8888 | head -n 1)


code=$(echo $http_request | cut -d "=" -f 2 | cut -d " " -f 1)
curl -s -X POST "https://accounts.spotify.com/api/token" \
	-H "Content-Type: application/x-www-form-urlencoded" \
	-H "Authorization: Basic $(echo -n "${CLIENT_ID_SPOTIFY}:${CLIENT_SECRET_SPOTIFY}" | openssl base64 -A)" \
	-d "grant_type=authorization_code" \
	-d "redirect_uri=$uri" \
	-d "code=$code" \
	-o $response_file

token=$(cat $response_file | jq .access_token)
refresh=$(cat $response_file | jq .refresh_token)

(date) > $access_token_file
(echo $token) >> $access_token_file
(echo $refresh) >> $access_token_file
