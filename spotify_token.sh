#!/bin/bash
DIR=$HOME/Scripts/spotify
TMP_DIR=$DIR/tmp

source $DIR/.env/VARS.sh

access_token_file=$TMP_DIR/access_token.txt
response_file=$TMP_DIR/response.html

curr_time=$(date +%_m_%_d_%_H)
last_time=$(date --date="$(head $access_token_file -n 1)" +%_m_%_d_%_H)

valid=0

for i in $(seq 3); do
     curr=$(echo $curr_time | cut -d "_" -f $i)
     last=$(echo $last_time | cut -d "_" -f $i)
    
     sub=$((curr - last))

     if [ $sub -eq 0 ] && [ $i -eq 3 ]; then
          valid=1
          break;
     fi

     if [ $sub -ne 0 ]; then
          break;
     fi
done
if [ $valid -eq 0 ]; then
    
     refresh=$(cat tmp/access_token.txt | tail -n 1 | cut -d '"' -f 2)
     curl -s -X POST "https://accounts.spotify.com/api/token" \
          -H "Content-Type: application/x-www-form-urlencoded" \
	     -H "Authorization: Basic $(echo -n "${CLIENT_ID_SPOTIFY}:${CLIENT_SECRET_SPOTIFY}" | openssl base64 -A)" \
          -d "grant_type=refresh_token" \
          -d "refresh_token=$refresh" \
          -o $response_file

     token=$(cat $response_file | jq .access_token)
     
     (date) > $access_token_file
     (echo $token) >> $access_token_file
     (echo $refresh) >> $access_token_file
fi

access_token=$(tail $access_token_file -n 2 | cut -d '"' -f 2)

echo $access_token
