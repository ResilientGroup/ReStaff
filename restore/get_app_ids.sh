# svr=${1}
# svr=8a7e5144
. .env

ALL_SERVERS=$(curl --location --request GET 'https://panel.reload.works/api/application/nests/1/eggs/15?include=servers' --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.id')

# get state of servers
for svr in $ALL_SERVERS; do
    echo $svr
done
