# svr=${1}
# svr=8a7e5144
. .env

# ALL_SERVERS=$(curl --location --request GET 'https://panel.reload.works/api/application/nests/1/eggs/15?include=servers' --header 'Accept: application/json' --header 'Authorization: Bearer '$APPLICATION_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.relationships.servers.data | .[] | .attributes.uuid')

ALL_SERVERS=$(cat running_servers.txt)

# start all servers
for svr in $ALL_SERVERS; do
    echo "check power state of $svr"
    CURRENT_STATE=$(curl --location --request GET https://panel.reload.works/api/client/servers/$svr/resources --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' | jq -r '.attributes.current_state')
    echo "Current state of $svr: $CURRENT_STATE"
    if [ "$CURRENT_STATE" = "running" ]; then
        # echo "$svr" >> running_servers.txt
        echo "killing $svr"
        curl --location --request POST https://panel.reload.works/api/client/servers/$svr/power --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' --data-raw '{"signal": "kill"}'

        echo "sleeping 5..."
        sleep 5

        echo "starting $svr..."
        curl --location --request POST https://panel.reload.works/api/client/servers/$svr/power --header 'Accept: application/json' --header 'Authorization: Bearer '$CLIENT_TOKEN'' --header 'Content-Type: application/json' --data-raw '{"signal": "start"}'
    fi
done
