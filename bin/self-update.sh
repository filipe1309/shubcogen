#!/bin/bash

# DevOntheRun Self-Update Script

LOCAL_VERSION=$(head -n 1 bin/version)
REMOTE_VERSION=$(curl -s https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/version)

if [ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]; then
        read -r -p "There is a new version of ShubCoGen script ($REMOTE_VERSION), do you want to update it? [Y/n] " response
        response=${response,,} # tolower
        if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
            echo "Updating..."
            curl -o bin/version https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/version
            curl -o bin/deploy.sh https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/deploy.sh
            chmod +x bin/deploy.sh
            exit 0;
        fi
fi
