# svr=${1}
# svr=8a7e5144
. .env

EGG=31

ALL_SERVERS=$(curl --location --request GET 'https://panel.reload.works/api/application/nests/1/eggs/'${EGG}'?include=servers' --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.uuid')

# get state of servers
for svr in $ALL_SERVERS; do
    SERVER_NAME=$(curl -s --location --request GET https://panel.reload.works/api/client/servers/$svr --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.name')
    CURRENT_STATE=$(curl -s --location --request GET https://panel.reload.works/api/client/servers/$svr/resources --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.current_state')
    if [[ "$CURRENT_STATE" = "running" ]]; then
        echo "$svr - $SERVER_NAME: $CURRENT_STATE"
    fi
done
