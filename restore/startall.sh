# svr=${1}
svr=8a7e5144
. .env

ALL_SERVERS=$(curl --location --request GET https://panel.reload.works/api/application/nests/1/eggs/28?include=servers --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.uuid')

# start all servers
for svr in $ALL_SERVERS; do
    echo "starting $svr"
    curl --location --request POST https://panel.reload.works/api/client/servers/$svr/power --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' --data-raw '{"signal": "start"}'
done
