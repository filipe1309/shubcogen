#!/bin/bash

wget https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/deploy.sh -P bin
wget https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/version -P bin
wget https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/README.md -O README.md
wget https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/notes.md
wget https://raw.githubusercontent.com/filipe1309/shubcogen/main/LICENSE

chmod +x bin/deploy.sh
