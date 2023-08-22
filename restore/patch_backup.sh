# Small helper script that patches the number of allowed backups for all servers in a specific egg

# svr=${1}
# svr=550 # good-warm
. .env

ALL_QUALITY_SERVERS=$(curl --location --request GET https://panel.reload.works/api/application/nests/1/eggs/28?include=servers --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.id')

for svr in $ALL_QUALITY_SERVERS; do
    SERVER=$(curl --location --request GET https://panel.reload.works/api/application/servers/$svr --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json')

    # echo $SERVER | jq

    ALLOCATION=$(echo $SERVER | jq -r '.attributes.allocation')
    MEMORY=$(echo $SERVER | jq -r '.attributes.limits.memory')
    SWAP=$(echo $SERVER | jq -r '.attributes.limits.swap')
    IO=$(echo $SERVER | jq -r '.attributes.limits.io')
    CPU=$(echo $SERVER | jq -r '.attributes.limits.cpu')
    DISK=$(echo $SERVER | jq -r '.attributes.limits.disk')
    THREADS=$(echo $SERVER | jq -r '.attributes.limits.threads')

    PATCH='{   "allocation": "'$ALLOCATION'",     "memory": "'$MEMORY'",     "swap": "'$SWAP'",     "io": "'$IO'",     "cpu": "'$CPU'",     "disk": "'$DISK'",  "feature_limits": { "databases": 0, "allocations": 0, "backups": 10}}'

    PATCH_SERVER=$(curl -v --location -X PATCH https://panel.reload.works/api/application/servers/$svr/build --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' -d "$PATCH")

    echo $PATCH_SERVER | jq
done
