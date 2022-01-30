## 初始化 Gitlab 專案的主要資訊，以此方式建立並確保可重複執行整個設置行為
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh

# Execute script
## Retrieve gitlab version infromation
echo-i $(gitlab-version)

## create group
echo-i "Create Group"
create-group RD "This group for development repository."
create-group PM "This group for project management repository."
create-group QA "This group for quality assurance repository."
create-group DEMO "This group for DEMO repository."
retrieve-group

## create user
echo-i "Create User"
create-user testA testA@testmail.com
create-user testB testB@testmail.com
create-user testC testC@testmail.com
create-user testD testD@testmail.com
retrieve-user

echo-i "Add User into Group"
add-user-to-group testA RD
add-user-to-group testA PM
add-user-to-group testA QA
add-user-to-group testB RD
add-user-to-group testC PM 20
add-user-to-group testD QA 20

## create project
echo-i "Create Project"
create-project-with-readme ws-core RD
create-project-with-readme ws-corex RD
create-project-with-readme ws-corexx RD
retrieve-project
edit-project-desc ws-core "It is a ws-core project"
edit-project-desc ws-corex "It is a ws-corex project"
edit-project-desc ws-corexx "It is a ws-corexx project"
