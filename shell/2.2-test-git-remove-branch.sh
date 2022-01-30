## Git 操作，藉由 git-init 下載並切換專案分支，並由當前分支在建立新分支
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Declare variable
TEST_REPO_NAME=test-case-2.2-`date "+%Y%m%d%H%M%S"`

# Execute script
## Create test repository
create-project-with-readme ${TEST_REPO_NAME} QA
## Clone repository
rm -rf ${SHELL_GIT_DIR}/test-case-2.2-*
git-init QA ${TEST_REPO_NAME} master
## Create new branch "feature/demo-1"
git-init-branch ${TEST_REPO_NAME} feature/demo-1
git-info-repo ${TEST_REPO_NAME}
## Create new branch "feature/demo-1"
git-remove-branch ${TEST_REPO_NAME} feature/demo-1
git-info-repo ${TEST_REPO_NAME}
