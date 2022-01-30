# include shell script

# Declare variable

# Declare function

## 增添內容
## @function ( REPOSITORY, COMMIT_DESC )
## @param REPOSITORY, 在本地的專案庫名稱
## @param COMMIT_DESC, 本次增添內容的描述
function git-tree-add-commit() {
    # Declare variable
    REPO=${1}
    COMMIT_DESC=${2}
    echo-i "> Add a commit into repository ${REPO}"
    # Check repository exist
    cd ${SHELL_GIT_DIR}
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        git status
        # If changes have not staged, use stash saving, and run fetch & pull
        # ref: https://gitbook.tw/chapters/faq/stash
        # ref: https://stackoverflow.com/questions/35978550
        if [ $(git status | grep "Changes not staged for commit" | wc -l) -eq 1 ];
        then
            git stash
            git fetch
            git pull
            git stash pop
        else
            git fetch
            git pull
        fi
        # Use "add" for unstaged file, "add -u" for staged file
        # ref: https://zlargon.gitbooks.io/git-tutorial/content/file/remove.html
        git add .
        git add -u
        git commit -m"${COMMIT_DESC}"
        git push
    fi
    cd ${SHELL_ROOT_DIR}
}

## 分支合併 ( Merge )
## @function ( REPOSITORY, SOURCE_BRANCH, TARGET_BRANCH )
## @param REPOSITORY, 在本地的專案庫名稱
## @param SOURCE_BRANCH, 來源分支
## @param TARGET_BRANCH, 目標分支
function git-tree-merge-branch() {
    # Declare variable
    REPO=${1}
    SOURCE_BRANCH=${2}
    TARGET_BRANCH=${3}
    echo-i "> Merge repository ${REPO}, branch ${SOURCE_BRANCH} to ${TARGET_BRANCH}"
    # Check repository exist
    cd ${SHELL_GIT_DIR}
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        git checkout ${TARGET_BRANCH}
        git merge ${SOURCE_BRANCH}
        git push
    fi
    cd ${SHELL_ROOT_DIR}
}

## 分支變基 ( Rebase )
## @function ( REPOSITORY, SOURCE_BRANCH, TARGET_BRANCH )
## @param REPOSITORY, 在本地的專案庫名稱
## @param SOURCE_BRANCH, 來源分支
## @param TARGET_BRANCH, 目標分支
function git-tree-rebase-branch() {
    # Declare variable
    REPO=${1}
    SOURCE_BRANCH=${2}
    TARGET_BRANCH=${3}
    echo-i "> Rebase repository ${REPO}, branch ${SOURCE_BRANCH} to ${TARGET_BRANCH}"
    # Check repository exist
    cd ${SHELL_GIT_DIR}
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        git checkout ${TARGET_BRANCH}
        git rebase ${SOURCE_BRANCH}
        git push
    fi
    cd ${SHELL_ROOT_DIR}
}
