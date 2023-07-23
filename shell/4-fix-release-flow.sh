## Git 操作，使用 Git 指令操作符合 github-flow 的分支管理流程
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Declare variable
TEST_REPO_NAME=demo-case-4-`date "+%Y%m%d%H%M%S"`

# Execute script

## Create test repository
create-project-with-readme ${TEST_REPO_NAME} DEMO
retrieve-project

## Setting unportect and protect branch
unprotect-branch ${TEST_REPO_NAME} main
protect-branch ${TEST_REPO_NAME} release*

## Initial repository
git-init DEMO ${TEST_REPO_NAME} main
git-init-branch ${TEST_REPO_NAME} release

## Add content in develop branch
### Add a file
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
echo 1234 > request-function
cd ${SHELL_ROOT_DIR}
### Add commit
git-tree-add-commit ${TEST_REPO_NAME} "feat: add request-function file"

## Push develop branch to release branch
git-tree-rebase-branch ${TEST_REPO_NAME} main release

## Create release fix branch
git-init DEMO ${TEST_REPO_NAME} release
git-init-branch ${TEST_REPO_NAME} fix-release
git-init DEMO ${TEST_REPO_NAME} fix-release

## Modify content
### Add a file
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
echo 4321 > request-function
cd ${SHELL_ROOT_DIR}
### Add commit
git-tree-add-commit ${TEST_REPO_NAME} "fix: request-function file"

## Push fix branch
git-tree-merge-branch ${TEST_REPO_NAME} fix-release main
git-tree-rebase-branch ${TEST_REPO_NAME} main release

## Show main information
git-init DEMO ${TEST_REPO_NAME} main
git-info-repo ${TEST_REPO_NAME}
git-info-repo-log ${TEST_REPO_NAME} 5
