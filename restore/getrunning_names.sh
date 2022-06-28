# svr=${1}
# svr=8a7e5144
. .env

# ALL_SERVERS=$(curl --location --request GET 'https://panel.reload.works/api/application/nests/1/eggs/15?include=servers' --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.uuid')

ALL_SERVERS=$(cat running_servers.txt)

# start all servers
for svr in $ALL_SERVERS; do
    SERVER_NAME=$(curl --location --request GET https://panel.reload.works/api/client/servers/$svr --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.name')
    echo "$SERVER_NAME" >> running_servers_names.txt
done
