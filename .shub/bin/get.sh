#!/bin/bash

curl -o .shub/bin/deploy.sh --create-dirs https://raw.githubusercontent.com/filipe1309/shubcogen/main/.shub/bin/deploy.sh
curl -o .shub/bin/update.sh --create-dirs https://raw.githubusercontent.com/filipe1309/shubcogen/main/.shub/bin/update.sh
curl -o .shub/bin/version --create-dirs https://raw.githubusercontent.com/filipe1309/shubcogen/main/.shub/bin/version

curl -o README.md https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/README.md
curl -o notes.md https://raw.githubusercontent.com/filipe1309/shubcogen/main/templates/notes.md
curl -o LICENSE https://raw.githubusercontent.com/filipe1309/shubcogen/main/LICENSE
curl -o shub-deploy.sh https://raw.githubusercontent.com/filipe1309/shubcogen/main/shub-deploy.sh

chmod +x .shub/bin/deploy.sh
