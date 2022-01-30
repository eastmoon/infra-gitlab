## Git 操作，使用 Git 指令建立開發分支
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Declare variable
TEST_REPO_NAME=demo-case-2-`date "+%Y%m%d%H%M%S"`

# Execute script
## Create test repository
create-project-with-readme ${TEST_REPO_NAME} DEMO
## Clone repository
rm -rf ${SHELL_GIT_DIR}/demo-case-2-*
git-init DEMO ${TEST_REPO_NAME} master

## Create develop branch "feature/request-function"
git-init-branch ${TEST_REPO_NAME} feature/request-function
git-init DEMO ${TEST_REPO_NAME} feature/request-function
### Add a file
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
echo 1234 > request-function
cd ${SHELL_ROOT_DIR}
### Add commit
git-tree-add-commit ${TEST_REPO_NAME} "feat: add request-function file"
### Merge feature to master
git-tree-merge-branch ${TEST_REPO_NAME} feature/request-function master
### Remove feature branch
git-remove-branch ${TEST_REPO_NAME} feature/request-function

## Create refactor branch "refactor/remove-function"
git-init-branch ${TEST_REPO_NAME} refactor/remove-function
git-init DEMO ${TEST_REPO_NAME} refactor/remove-function
### Remove file
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
rm request-function
cd ${SHELL_ROOT_DIR}
### Add commit
git-tree-add-commit ${TEST_REPO_NAME} "feat: delete request-function file"
### Merge refactor to master
git-tree-merge-branch ${TEST_REPO_NAME} refactor/remove-function master
### Remove refactor branch
git-remove-branch ${TEST_REPO_NAME} refactor/remove-function

## Show master information
git-info-repo ${TEST_REPO_NAME}
git-info-repo-log ${TEST_REPO_NAME} 5
