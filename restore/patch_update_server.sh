# svr=${1}
# svr=8a7e5144
. .env

ALL_SERVERS=$(curl --location --request GET 'https://panel.reload.works/api/application/nests/1/eggs/32?include=servers' --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.id')

# ALL_SERVERS="1522"

# start all servers
for svr in $ALL_SERVERS; do
    SERVER=$(curl --location --request GET https://panel.reload.works/api/application/servers/$svr --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json')

    # echo $SERVER | jq

    ALLOCATION=$(echo $SERVER | jq -r '.attributes.allocation')
    MEMORY=$(echo $SERVER | jq -r '.attributes.limits.memory')
    SWAP=$(echo $SERVER | jq -r '.attributes.limits.swap')
    IO=$(echo $SERVER | jq -r '.attributes.limits.io')
    CPU=$(echo $SERVER | jq -r '.attributes.limits.cpu')
    DISK=$(echo $SERVER | jq -r '.attributes.limits.disk')
    THREADS=$(echo $SERVER | jq -r '.attributes.limits.threads')

    BUILD_PATCH='{   "allocation": "'$ALLOCATION'",     "memory": "4096",     "swap": "'$SWAP'",     "io": "'$IO'",     "cpu": "'$CPU'",     "disk": "'$DISK'",  "feature_limits": { "databases": 0, "allocations": 0, "backups": 10}}'

    PATCH_BUILD=$(curl --location -X PATCH https://panel.reload.works/api/application/servers/$svr/build --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' -d "$BUILD_PATCH")

    echo $PATCH_BUILD | jq

    STARTUP="bash run.sh 2048"  # $(echo $SERVER | jq -r '.attributes.container.startup_command')
    EGG=$(echo $SERVER | jq -r '.attributes.egg')
    IMAGE=$(echo $SERVER | jq -r '.attributes.container.image')
    
    NODE_ID=$(echo $SERVER | jq -r '.attributes.container.environment.NODE_ID')
    NODE_KEY=$(echo $SERVER | jq -r '.attributes.container.environment.NODE_KEY')
    ENVIRONMENT_BRANCH=$(echo $SERVER | jq -r '.attributes.container.environment.ENVIRONMENT_BRANCH')
    WORLD_BRANCH=$(echo $SERVER | jq -r '.attributes.container.environment.WORLD_BRANCH')
    UPDATE_SERVER=1
    UPDATE_WORLD=$(echo $SERVER | jq -r '.attributes.container.environment.UPDATE_WORLD')
    UPDATE_ENV=$(echo $SERVER | jq -r '.attributes.container.environment.UPDATE_ENV')
    ADMIN_KEY=$(echo $SERVER | jq -r '.attributes.container.environment.ADMIN_KEY')
    NODE_TYPE=$(echo $SERVER | jq -r '.attributes.container.environment.NODE_TYPE')
    WHITELIST_URL=$(echo $SERVER | jq -r '.attributes.container.environment.WHITELIST_URL')
    BOSSBAR_TEXT=$(echo $SERVER | jq -r '.attributes.container.environment.BOSSBAR_TEXT')
    MAX_PLAYERS=$(echo $SERVER | jq -r '.attributes.container.environment.MAX_PLAYERS')


    STARTUP_PATCH='{   "startup": "'$STARTUP'", "egg": "'$EGG'", "image": "'$IMAGE'", "skip_scripts": false, "environment": { "NODE_ID": "'$NODE_ID'",  "NODE_KEY": "'$NODE_KEY'",  "ENVIRONMENT_BRANCH": "'$ENVIRONMENT_BRANCH'",  "WORLD_BRANCH": "'$WORLD_BRANCH'",  "UPDATE_WORLD": "'$UPDATE_WORLD'",  "UPDATE_ENV": "'$UPDATE_ENV'",  "UPDATE_SERVER": "'$UPDATE_SERVER'",  "ADMIN_KEY": "'$ADMIN_KEY'",  "NODE_TYPE": "'$NODE_TYPE'",  "WHITELIST_URL": "'$WHITELIST_URL'",  "MAX_PLAYERS": "'$MAX_PLAYERS'",  "BOSSBAR_TEXT": "'$BOSSBAR_TEXT'"}}'

    PATCH_STARTUP=$(curl --location -X PATCH https://panel.reload.works/api/application/servers/$svr/startup --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' -d "$STARTUP_PATCH")

    echo $PATCH_STARTUP | jq

done
