## 初始化 Gitlab 專案的主要資訊，以此方式建立並確保可重複執行整個設置行為
#!/bin/bash
set -e

# Declare variable
source ./src/conf.sh
# Include library
source ./src/utils.sh
source ./src/gitlab.sh

# Execute script
echo-i $(gitlab-version)

# create group
echo-i "Create Group"
#create-group RD "This group for development repository."
#create-group PM "This group for project management repository."
#create-group QA "This group for quality assurance repository."
retrieve-group

# create user
echo-i "Create User"
#create-user testA testA@testmail.com
#create-user testB testB@testmail.com
#create-user testC testC@testmail.com
#create-user testD testD@testmail.com
retrieve-user

echo-i "Add User into Group"
add-group testA RD
add-group testA PM
add-group testA QA
add-group testB RD
add-group testC PM 20
add-group testD QA 20

# create project
echo-i "Create Project"
#create-project-with-readme ws-core RD
#create-project-with-readme ws-corex RD
#create-project-with-readme ws-corexx RD
#create-project-with-readme ws-corexxX RD
retrieve-project
#edit-project-desc ws-core "It is a ws-core project"
#edit-project-desc ws-corex "It is a ws-corex project"
#edit-project-desc ws-corexx "It is a ws-corexx project"
#edit-project-desc ws-corexxX "It is a ws-corexxX project"
