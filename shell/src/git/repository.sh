# include shell script

# Declare variable

# Declare function

## 初始化專案
## @function ( GROUP, REPOSITORY, BRANCH)
## @param GROUP, 專案所屬的 GROUP ( 也稱 namespace )
## @param REPOSITORY, 在 Gitlab 中的專案庫名稱
## @param BRANCH, 專案庫初始後切換的分支
function git-init() {
    # Declare variable
    GROUP=${1}
    REPO=${2}
    BRANCH=${3}
    [ -z ${BRANCH} ] && BRANCH=master
    [ ! -d ${REPO_DIR} ] && mkdir -p ${REPO_DIR}
    echo-i "> Init repository ${GROUP}/${REPO}, branch ${BRANCH}"
    # Check repository exist, if not then clone repository from gitlab server.
    cd ${SHELL_GIT_DIR}
    if [ ! -d "${REPO}" ];
    then
        git clone http://${GIT_ACCESS_NAME}:${GIT_ACCESS_TOKEN}@${GIT_SERVER}/${GROUP}/${REPO}
    fi
    # If repository directory exist, then go into repository and update repository.
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        git reset --hard
        git fetch
        git checkout ${BRANCH}
        git pull
    fi
    cd ${SHELL_ROOT_DIR}
}

## 初始化專案分支
## 初始化分支也可以說是基於當前分支，產生一個新的分支並推送至 Git 主機
## @function ( REPOSITORY, BRANCH)
## @param REPOSITORY, 在本地的專案庫名稱
## @param BRANCH, 初始化要產生的分支名稱
function git-init-branch() {
    # Declare variable
    REPO=${1}
    BRANCH=${2}
    echo-i "> Init repository ${REPO} new branch ${BRANCH}"
    # Check repository exist and branch not exist
    cd ${SHELL_GIT_DIR}
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        if [ $(git branch | grep ${BRANCH} | wc -l) -eq 0 ];
        then
            git branch ${BRANCH}
            git push --set-upstream origin ${BRANCH}
        else
            echo-e "Branch is exist"
        fi
    else
        echo-e "Repository not exist"
    fi
    cd ${SHELL_ROOT_DIR}
}

## 刪除分支
## @function ( REPOSITORY, BRANCH )
## @param REPOSITORY, 在本地的專案庫名稱
## @param BRANCH, 初始化要產生的分支名稱
function git-remove-branch() {
    # Declare variable
    REPO=${1}
    BRANCH=${2}
    echo-i "> Remove repository ${REPO} branch ${BRANCH}"
    # Check repository exist
    cd ${SHELL_GIT_DIR}
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        if [ $(git branch | grep ${BRANCH} | wc -l) -eq 1 ];
        then
            git branch -d ${BRANCH}
            git push --delete origin ${BRANCH}
        else
            echo-e "Branch is not exist"
        fi
    fi
    cd ${SHELL_ROOT_DIR}
}
