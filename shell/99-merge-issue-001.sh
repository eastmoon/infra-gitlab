## Git 操作，使用 Git 指令建立開發分支
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Declare variable
TEST_REPO_NAME=demo-merge-issue-001-`date "+%Y%m%d%H%M%S"`

# Execute script
## Create test repository
create-project-with-readme ${TEST_REPO_NAME} DEMO
## Clone repository
git-init DEMO ${TEST_REPO_NAME}

## Create develop branch "feature/A" and "feature/B"
git-init DEMO ${TEST_REPO_NAME} main
git-init-branch ${TEST_REPO_NAME} feature/A
git-init DEMO ${TEST_REPO_NAME} main
git-init-branch ${TEST_REPO_NAME} feature/B

## New feature in A
### Add a file and commit
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout feature/A
echo 1234 > A1
cd ${SHELL_ROOT_DIR}
git-tree-add-commit ${TEST_REPO_NAME} "feat: add A1 file"

## New feature in B
### Add a file and commit
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout feature/B
echo 1234 > B1
cd ${SHELL_ROOT_DIR}
git-tree-add-commit ${TEST_REPO_NAME} "feat: add B1 file"

## Merge feature
git-tree-merge-branch ${TEST_REPO_NAME} feature/A main
git-tree-merge-branch ${TEST_REPO_NAME} feature/B main

## Show main information
#git-info-repo ${TEST_REPO_NAME}
#git-info-repo-log ${TEST_REPO_NAME} 5
