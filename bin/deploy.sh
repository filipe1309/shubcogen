#!/bin/bash

# DevOntheRun Deploy Script

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

BG_GREEN='\e[1;32m'
NO_BG='\e[m'
DARK_GRAY='\033[1;30m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BG_GREEN}"
echo "#############################################"
echo "                   DEPLOY                   "
echo -e "#############################################${NO_BG}"
echo "# [Optional] param: --tag-msg \"TAG_MESSAGE_HERE\""
echo "---------------------------------------------"

TAG_MSG=$2
GIT_BRANCH=$(git branch --show-current)
GIT_DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD' | cut -d':' -f2 | sed -e 's/^ *//g' -e 's/ *$//g')
TAG_NAME=$(echo "$GIT_BRANCH" | tr -d -)

IFS='-' read -ra ADDR <<< "$GIT_BRANCH"
CLASS_TYPE=${ADDR[0]}
CLASS_NUMBER=${ADDR[1]}

echo $CLASS_TYPE $CLASS_NUMBER
GIT_BRANCH_NEXT_CLASS=$CLASS_TYPE-$(($CLASS_NUMBER + 1))
GIT_BRANCH_NEXT_CLASS_LW=${GIT_BRANCH_NEXT_CLASS,,}  # tolower
GIT_BRANCH_NEXT_CLASS_UP=${GIT_BRANCH_NEXT_CLASS^^}  # toupper

echo "---------------------------------------------"

confirm() {
    read -r -p "${1:-Are you sure? [Y/n]} " response
    response=${response,,} # tolower
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
        echo "Ok"
    else
        exit 0;
    fi
}


echo "Branch to deploy: $GIT_BRANCH"


# if arguments [ $# -eq 0 ]
if [ $# -eq 0 ]; then
    read -r -p "Do you want to tag? [Y/n] " response
    response=${response,,} # tolower
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
        echo "# TAG MESSAGE"
        echo "# Example: \"$(git tag -n9 | head -n 1 | awk '{for(i=2;i<=NF;++i)printf $i FS}')\""
        tagMsgPrefixSuggestion="$(tr '[:lower:]' '[:upper:]' <<< ${TAG_NAME:0:1})${TAG_NAME:1}"
        echo "Type the tag message prefix [$tagMsgPrefixSuggestion - ]:"
        read -e tagMsgPrefix
        if [ -z "$tagMsgPrefix"  -a "$tagMsgPrefix" != " " ]; then
            tagMsgPrefix=$tagMsgPrefixSuggestion
        fi

        echo "Type the tag message:"
        read -e tagmsg
        if [ ! -z "$tagmsg"  -a "$tagmsg" != " " ]; then
            TAG_MSG="$tagMsgPrefix - $tagmsg"
        else
            echo "Tag message missing"
            exit 0
        fi
        git tag -a $TAG_NAME -m "$TAG_MSG"
    fi
else
    # Verify if param --tag-msg is set && message param is not empty
    if [ $1 != "--tag-msg" ] && [ -z "$2" ]; then
        echo "Wrong tag param"
        exit 0
    fi
    git tag -a $TAG_NAME -m "$TAG_MSG"
fi

echo "---------------------------------------------"
echo "Branch: \"$GIT_BRANCH\""
echo "---------------------------------------------"
echo "Tag:    [name]= \"$TAG_NAME\" || [msg]= \"$TAG_MSG\""
echo "---------------------------------------------"

read -r -p "Are you sure? [Y/n] " response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    echo "---------------------------------------------"
    echo "Deploying..."
    git add notes.md && git commit -m "docs: update notes"
    confirm "Checkout to \"$GIT_DEFAULT_BRANCH\" branch & Merge current branch ($GIT_BRANCH)? [Y/n]" && git checkout $GIT_DEFAULT_BRANCH && git pull && git merge $GIT_BRANCH
    confirm "Deploy on \"$GIT_DEFAULT_BRANCH\" branch? [Y/n]" git push origin $GIT_DEFAULT_BRANCH && git push origin $GIT_DEFAULT_BRANCH --tags
    echo -e "                   \xE2\x9C\x94 DEPLOY COMPLETED"
    confirm "Go to next class/episode? ($GIT_BRANCH_NEXT_CLASS_LW) [Y/n]" && git checkout -b $GIT_BRANCH_NEXT_CLASS_LW
    echo "## ${GIT_BRANCH_NEXT_CLASS^^}" >> notes.md
    echo "" >> notes.md
else
    echo "Bye =)"
    exit 0
fi
