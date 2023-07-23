## Gitlab 專案對於分支保護 ( Protect Branch ) 設定
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Declare variable
TEST_REPO_NAME_1=test-case-3.1-unprotect-main-`date "+%Y%m%d%H%M%S"`
TEST_REPO_NAME_2=test-case-3.1-protect-release-`date "+%Y%m%d%H%M%S"`
TEST_REPO_NAME_3=test-case-3.1-protect-white-card-`date "+%Y%m%d%H%M%S"`

# Execute script
## Create test repository
create-project-with-readme ${TEST_REPO_NAME_1} QA
create-project-with-readme ${TEST_REPO_NAME_2} QA
create-project-with-readme ${TEST_REPO_NAME_3} QA
retrieve-project

## Clone repository
rm -rf ${SHELL_GIT_DIR}/test-case-3.1-*

## Unprotect main
### Setting unprotect
unprotect-branch ${TEST_REPO_NAME_1} main

## Unprotect main and protect release
### Initial repository
git-init QA ${TEST_REPO_NAME_2} main
### Create release branch
git-init-branch ${TEST_REPO_NAME_2} release
### Setting unprotect branch
unprotect-branch ${TEST_REPO_NAME_2} main
### Setting protect branch
protect-branch ${TEST_REPO_NAME_2} release

## Unprotect main and protect white card
### Initial repository
git-init QA ${TEST_REPO_NAME_3} main
### Setting unprotect branch
unprotect-branch ${TEST_REPO_NAME_3} main
### Setting protect branch
protect-branch ${TEST_REPO_NAME_3} release*
### Create release branch
git-init-branch ${TEST_REPO_NAME_3} release
git-init-branch ${TEST_REPO_NAME_3} release-1.0.0.0

## Show protected information
echo-i "> Show repository ${TEST_REPO_NAME_1} protect branch information"
echo-i $(protect-branch-info ${TEST_REPO_NAME_1})
echo-i "> Show repository ${TEST_REPO_NAME_2} protect branch information"
echo-i $(protect-branch-info ${TEST_REPO_NAME_2})
echo-i "> Show repository ${TEST_REPO_NAME_3} protect branch information"
echo-i $(protect-branch-info ${TEST_REPO_NAME_3})
