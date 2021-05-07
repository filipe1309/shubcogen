#!/bin/bash

# DevOntheRun Deploy Script

echo "#############################################"
echo "                   DEPLOY                   "
echo "#############################################"
echo "# [Optional] param: --tag-msg \"TAG_MESSAGE_HERE\""
echo "---------------------------------------------"

TAG_MSG=$2
GIT_BRANCH=$(git branch --show-current)
TAG_NAME=$(echo "$GIT_BRANCH" | tr -d -)


confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

echo "Deploying branch: $GIT_BRANCH ..."


# if arguments [ $# -eq 0 ]
if [ $# -eq 0 ]; then
    echo "Type the tag message:"
    echo "# example: \"$(git tag -n9 | head -n 1 | awk '{for(i=2;i<=NF;++i)printf $i FS}')\""
    read -e tagmsg
    echo "Typed: \"$tagmsg\""
    if [ ! -z "$tagmsg"  -a "$tagmsg" != " " ]; then
        TAG_MSG=$tagmsg
    else
        echo "Tag message missing"
        exit 0
    fi
else
    # Verify if param --tag-msg is set && message param is not empty
    if [ $1 != "--tag-msg" ] && [ -z "$2" ]; then
        echo "Wrong tag param"
        exit 0
    fi
fi

echo "---------------------------------------------"
echo "Branch to deploy will be: \"$GIT_BRANCH\""
echo "Tag will be: [name]= \"$TAG_NAME\", [msg]= \"$TAG_MSG\""
echo "---------------------------------------------"

read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo "---------------------------------------------"
    echo "Deploying..."
    git add notes.md && git commit -m "docs: update notes"
    git tag -a $TAG_NAME -m "$TAG_MSG" && git push origin $GIT_BRANCH && git push origin $GIT_BRANCH --tags && git checkout main
    confirm "Pull from repo? [y/N]" && git pl
    echo "Deploy completed!"
else
    echo "Bye =)"
    exit 0
fi
