## Gitlab 的專案在 CI 佈局的設置，建立開發主線 ( master，unprotect )、產品主線 ( release，protect )
#!/bin/bash
set -e

# Declare variable
source ./src/conf.sh
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
        unprotect-branch ${PROJ_NAME} master
        protect-branch ${PROJ_NAME} release*
        git-init ${PROJ_GROUP} ${PROJ_NAME} master
        git-init-branch ${PROJ_NAME} release
    fi
done
