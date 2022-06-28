# svr=${1}
# svr=8a7e5144
. .env # ADMIN_KEY is defined here

# ALL_SERVERS=$(curl --location --request GET 'https://panel.reload.works/api/application/nests/1/eggs/15?include=servers' --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.uuid')

EGG=31

ALL_SERVERS=$(curl --location --request GET 'https://panel.reload.works/api/application/nests/1/eggs/'${EGG}'?include=servers' --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.id')

# start all servers
for svr in $ALL_SERVERS; do
    SERVER=$(curl --location --request GET https://panel.reload.works/api/application/servers/$svr --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json')

    STARTUP="bash run.sh 2048"  # $(echo $SERVER | jq -r '.attributes.container.startup_command')
    IMAGE=$(echo $SERVER | jq -r '.attributes.container.image')
    
    NODE_ID=$(echo $SERVER | jq -r '.attributes.container.environment.NODE_ID')
    NODE_KEY=$(echo $SERVER | jq -r '.attributes.container.environment.NODE_KEY')
    ENVIRONMENT_BRANCH=$(echo $SERVER | jq -r '.attributes.container.environment.ENVIRONMENT_BRANCH')
    WORLD_BRANCH=$(echo $SERVER | jq -r '.attributes.container.environment.WORLD_BRANCH')
    UPDATE_WORLD=$(echo $SERVER | jq -r '.attributes.container.environment.UPDATE_WORLD')
    UPDATE_ENV=$(echo $SERVER | jq -r '.attributes.container.environment.UPDATE_ENV')
    NODE_TYPE="cus"

    STARTUP_PATCH='{   "startup": "'$STARTUP'", "egg": "'$EGG'", "image": "'$IMAGE'", "skip_scripts": false, "environment": { "NODE_ID": "'$NODE_ID'",  "NODE_KEY": "'$NODE_KEY'",  "ENVIRONMENT_BRANCH": "'$ENVIRONMENT_BRANCH'",  "WORLD_BRANCH": "'$WORLD_BRANCH'",  "UPDATE_WORLD": "'$UPDATE_WORLD'",  "UPDATE_ENV": "'$UPDATE_ENV'",  "NODE_TYPE": "'$NODE_TYPE'",  "ADMIN_KEY": "'$ADMIN_KEY'"}}'

    PATCH_STARTUP=$(curl --location -X PATCH https://panel.reload.works/api/application/servers/$svr/startup --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' -d "$STARTUP_PATCH")

    echo $PATCH_STARTUP | jq

done
