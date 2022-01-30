# include shell script

# Declare variable

# Declare function

## 取得 Git 專案資訊
## @function ( REPOSITORY )
## @param REPOSITORY, 在本地的專案庫名稱
function git-info-repo() {
    # Declare variable
    REPO=${1}
    echo-i "> Show repository ${REPO} information"
    # Check repository exist
    cd ${SHELL_GIT_DIR}
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        git --version
        git branch -a
        git remote -v
    fi
    cd ${SHELL_ROOT_DIR}
}

## 取得 Git 記錄
## @function ( REPOSITORY, lOG_NUMBER)
## @param REPOSITORY, 在本地的專案庫名稱
## @param lOG_NUMBER, 搜尋最後筆數
function git-info-repo-log() {
    # Declare variable
    REPO=${1}
    NUMBER=${2}
    echo-i "> Show repository ${REPO} last log"
    # Check repository exist
    cd ${SHELL_GIT_DIR}
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        git --version
        git log -n ${NUMBER}
    fi
    cd ${SHELL_ROOT_DIR}
}
