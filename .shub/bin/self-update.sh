#!/bin/bash

# DevOntheRun Self-Update Script

LOCAL_VERSION=$(head -n 1 .shub/bin/version)
REMOTE_VERSION=$(curl -s https://raw.githubusercontent.com/filipe1309/shubcogen/main/.shub/bin/version)

if [ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]; then
        read -r -p "There is a new version of ShubCoGen script ($REMOTE_VERSION), do you want to update it? [Y/n] " response
        response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # tolower
        if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
            echo "Updating..."
            curl -o .shub/bin/links.txt --create-dirs https://raw.githubusercontent.com/filipe1309/shubcogen/main/.shub/bin/links.txt
            cat .shub/bin/links.txt | while read CMD; do curl -o $(echo ".shub/bin/$(basename $CMD) --create-dirs $CMD"); done;
            chmod -R +x .shub/bin/*.sh

            if ( ! test -f ".gitignore" ) || ( test -f ".gitignore" && ! grep -q .shub ".gitignore" ); then
                echo "✔ Auto commiting shub files ..."
                git add .shub && git commit -m "chore: update shub files"  
            fi
            
            exit 0
        fi
fi

exit 1
