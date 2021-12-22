#!/bin/bash
set -e

# Declare variable
export GIT_ACCESS_NAME=admin-shell-token
export GIT_ACCESS_TOKEN=""
export GIT_SERVER=localhost

# Include library
source ./src/utils.sh
source ./src/gitlab.sh

# Execute script
echo-i $(gitlab-version)

# create group
echo-i "Create Group"
create-group RD "This group for development repository."
create-group PM "This group for project management repository."
create-group QA "This group for quality assurance repository."
retrieve-group

# create user
echo-i "Create User"
create-user testA testA@testmail.com
create-user testB testB@testmail.com
create-user testC testC@testmail.com
create-user testD testD@testmail.com
retrieve-user

echo-i "Add User into Group"
add-group testA RD
add-group testA PM
add-group testA QA
add-group testB RD
add-group testC PM
add-group testD QA

# create project
echo-i "Create Project"
create-project ws-core RD
create-project ws-corex RD
create-project ws-corexx RD
create-project ws-corexxX RD
retrieve-project
