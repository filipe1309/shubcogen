#!/bin/bash

clear

echo "---------------------------------------------"

backup() {
    echo "---------------------------------------------"
    file="$1"
    if [ -f "$file" ]; then
        echo "Backing up $file"
        mkdir -p .shub/backup && cp "$file" ".shub/backup/$file"
    fi 
}

echo ""

echo "Backing up files into .shub/backup ..."
backup "README.md"
backup "notes.md"

echo ""
echo "---------------------------------------------"
echo ""
echo "Downloading files ..."
echo ""
echo "---------------------------------------------"

# Script files
curl -o .shub/bin/links.txt --create-dirs https://raw.githubusercontent.com/filipe1309/shubcogen/main/.shub/bin/links.txt
cat .shub/bin/links.txt | while read CMD; do curl -o $(echo ".shub/bin/$(basename $CMD) --create-dirs $CMD"); done;
chmod -R +x .shub/bin/*.sh
ln -s .shub/bin/deploy.sh shub-deploy.sh

# Template files
curl -o README.md https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/README.md
curl -o notes.md https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/notes.md
curl -o LICENSE https://raw.githubusercontent.com/filipe1309/shubcogen/main/LICENSE

.shub/bin/init.sh
