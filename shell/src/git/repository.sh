# include shell script

# Declare variable

# Declare function

## Git 網址
## @function ( GROUP, REPOSITORY, BRANCH)
## @param GROUP, 專案所屬的 GROUP ( 也稱 namespace )
## @param REPOSITORY, 在 Gitlab 中的專案庫名稱
function git-address() {
    # Declare variable
    GROUP=${1}
    REPO=${2}
    echo http://${GIT_ACCESS_NAME}:${GIT_ACCESS_TOKEN}@${GIT_SERVER}/${GROUP}/${REPO}
}

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
        git clone $(git-address ${GROUP} ${REPO})
    fi
    # If repository directory exist, then go into repository and update repository.
    if [ -d "${REPO}" ];
    then
        cd ${REPO}
        git reset --hard
        git fetch
        # If branch exist, then checkout to branch
        if [ $(git branch | grep ${BRANCH} | wc -l) -eq 1 ];
        then
            git checkout ${BRANCH}
            git pull
        else
            echo-e "Branch ${BRANCH} is not exist"
        fi
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
            echo-e "Branch ${BRANCH} is exist"
        fi
    else
        echo-e "Repository ${REPO} is not exist"
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
            echo-e "Branch ${BRANCH} is not exist"
        fi
    fi
    cd ${SHELL_ROOT_DIR}
}

## 鏡像專案，設定目標專案主線 ( master ) 為來源專案的分支內容
## @function ( SOURCE_GROUP, SOURCE_REPOSITORY, SOURCE_BRANCH, TARGET_GROUP, TARGET_REPOSITORY, TARGET_BRANCH )
## @param SOURCE_GROUP, 鏡像來源專案的群組名稱
## @param SOURCE_REPOSITORY, 鏡像來源專案的專案名稱
## @param SOURCE_BRANCH, 鏡像來源專案的分支名稱
## @param TARGET_GROUP, 鏡像目標專案的群組名稱
## @param TARGET_REPOSITORY, 鏡像目標專案的專案名稱
## @param TARGET_BRANCH, 鏡像目標專案的分支名稱
function git-init-mirror-repository() {
    SOURCE_GROUP=${1}
    SOURCE_REPOSITORY=${2}
    SOURCE_BRANCH=${3}
    TARGET_GROUP=${4}
    TARGET_REPOSITORY=${5}
    TARGET_BRANCH=master

    # Mirror branch to target branch
    git-init-mirror-branch ${SOURCE_GROUP} ${SOURCE_REPOSITORY} ${SOURCE_BRANCH} ${TARGET_GROUP} ${TARGET_REPOSITORY} ${TARGET_BRANCH}

    # Remove remote branch
    cd ${SHELL_GIT_DIR}
    if [ -d ${TARGET_REPOSITORY} ];
    then
        cd ${TARGET_REPOSITORY}
        git remote remove GITLAB-${SOURCE_REPOSITORY}
    fi
    cd ${SHELL_ROOT_DIR}
}

## 鏡像分支，將來源專案為的分支內容，推送到到目標專案的指定分支
## @function ( SOURCE_GROUP, SOURCE_REPOSITORY, SOURCE_BRANCH, TARGET_GROUP, TARGET_REPOSITORY, TARGET_BRANCH )
## @param SOURCE_GROUP, 鏡像來源專案的群組名稱
## @param SOURCE_REPOSITORY, 鏡像來源專案的專案名稱
## @param SOURCE_BRANCH, 鏡像來源專案的分支名稱
## @param TARGET_GROUP, 鏡像目標專案的群組名稱
## @param TARGET_REPOSITORY, 鏡像目標專案的專案名稱
## @param TARGET_BRANCH, 鏡像目標專案的分支名稱
function git-init-mirror-branch() {
    SOURCE_GROUP=${1}
    SOURCE_REPOSITORY=${2}
    SOURCE_BRANCH=${3}
    TARGET_GROUP=${4}
    TARGET_REPOSITORY=${5}
    TARGET_BRANCH=${6}
    echo-i "> Mirror repository ${SOURCE_GROUP}/${SOURCE_REPOSITORY} : ${SOURCE_BRANCH} to ${TARGET_GROUP}/${TARGET_REPOSITORY} : ${TARGET_BRANCH}"

    # Initial target repository
    git-init ${TARGET_GROUP} ${TARGET_REPOSITORY} ${TARGET_BRANCH}

    # Use remote branch to include soruce branch content
    cd ${SHELL_GIT_DIR}
    if [ -d ${TARGET_REPOSITORY} ];
    then
        # upgrade repo
        cd ${TARGET_REPOSITORY}
        git fetch

        # add remote branch
        git remote add -t ${SOURCE_BRANCH} GITLAB-${SOURCE_REPOSITORY} $(git-address ${SOURCE_GROUP} ${SOURCE_REPOSITORY})
        git fetch GITLAB-${SOURCE_REPOSITORY}
        git checkout remotes/GITLAB-${SOURCE_REPOSITORY}/${SOURCE_BRANCH}

        # create new branch by remote branch
        git branch ${TARGET_BRANCH}
        git push --set-upstream origin ${TARGET_BRANCH}
    else
        echo-e "${TARGET_REPOSITORY} is not exist"
    fi
    cd ${SHELL_ROOT_DIR}
}

## 鏡像分支的來源內容推送至目標
## @function ( SOURCE_GROUP, SOURCE_REPOSITORY, SOURCE_BRANCH, TARGET_GROUP, TARGET_REPOSITORY, TARGET_BRANCH )
## @param SOURCE_REPOSITORY, 鏡像來源專案的專案名稱
## @param SOURCE_BRANCH, 鏡像來源專案的分支名稱
## @param TARGET_REPOSITORY, 鏡像目標專案在本地的專案庫名稱
## @param TARGET_BRANCH, 鏡像目標專案的分支名稱
## NOTE : 使用 upstream 必須確保來源或目標擁有相同的原始碼樹
function git-mirrot-branch-source-to-target() {
    # fun-mirror-repo, use git clone to download repository, and use remote branch to push to new branch.
    SOURCE_REPOSITORY=${1}
    SOURCE_BRANCH=${2}
    TARGET_REPOSITORY=${3}
    TARGET_BRANCH=${4}
    echo-i "> Upstream  : Source ${SOURCE_REPOSITORY} : ${SOURCE_BRANCH} to Target ${TARGET_REPOSITORY} : ${TARGET_BRANCH}"

    # use remote branch to include new local branch
    cd ${SHELL_GIT_DIR}
    if [ -d ${TARGET_REPOSITORY} ];
    then
        # into repo
        cd ${TARGET_REPOSITORY}
        # check branch exist or not
        if [[ -z $(git branch --list ${TARGET_BRANCH}) ]]
        then
            # branch is not exist
            echo-e "${TARGET_BRANCH} is not exist, create mirror branch first."
        else
            # branch is exist, then change upstream and push all commit in source.
            git fetch
            git checkout ${TARGET_BRANCH}
            # downalod source branch and push to remote branch
            git branch -u remotes/GITLAB-${SOURCE_REPOSITORY}/${SOURCE_BRANCH}
            git pull
            git branch -u origin/${TARGET_BRANCH}
            git push
        fi
    else
        echo-e "${TARGET_REPOSITORY} is not exist"
    fi
    cd ${SHELL_ROOT_DIR}
}

## 鏡像分支的目標內容推送至來源
## @function ( SOURCE_GROUP, SOURCE_REPOSITORY, SOURCE_BRANCH, TARGET_GROUP, TARGET_REPOSITORY, TARGET_BRANCH )
## @param SOURCE_REPOSITORY, 鏡像來源專案的專案名稱
## @param SOURCE_BRANCH, 鏡像來源專案的分支名稱
## @param TARGET_REPOSITORY, 鏡像目標專案在本地的專案庫名稱
## @param TARGET_BRANCH, 鏡像目標專案的分支名稱
## NOTE : 使用 upstream 必須確保來源或目標擁有相同的原始碼樹
function git-mirrot-branch-target-to-source() {
    # fun-mirror-repo, use git clone to download repository, and use remote branch to push to new branch.
    SOURCE_REPOSITORY=${1}
    SOURCE_BRANCH=${2}
    TARGET_REPOSITORY=${3}
    TARGET_BRANCH=${4}
    echo "> Upstream  : Target ${TARGET_REPOSITORY} : ${TARGET_BRANCH} to Source ${SOURCE_REPOSITORY} : ${SOURCE_BRANCH}"

    # use remote branch to include new local branch
    cd ${SHELL_GIT_DIR}
    if [ -d ${TARGET_REPOSITORY} ];
    then
        # into repo
        cd ${TARGET_REPOSITORY}
        # check branch exist or not
        if [[ -z $(git branch --list ${TARGET_BRANCH}) ]]
        then
            # branch is not exist, not remote branch can push to source
            echo-e "${TARGET_BRANCH} is not exist, create mirror branch first."
        else
            # branch is exist, then change upstream and push all commit in source.
            git checkout ${TARGET_BRANCH}
            # downalod source branch and push to target branch
            git branch -u origin/${TARGET_BRANCH}
            git pull
            git push GITLAB-${SOURCE_REPOSITORY} HEAD:${SOURCE_BRANCH}
        fi
    else
        echo-e "${TARGET_REPOSITORY} is not exist"
    fi
    cd ${SHELL_ROOT_DIR}
}
