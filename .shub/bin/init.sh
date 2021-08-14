#!/bin/bash

# DevOntheRun INIT Project Script

echo "---------------------------------------------"

read -r -p "Config template? [Y/n] " response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    echo "OK =)"
else
    exit 0;
fi

clear

echo "#############################################"
echo "                   INIT                   "
echo "#############################################"

VERSION=$(head -n 1 .shub/bin/version)

PROJECT_NAME='Project X'
COURSE_NAME='My Course'
COURSE_LINK='http://www.mycourse.com'

if git rev-parse --git-dir > /dev/null 2>&1; then
    PROJECT_REPO_LINK=$(git config --get remote.origin.url)
    PROJECT_REPO_NAME=$(basename `git rev-parse --show-toplevel`)
    GIT_BRANCH=$(git branch --show-current)

    extractUserFromGitHubLInk () {
        # url="git://github.com/some-user/my-repo.git"
        # url="https://github.com/some-user/my-repo.git"
        # url="git@github.com:some-user/my-repo.git"
        url=$1
        re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+).git$"

        if [[ $url =~ $re ]]; then    
            protocol=${BASH_REMATCH[1]}
            separator=${BASH_REMATCH[2]}
            hostname=${BASH_REMATCH[3]}
            user=${BASH_REMATCH[4]}
            repo=${BASH_REMATCH[5]}

            GITHUB_USER=$user
        fi
    }

    extractUserFromGitHubLInk $PROJECT_REPO_LINK
else
  PROJECT_REPO_LINK="{{ REPLACE_WITH_YOUR_REPO_LINK }}"
  PROJECT_REPO_NAME="{{ REPLACE_WITH_YOUR_REPO_NAME }}"
  GIT_BRANCH=""
fi




echo "Type below some infos about the course"
echo "---------------------------------------------"

printf 'Project name: '
read -r PROJECT_NAME
printf 'Course name: '
read -r COURSE_NAME
printf 'Course link: '
read -r COURSE_LINK

JSON_TEMPLATE='{
    "version": "%s",
    "project": {
        "name": "%s",
        "link": "%s"
    },
    "course": {
        "name": "%s",
        "link": "%s"
    }
}\n'
JSON_CONFIG=$(printf "$JSON_TEMPLATE" "$VERSION" "$PROJECT_NAME" "$PROJECT_REPO_LINK" "$COURSE_NAME" "$COURSE_LINK")

echo ""
echo "---------------------------------------------"

echo $JSON_CONFIG

echo "---------------------------------------------"
echo ""

read -r -p "Accept configs? [Y/n] " response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    # Update template
    sed -i "s/{{ PROJECT_NAME }}/$PROJECT_NAME/g" README.md
    sed -i "s/{{ COURSE_NAME }}/$COURSE_NAME/g" README.md
    sed -i "s/{{ COURSE_LINK }}/$COURSE_LINK/g" README.md
    sed -i "s/{{ PROJECT_REPO_NAME }}/$PROJECT_REPO_NAME/g" README.md
    sed -i "s/{{ GITHUB_USER }}/$GITHUB_USER/g" README.md
    sed -i "s/{{ VERSION }}/$VERSION/g" README.md

# Save JSON config file
cat <<EOF > .shub/bin/config.json
$JSON_CONFIG
EOF
fi

read -r -p "Keep shub scripts (deploy, init, self-update)? [Y/n] " response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    echo "OK =)"
else
    rm .shub/bin/init.sh
    rm .shub/bin/deploy.sh
    rm .shub/bin/self-update.sh
fi

echo -e "\xE2\x9C\x94 CONFIGURATION COMPLETED"
