# Spotify_konsole
A bundle of methods to be able to see lyrics, change songs and playlists, and the bg of your konsole, using spotify's REST api and dbus.

Your credentials need to be stores in a .env with the spotify client_id (CLIENT_SECRET_SPOTIFY) and client_secret (CLIENT_SECRET_SPOTIFY).

`
CLIENT_ID_SPOTIFY="foo"
`

`
CLIENT_SECRET_SPOTIFY="bar"
`


Change the $DIR variable inside the _ file so it matches the place where you intend to keep the code.

## Setting up

1. To set up you need to first run the spotify_login.  The script will open a page in your firefox browser where youll have to confirm that you accept letting this app have acess to a certain scope of permissions.

2.  Copy the spotify_konsole, start_monitor, and stop_monitor onto /usr/local/bin so that u can run the command from anywhere
