# include shell script

# Declare variable

# Declare function
function git-init() {
    # Declare variable
    GROUP=${1}
    REPO=${2}
    BRANCH=${3}
    REPO_DIR=$(get-repository-path)
    [ -z ${BRANCH} ] && BRANCH=master
    [ ! -d ${REPO_DIR} ] && mkdir -p ${REPO_DIR}
    echo-i "Init repository ${GROUP}/${REPO}, branch ${BRANCH}"
    # Check repository exist, if not then clone repository from gitlab server.
    cd ${REPO_DIR}
    if [ ! -d "${REPO}" ];
    then
        git clone http://${GIT_ACCESS_TOKEN}@${GIT_SERVER}/${GROUP}/${REPO}
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
    cd ${ROOT_DIR}
}
