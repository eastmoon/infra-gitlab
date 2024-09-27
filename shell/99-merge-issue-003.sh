## Git 議題：搜尋有效的最後合併 Commit
## 假設有兩個開發分支 A，在合併後在 main 上直接修復程式
## 考量自動化處理機制，為合併衝突產生無效操作，Merge 指令一律使用 non-fast-forward 模式進行合併
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh
source ./src/git.sh

# Declare function
function issue-solution-oneline() {
    [[ "$(git rev-list -n 1 HEAD)" = "$(git rev-list --no-merges -n 1 HEAD)" ]] && git rev-list -n 1 HEAD || git log --merges --pretty=format:'%H %P' | awk '{print $1,$3}' | grep "$(git rev-list --no-merges -n 50 HEAD | tr '\n' ' ' | sed 's/.$//' | sed 's/ /\\\|/g')" | head -n 1 | awk '{print $1}'
}
function issue-solution() {
    VALID_COMMIT_ID=
    ## 取回有效 commit，其規則基於以下要件
    ### 1. 若最新的 Commit 為非 Merge Commit 則為有效變更內容
    ### 2. 若最新的 Commit 為 Merge Commit，搜尋最後指向非 Merge Commit 的 Merge Commit
    ### 3. 指向 Merge Commit 的 Merge Commit 應被忽略
    if [[ "$(git rev-list -n 1 HEAD)" = "$(git rev-list --no-merges -n 1 HEAD)" ]]; then
        ## 當前最新的 commit 是非 merge commit，直接使用最新的 commit id
        VALID_COMMIT_ID=$(git rev-list -n 1 HEAD)
    else
        ## 取回 50 筆非 merge commit 資訊，並組成分辨清單字串
        ## 取回所有 merge commit，並且第三資訊存在於前分辨清單字串，則保留該 merge commit
        ## 自保留的 merge commit 取最新一筆為記錄
        NO_MERGE_LIST=$(git rev-list --no-merges -n 50 HEAD | tr '\n' ' ' | sed 's/.$//' | sed 's/ /\\\|/g')
        VALID_COMMIT_ID=$(git log --merges --pretty=format:'%H %P' | awk '{print $1,$3}' | grep "${NO_MERGE_LIST}" | head -n 1 | awk '{print $1}')
        ## 若有效 commit 為 Merge Commit，檢查有效 commit 是否本身有 tag 或指向有 tag 的 commit，若為事實，則有 tag 的 commit 即為有效 commit
        LAST_TAG_INFO=$(git rev-list --tags -n 1)
        if [ ! -z ${LAST_TAG_INFO} ] && [ $(git show --pretty=format:'%P' ${VALID_COMMIT_ID} | grep ${LAST_TAG_INFO} | wc -l) -gt 0 ]; then
            VALID_COMMIT_ID=${LAST_TAG_INFO}
        fi
    fi
    echo ${VALID_COMMIT_ID}
}

# Declare variable
TEST_REPO_NAME=demo-merge-issue-001-`date "+%Y%m%d%H%M%S"`

# Execute script
## Create test repository
create-project-with-readme ${TEST_REPO_NAME} DEMO
## Clone repository
git-init DEMO ${TEST_REPO_NAME}

## Create develop branch "feature/A" and "feature/B"
git-init-branch ${TEST_REPO_NAME} feature/A
git-init-branch ${TEST_REPO_NAME} release

## New feature in A
### Add a file and commit
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout feature/A
echo 1234 > A1
cd ${SHELL_ROOT_DIR}
git-tree-add-commit ${TEST_REPO_NAME} "feat: add A1 file"

## Merge feature
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout main
git merge --no-ff -m "Merge branch 'feature/A' into 'main'" feature/A
git push

## Modify content
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout main
echo 4567 > A1
cd ${SHELL_ROOT_DIR}
git-tree-add-commit ${TEST_REPO_NAME} "feat: modify A1 file"

## Show main information
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
echo "---------- git log ----------"
git reset --hard origin/HEAD
git log --pretty=format:'%H %P : %s' | tr -d '~'
echo ""
echo "---------- issue-solution ----------"
issue-solution
git tag 0001 $(issue-solution)

## Merge to release and back to main
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout release > /dev/null 2>&1
git merge --no-ff -m "Merge branch 'main' into 'release'" main > /dev/null 2>&1
git push > /dev/null 2>&1
git checkout main > /dev/null 2>&1
git merge --no-ff -m "Merge branch 'release' into 'main'" release > /dev/null 2>&1
git push > /dev/null 2>&1

## Show main information
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
echo "---------- git log ----------"
git reset --hard origin/HEAD
git log --pretty=format:'%H %P : %s' | tr -d '~'
echo ""
echo "---------- issue-solution ----------"
issue-solution
