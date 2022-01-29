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
        git fetch
        git pull
        git add .
        git commit -m"${COMMIT_DESC}"
        git push
    fi
    cd ${SHELL_ROOT_DIR}
}
