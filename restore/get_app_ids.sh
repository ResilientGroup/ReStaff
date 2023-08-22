# Small helper script that gets the app IDs of all servers in a specific Pterodactyl egg.
# This is not the server's UUID in the client API, but an internal app ID of the application API

# svr=${1}
# svr=8a7e5144
. .env

ALL_SERVERS=$(curl --location --request GET 'https://panel.reload.works/api/application/nests/1/eggs/31?include=servers' --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.id')

# get state of servers
for svr in $ALL_SERVERS; do
    echo $svr
done
