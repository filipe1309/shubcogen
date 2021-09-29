#!/bin/bash

TEMPLATE_DIR=""

[ $ENV == "test" ] && echo "TEST MODE"
[ $ENV != "test" ] && echo "NORMAL MODE"


if [ $ENV == "test" ]; then
    TEMPLATE_DIR="test/out/"
    # $1
fi


clear

echo "---------------------------------------------"

backupTemplateFiles() {
    backup() {
        echo "---------------------------------------------"
        file="$1"
        if [ -f "$file" ]; then
            echo "Backing up $file"
            mkdir -p .shub/backup && cp "$file" ".shub/backup/$file"
        fi 
    }
    echo ""
    backup "README.md"
    backup "notes.md"
}
[ $ENV != "test" ] && backupTemplateFiles

echo ""
echo "---------------------------------------------"
echo ""
echo "Downloading files ..."
echo ""
echo "---------------------------------------------"

# Script files
downloadScripts() {
    curl -o .shub/bin/links.txt --create-dirs https://raw.githubusercontent.com/filipe1309/shubcogen/main/.shub/bin/links.txt
    cat .shub/bin/links.txt | while read CMD; do curl -o $(echo ".shub/bin/$(basename $CMD) --create-dirs $CMD"); done;
    chmod -R +x .shub/bin/*.sh
    ln -s .shub/bin/deploy.sh shub-deploy.sh
}
[ $ENV != "test" ] && downloadScripts

# Template files
downloadTemplates() {
    curl -o "$TEMPLATE_DIR""README.md" https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/README.md
    curl -o "$TEMPLATE_DIR""notes.md" https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/notes.md
    curl -o "$TEMPLATE_DIR""LICENSE" https://raw.githubusercontent.com/filipe1309/shubcogen/main/LICENSE
}
[ $ENV != "test" ] && downloadTemplates

[ $ENV != "test" ] && .shub/bin/init.sh

[ $ENV == "test" ] && $1
