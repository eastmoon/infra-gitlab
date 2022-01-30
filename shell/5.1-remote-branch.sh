## Git 操作，使用 Git 指令建構用於溝通的遠端分支
## 遠程分支：將來源專案的原碼樹從自身的遠程分支 ( remote/<branch name> ) 鏡像到目標專案的開發分支 ( feature/<branch name> )，並透過分支來雙向溝通原始碼
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Declare variable
SOURCE_REPO_NAME=demo-case-5-S-`date "+%Y%m%d%H%M%S"`
TARGET_REPO_NAME=demo-case-5-T-`date "+%Y%m%d%H%M%S"`
SOURCE_REPO=( DEMO ${SOURCE_REPO_NAME} remote/feature-demo )
TARGET_REPO=( DEMO ${TARGET_REPO_NAME} feature/feature-demo )

# Execute script

## Create test repository
create-project-with-readme ${SOURCE_REPO[1]} ${SOURCE_REPO[0]}
create-project ${TARGET_REPO[1]} ${TARGET_REPO[0]}
retrieve-project

## Mirror repository
git-init-mirror-repository ${SOURCE_REPO[0]} ${SOURCE_REPO[1]} master ${TARGET_REPO[0]} ${TARGET_REPO[1]}

## Initial repository
git-init ${SOURCE_REPO[0]} ${SOURCE_REPO[1]} master
git-init ${TARGET_REPO[0]} ${TARGET_REPO[1]} master

## Create remote branch in source
git-init-branch ${SOURCE_REPO[1]} ${SOURCE_REPO[2]}

## Create feature branch in target, this branch will mirror from remote branch in source
git-init-mirror-branch ${SOURCE_REPO[0]} ${SOURCE_REPO[1]} ${SOURCE_REPO[2]} ${TARGET_REPO[0]} ${TARGET_REPO[1]} ${TARGET_REPO[2]}

## Source to Target
### Initial repository
git-init ${SOURCE_REPO[0]} ${SOURCE_REPO[1]} ${SOURCE_REPO[2]}
### Create content in source repository
cd ${SHELL_GIT_DIR}/${SOURCE_REPO[1]}
echo 1234 > request-function
cd ${SHELL_ROOT_DIR}
### Add commit
git-tree-add-commit ${SOURCE_REPO[1]} "feat: add request-function file"
### Push to target
git-mirrot-branch-source-to-target ${SOURCE_REPO[1]} ${SOURCE_REPO[2]} ${TARGET_REPO[1]} ${TARGET_REPO[2]}

## Target to Source
git-init ${TARGET_REPO[0]} ${TARGET_REPO[1]} ${TARGET_REPO[2]}
### Create content in source repository
cd ${SHELL_GIT_DIR}/${TARGET_REPO[1]}
echo 5678 > request-function
cd ${SHELL_ROOT_DIR}
### Add commit
git-tree-add-commit ${TARGET_REPO[1]} "feat: modify request-function file"
### Push to target
git-mirrot-branch-target-to-source ${SOURCE_REPO[1]} ${SOURCE_REPO[2]} ${TARGET_REPO[1]} ${TARGET_REPO[2]}

## Show master information
git-init ${SOURCE_REPO[0]} ${SOURCE_REPO[1]} ${SOURCE_REPO[2]}
git-info-repo ${SOURCE_REPO[1]}
git-info-repo-log ${SOURCE_REPO[1]} 5
