# Detect execute condition
if [ -e access_token ];
then
    GIT_ACCESS_TOKEN=$(cat access_token)
    echo-i GIT_ACCESS_NAME=${GIT_ACCESS_NAME}
    echo-i GIT_ACCESS_TOKEN=${GIT_ACCESS_TOKEN}
    echo-i GIT_SERVER=${GIT_SERVER}
else
    echo-e ERROR : access_token was not find, please run 0-initial-token.sh.
    exit 1
fi

export SHELL_ROOT_DIR=${PWD}
export SHELL_GIT_DIR=${SHELL_ROOT_DIR}/.git
[ ! -d ${SHELL_GIT_DIR} ] && mkdir -p ${SHELL_GIT_DIR}
# include shell script
MODULES_DIRECTORY=$(dirname ${BASH_SOURCE})
. ${MODULES_DIRECTORY}/git/repository.sh
