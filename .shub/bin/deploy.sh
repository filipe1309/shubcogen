#!/bin/bash

# DevOntheRun Deploy Script

.shub/bin/shub-logo.sh
source .shub/bin/helpers.sh
source .shub/bin/colors.sh

# Read json file content
JSON_CONFIG="$(cat shub-config.json)"
COURSE_TYPE=$(parse_json "$JSON_CONFIG" course_type)

VERSION=$(head -n 1 .shub/bin/version)


echo -e "${BG_GREEN}"
echo "#############################################"
echo "               DOTR DEPLOY $VERSION                   "
echo -e "#############################################${NO_BG}"
echo "# [Optional] param: --tag-msg \"TAG_MESSAGE_HERE\""
echo "---------------------------------------------"

.shub/bin/self-update.sh && exit 0

TAG_MSG=$2
GIT_BRANCH=$(git branch --show-current)
GIT_DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD' | cut -d':' -f2 | sed -e 's/^ *//g' -e 's/ *$//g')
[ $GIT_DEFAULT_BRANCH = "(unknown)" ] && GIT_DEFAULT_BRANCH="main"
TAG_NAME=$GIT_BRANCH
FAILED_MSG="\u274c ERROR =/"
NEWEST_TAG=$(git describe --abbrev=0 --tags)

IFS='-' read -ra ADDR <<< "$GIT_BRANCH"
CLASS_TYPE="${ADDR[0]}-"

if [[ ${ADDR[1]} == *"."* ]]; then
    IFS='.' read -ra ADDR <<< "${ADDR[1]}"
    CLASS_NUMBER="$CLASS_NUMBER ${ADDR[1]}"
    CLASS_TYPE="${CLASS_TYPE}${ADDR[0]}."
fi
CLASS_NUMBER=${ADDR[1]}

GIT_BRANCH_NEXT_CLASS=$CLASS_TYPE$(($CLASS_NUMBER + 1))
GIT_BRANCH_NEXT_CLASS_LW=$(echo "$GIT_BRANCH_NEXT_CLASS" | tr '[:upper:]' '[:lower:]')  # tolower
GIT_BRANCH_NEXT_CLASS_UP=$(echo "$GIT_BRANCH_NEXT_CLASS" | tr '[:lower:]' '[:upper:]')  # toupper

echo "Branch to deploy: $GIT_BRANCH"
echo "Next branch: $GIT_BRANCH_NEXT_CLASS_LW"

echo "---------------------------------------------"

generateTag() {
    if [[ $NEWEST_TAG != *$GIT_BRANCH* ]]; then
        if [ $# -eq 0 ]; then
            read -r -p "Do you want to $(echo -e $BG_GREEN"tag"$NO_BG) [$(echo -e $BG_GREEN"Y"$NO_BG)/n]? " response
            response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # tolower
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
                    TAG_MSG_SLUG=$(echo "$tagmsg" | iconv -t ascii//TRANSLIT | sed -r 's/[~\^]+//g' | sed -r 's/[^a-zA-Z0-9]+/-/g' | sed -r 's/^-+\|-+$//g' | tr A-Z a-z)
                    TAG_NAME="${TAG_NAME}-${TAG_MSG_SLUG}"
                    TAG_MSG="$tagMsgPrefix - $tagmsg"
                else
                    echo "Tag message missing"
                    exit 0
                fi

                echo "---------------------------------------------"
                echo "Tag:    [name]= \"$TAG_NAME\" || [msg]= \"$TAG_MSG\""
                echo "---------------------------------------------"

                read -r -p "Are you sure [$(echo -e $BG_GREEN"Y"$NO_BG)/n]? " response
                response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # tolower

                if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
                    git tag -a $TAG_NAME -m "$TAG_MSG"
                else
                    echo "Bye =)"
                    exit 0
                fi
                echo "---------------------------------------------"
            fi
        else
            # Verify if param --tag-msg is set && message param is not empty
            if [ $1 != "--tag-msg" ] && [ -z "$2" ]; then
                echo "Wrong tag param"
                exit 0
            fi
            git tag -a $TAG_NAME -m "$TAG_MSG"
        fi
    fi
}



#################
### BRANCH
#################

echo ""

echo "🏁 Starting deploy process ..."
echo "✔ Auto commiting notes ..."
git add notes.md && git commit -m "docs: update notes"

if ( ! test -f ".gitignore" ) || ( test -f ".gitignore" && ! grep -q .shub ".gitignore" ); then
    echo "✔ Auto commiting shub files ..."
    git add .shub && git commit -m "chore: update shub files"  
fi

echo "---------------------------------------------"
echo ""
confirm "Checkout to \"$(echo -e $BG_GREEN"$GIT_DEFAULT_BRANCH"$NO_BG)\" branch & Merge current branch ($GIT_BRANCH) [$(echo -e $BG_GREEN"Y"$NO_BG)/n]? " && { git checkout $GIT_DEFAULT_BRANCH  || { echo -e "$FAILED_MSG" ; exit 1; } } && { git merge $GIT_BRANCH  || { echo -e "$FAILED_MSG" ; exit 1; } }
echo ""
echo "---------------------------------------------"
echo ""
generateTag
echo ""
echo "---------------------------------------------"
echo ""
echo "---------------------------------------------"
echo ""
confirm "Deploy on \"$(echo -e $BG_GREEN"$GIT_DEFAULT_BRANCH"$NO_BG)\" branch [$(echo -e $BG_GREEN"Y"$NO_BG)/n]? " && { git push origin $GIT_DEFAULT_BRANCH  || { echo -e "$FAILED_MSG" ; exit 1; } } && { git push origin $GIT_DEFAULT_BRANCH --tags  || { echo -e "$FAILED_MSG" ; exit 1; } }
echo ""
echo "---------------------------------------------"

echo -e "${BG_GREEN}"
echo -e "\xE2\x9C\x94 DEPLOY COMPLETED"
echo -e "${NO_BG}"
echo ""
echo "---------------------------------------------"
echo ""
confirm "Go to next \"$(echo -e $BG_GREEN"$COURSE_TYPE"$NO_BG)\" ($GIT_BRANCH_NEXT_CLASS_LW) [$(echo -e $BG_GREEN"Y"$NO_BG)/n]? " && git checkout -b $GIT_BRANCH_NEXT_CLASS_LW
echo ""
GIT_BRANCH_NEXT_CLASS=$(echo "$GIT_BRANCH_NEXT_CLASS" | tr '[:lower:]' '[:upper:]')  # toupper
echo "## $GIT_BRANCH_NEXT_CLASS" >> notes.md
echo "" >> notes.md

