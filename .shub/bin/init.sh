#!/bin/bash

# DevOntheRun INIT Project Script

exec 0< /dev/tty

.shub/bin/shub-logo.sh

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

if git rev-parse --git-dir > /dev/null 2>&1; then
    PROJECT_REPO_LINK=$(git config --get remote.origin.url)
    PROJECT_REPO_NAME=$(basename `git rev-parse --show-toplevel`)
    GIT_BRANCH=$(git branch --show-current)
    GIT_USERNAME=$(git config user.name)

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
  GIT_USERNAME="{{ REPLACE_WITH_YOUR_NAME }}"
fi




echo "Type below some infos about the course"
echo "---------------------------------------------"

printf 'Project name: '
read -r PROJECT_NAME
printf 'Course name: '
read -r COURSE_NAME
printf 'Course link: '
read -r COURSE_LINK
printf 'Course type (class, episode...): '
read -r COURSE_TYPE
read -r -p "This course will be unique? [Y/n] " COURSE_MULTIPLE
COURSE_MULTIPLE=${COURSE_MULTIPLE,,} # tolower
if [[ $COURSE_MULTIPLE =~ ^(yes|y| ) ]] || [[ -z $COURSE_MULTIPLE ]]; then
    COURSE_MULTIPLE='false'
else
    COURSE_MULTIPLE='true'
fi

SHUB_VERSION='true'
read -r -p "Remove ShubcoGen from app version control? [Y/n] " response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    SHUB_VERSION='false'
    echo ".shub" >> .gitignore
fi

JSON_TEMPLATE='{
    "version": "%s",
    "project": {
        "name": "%s",
        "link": "%s"
    },
    "course": {
        "name": "%s",
        "link": "%s",
        "type": "%s",
        "multiple": %s
    },
    "vcs": "%s"
}\n'
JSON_CONFIG=$(printf "$JSON_TEMPLATE" "$VERSION" "$PROJECT_NAME" "$PROJECT_REPO_LINK" "$COURSE_NAME" "$COURSE_LINK" "$COURSE_TYPE" "$COURSE_MULTIPLE" "$SHUB_VERSION")

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
    sed -i "s/{{ GIT_USERNAME }}/$GIT_USERNAME/g" README.md
    sed -i "s/{{ VERSION }}/$VERSION/g" README.md

# Save JSON config file
cat <<EOF > shub-config.json
$JSON_CONFIG
EOF
fi

read -r -p "Keep shub scripts (deploy, init, self-update)? [Y/n] " response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    echo "OK =)"

    # Auto init first new branch based on course type
    if git rev-parse --git-dir > /dev/null 2>&1; then
        [[ $COURSE_MULTIPLE = 'true' ]] && FIRST_BRANCH_NAME="${COURSE_TYPE}-1.1" || FIRST_BRANCH_NAME="${COURSE_TYPE}-1"
        read -r -p "Checkout to new branch ($FIRST_BRANCH_NAME)? [Y/n] " response
        response=${response,,} # tolower
        if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
            git checkout -b $FIRST_BRANCH_NAME
        fi
    fi
else
    rm .shub/bin/init.sh
    rm .shub/bin/shub-logo.sh
    rm .shub/bin/deploy.sh
    rm .shub/bin/self-update.sh
fi

echo -e "\xE2\x9C\x94 CONFIGURATION COMPLETED"
