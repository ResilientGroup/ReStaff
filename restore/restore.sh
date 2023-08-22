# Small helper script that gets the latest Pterodactyl backups for all servers on a specific Wings node
# and then spits out the restore/untar commands for all them to pick and choose from for a manual restore

# svr=${1}
svr=8a7e5144
. .env

# ALL_SERVERS=$(curl --location --request GET https://panel.reload.works/api/application/nests/1/eggs/15?include=servers --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[-2] | .attributes.uuid')

# get all servers on wings node
ALL_SERVERS_WINGS30=$(curl --location --request GET https://panel.reload.works/api/application/nodes/22?include=servers --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.uuid')

# ALL_SERVERS_WINGS31=$(curl --location --request GET https://panel.reload.works/api/application/nodes/23?include=servers --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.uuid')

# echo $ALL_SERVERS_WINGS31
# ALL_SERVERS_WINGS32=$(curl --location --request GET https://panel.reload.works/api/application/nodes/24?include=servers --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.uuid')


# echo $ALL_SERVERS

EGG=28

get latest backup for each server
for svr in $ALL_SERVERS_WINGS30; do
    SERVER_EGG=$(curl --location --request GET https://panel.reload.works/api/client/servers/$svr?include=egg --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.egg.attributes.uuid')

    if [[ "$SERVER_EGG" != "6e2a3fc1-511a-417b-b213-60ce4b824c93" ]]; then
        continue
    fi

    LATEST_BACKUP=$(curl --location --request GET https://panel.reload.works/api/client/servers/$svr/backups --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' | jq -r '.data | .[-2] | .attributes.uuid' )

    # echo $LATEST_BACKUP

    echo "echo deleting $svr..."
    echo "rm -r /var/lib/pterodactyl/volumes/$svr/*"
    echo "echo restoring $svr..."
    echo "tar -xzf /var/lib/pterodactyl/backups/${LATEST_BACKUP}.tar.gz -C /var/lib/pterodactyl/volumes/$svr/"
    echo "echo setting permissions for $svr..."
    echo "chown -R pterodactyl:pterodactyl /var/lib/pterodactyl/volumes/$svr/*"
    echo "echo ''"
done

# # curl --location --request POST https://panel.reload.works/api/client/servers/$svr/backups --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json'


# # kill all servers
# for svr in $ALL_SERVERS; do
#     echo "killing $svr"
#     curl --location --request POST https://panel.reload.works/api/client/servers/$svr/power --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' --data-raw '{"signal": "kill"}'
# done

# BACKUPS=$(curl --location --request GET https://panel.reload.works/api/client/servers/$svr/backups --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json')

# # echo $BACKUPS
