## Git 議題：搜尋有效的最後合併 Commit
## 假設有兩個開發分支 A 與 B，A 先更新之後 B 更新，但 B 先合併、A 合併
## 這假設是考量有個分支開發完成，但因為未完成驗證遲遲未合併，最後合併導致 Merge commit 指向的 commit 會在之前合併進來的 commit 之後
## 考量自動化處理機制，為合併衝突產生無效操作，Merge 指令一律使用 non-fast-forward 模式進行合併
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
git-init-branch ${TEST_REPO_NAME} feature/A
git-init-branch ${TEST_REPO_NAME} feature/B
git-init-branch ${TEST_REPO_NAME} feature/C
git-init-branch ${TEST_REPO_NAME} release

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

## New feature in A
### Add a file and commit
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout feature/C
echo 1234 > C1
cd ${SHELL_ROOT_DIR}
git-tree-add-commit ${TEST_REPO_NAME} "feat: add C1 file"

## New feature in B
### Add a file and commit
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout feature/B
echo 1234 > B2
cd ${SHELL_ROOT_DIR}
git-tree-add-commit ${TEST_REPO_NAME} "feat: add B2 file"

## Merge feature
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
git checkout main
git merge --no-ff -m "Merge branch 'feature/C' into 'main'" feature/C
git merge --no-ff -m "Merge branch 'feature/B' into 'main'" feature/B
git merge --no-ff -m "Merge branch 'feature/A' into 'main'" feature/A
git push
git checkout release
git merge --no-ff -m "Merge branch 'main' into 'release'" main
git push
git checkout main
git merge --no-ff -m "Merge branch 'release' into 'main'" release
git push

## Show main information
cd ${SHELL_GIT_DIR}/${TEST_REPO_NAME}
echo "---------- git log ----------"
git log --pretty=format:'%H %P : %s' | tr -d '~'

### 考量本次議題，若要搜尋最後的有效變更內容，並考量上述兩個設計議題，對此邏輯應如下所述：
### 1. 若最後的 Commit 為非 Merge Commit 則為有效變更內容
### 2. 若最後的 Commit 為 Merge Commit，搜尋最後指向非 Merge Commit 的 Merge Commit
### 3. 指向 Merge Commit 的 Merge Commit 應被忽略
function issue-solution() {
    git reset --hard origin/HEAD
    [[ "$(git rev-list -n 1 HEAD)" = "$(git rev-list --no-merges -n 1 HEAD)" ]] && git rev-list -n 1 HEAD || git log --merges --pretty=format:'%H %P' | awk '{print $1,$3}' | grep "$(git rev-list --no-merges -n 50 HEAD | tr '\n' ' ' | sed 's/.$//' | sed 's/ /\\\|/g')" | head -n 1 | awk '{print $1}'
}
echo "---------- issue-solution ----------"
issue-solution
