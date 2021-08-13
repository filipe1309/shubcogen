#!/bin/bash

# DevOntheRun Start Project Script

echo "#############################################"
echo "                   START                   "
echo "#############################################"

PROJECT_NAME = 'Project X'
COURSE_NAME='My Course'
COURSE_LINK='http://www.mycourse.com'
PROJECT_REPO_LINK=$(git config --get remote.origin.url)
PROJECT_REPO_NAME=$(basename `git rev-parse --show-toplevel`)
CONTAINER_NAME=''
GIT_BRANCH=$(git branch --show-current)

echo "Type below some infos about the course"
printf 'Course name: '
read -r COURSE_NAME
printf 'Course link: '
read -r COURSE_LINK


echo $COURSE_NAME
