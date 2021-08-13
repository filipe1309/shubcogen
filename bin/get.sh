#!/bin/bash

curl -o bin/version https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/version

curl -o bin/deploy.sh https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/deploy.sh
curl -o bin/update.sh https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/update.sh
curl -o bin/version https://raw.githubusercontent.com/filipe1309/shubcogen/main/bin/version
curl -o README.md https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/README.md
curl -o notes.md https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/notes.md
curl -o LICENSE https://raw.githubusercontent.com/filipe1309/shubcogen/main/LICENSE

chmod +x bin/deploy.sh
