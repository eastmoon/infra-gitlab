# include shell script

# Declare variable

# Declare function
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

function git-init-branch() {
    # Declare variable
    REPO=${1}
    BRANCH=${2}
    ROOT_DIR=${PWD}
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
