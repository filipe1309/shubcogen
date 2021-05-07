#!/bin/bash

wget https://raw.githubusercontent.com/filipe1309/skeleton-courses/main/bin/deploy.sh -P bin
wget https://raw.githubusercontent.com/filipe1309/skeleton-courses/main/templates/README.md -O README.md
wget https://raw.githubusercontent.com/filipe1309/skeleton-courses/main/templates/notes.md

chmod +x bin/deploy.sh