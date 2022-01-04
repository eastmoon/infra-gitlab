## Gitlab 的專案在 CI 佈局的設置，建立開發主線 ( master，unprotect )、產品主線 ( release，protect )
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Execute script
## Retrieve gitlab version infromation
echo-i $(gitlab-version)

## Setting protect branch
retrieve-project
for filename in $(ls .tmp/project_*)
do
    PROJ_ID=$(jshon -e id < ${filename})
    PROJ_ID=${PROJ_ID//\ }
    PROJ_ID=${PROJ_ID//\"}
    PROJ_NAME=$(jshon -e name < ${filename})
    PROJ_NAME=${PROJ_NAME//\ }
    PROJ_NAME=${PROJ_NAME//\"}
    PROJ_GROUP=$(jshon -e namespace -e path < ${filename})
    PROJ_GROUP=${PROJ_GROUP//\ }
    PROJ_GROUP=${PROJ_GROUP//\"}
    if [[ ${PROJ_GROUP} != *"gitlab"* ]];
    then
        ### 1. unprotect default branch "master"
        unprotect-branch ${PROJ_NAME} master
        ### 2. setting protect branch white card "release*", it will protect all "release" title branch
        protect-branch ${PROJ_NAME} release*
        ### 3. git clone repository
        git-init ${PROJ_GROUP} ${PROJ_NAME} master
        ### 4. create new release from master ( it will new branch from git-init branch )
        git-init-branch ${PROJ_NAME} release
    fi
done
