# Import configuration
MODULES_DIRECTORY=$(dirname ${BASH_SOURCE})
source ${MODULES_DIRECTORY}/conf.sh
# Detect execute condition
if [ -e access_token ];
then
    GIT_ACCESS_TOKEN=$(cat access_token)
    echo-i "Gitlab library paramter"
    echo-i GIT_ACCESS_NAME=${GIT_ACCESS_NAME}
    echo-i GIT_ACCESS_TOKEN=${GIT_ACCESS_TOKEN}
    echo-i GIT_SERVER=${GIT_SERVER}
else
    echo-e ERROR : access_token was not find, please run 0-initial-token.sh.
    exit 1
fi
# Declare variable for directory path
[ ! -d ./.log ] && mkdir .log
[ ! -d ./.tmp ] && mkdir .tmp
# include shell script
MODULES_DIRECTORY=$(dirname ${BASH_SOURCE})
. ${MODULES_DIRECTORY}/gitlab/info.sh
. ${MODULES_DIRECTORY}/gitlab/groups.sh
. ${MODULES_DIRECTORY}/gitlab/users.sh
. ${MODULES_DIRECTORY}/gitlab/projects.sh
