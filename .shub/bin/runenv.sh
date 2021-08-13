
#!/bin/bash

GROUP="docker"
CONTAINER_BASENAME="CONTAINER_BASENAME"
# NETWORK_NAME = "newsapi_default"

# if (docker network ls | select-string $NETWORK_NAME -Quiet )
# {
#     Write-Host "$NETWORK_NAME already created"
# } else {
#     docker network create $NETWORK_NAME
# }


#Create docker group
if ! grep -q $GROUP /etc/group; then
    sudo groupadd $GROUP
fi

#Add user to docker group and apply immediately
if ! groups $USER | grep &>/dev/null "\b${GROUP}\b"; then
    sudo usermod -aG $GROUP $USER
    sudo newgrp $GROUP
fi

# Increate vm.max_map_count
if ! [[ `sysctl vm.max_map_count | awk -F' ' '{print $3}'` =~ 262144 ]]; then
    sudo sysctl -w vm.max_map_count=262144
fi

DOCKER_CONTAINER=$(docker ps --filter name=${CONTAINER_BASENAME} -aq)

if ! [[ -z "$DOCKER_CONTAINER" ]]; then
  docker stop ${DOCKER_CONTAINER} && docker rm ${DOCKER_CONTAINER}
fi

if [ ! -f images/development.env ]; then
    cp images/development.env.example images/development.env
fi

# Update pre-push git hook
cp bin/pre-push .git/hooks/pre-push

ln -sf images/development.env .env
docker-compose up --build