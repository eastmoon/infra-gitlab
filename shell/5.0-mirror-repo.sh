## Git 操作，使用 Git 指令建立鏡像專案
## 鏡像專案：將來源專案的原碼樹從自身的主線分支 ( main ) 或特定分支 ( feature/<branch name>) 鏡像到目標專案的主線分支 ( main )
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Declare variable
SOURCE_REPO_NAME=demo-case-5-S-`date "+%Y%m%d%H%M%S"`
TARGET_REPO_NAME=demo-case-5-T-`date "+%Y%m%d%H%M%S"`
SOURCE_REPO=( DEMO ${SOURCE_REPO_NAME} main )
TARGET_REPO=( DEMO ${TARGET_REPO_NAME} main )

# Execute script

## Create test repository
create-project-with-readme ${SOURCE_REPO[1]} ${SOURCE_REPO[0]}
create-project ${TARGET_REPO[1]} ${TARGET_REPO[0]}
retrieve-project

## Mirror repository
git-init-mirror-repository ${SOURCE_REPO[0]} ${SOURCE_REPO[1]} ${SOURCE_REPO[2]} ${TARGET_REPO[0]} ${TARGET_REPO[1]}

## Show main information
git-init ${TARGET_REPO[0]} ${TARGET_REPO[1]} ${TARGET_REPO[2]}
git-info-repo ${TARGET_REPO[1]}
git-info-repo-log ${TARGET_REPO[1]} 5
