# Import configuration
MODULES_DIRECTORY=$(dirname ${BASH_SOURCE})
source ${MODULES_DIRECTORY}/conf.sh
# Detect execute condition
if [ -e access_token ];
then
    GIT_ACCESS_TOKEN=$(cat access_token)
    echo-i "Git library paramter"
    echo-i GIT_ACCESS_NAME=${GIT_ACCESS_NAME}
    echo-i GIT_ACCESS_TOKEN=${GIT_ACCESS_TOKEN}
    echo-i GIT_SERVER=${GIT_SERVER}
else
    echo-e ERROR : access_token was not find, please run 0-initial-token.sh.
    exit 1
fi
# Declare variable for directory path
export SHELL_ROOT_DIR=${PWD}
export SHELL_GIT_DIR=${SHELL_ROOT_DIR}/.git
[ ! -d ${SHELL_GIT_DIR} ] && mkdir -p ${SHELL_GIT_DIR}
# Declare git global variable
## Ref : Git 環境設定 小技巧, https://clouding.city/git/tips/
## Ref : 使用 git rebase 避免無謂的 merge, https://ihower.tw/blog/archives/3843
## Ref : Why You Should Use git pull –ff-only, https://blog.sffc.xyz/post/185195398930
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_MAIL}"
git config --global pull.rebase true    # git pull allow use --rebase
git config --global pull.ff only        # fast-forward only
# include shell script
MODULES_DIRECTORY=$(dirname ${BASH_SOURCE})
. ${MODULES_DIRECTORY}/git/info.sh
. ${MODULES_DIRECTORY}/git/repository.sh
. ${MODULES_DIRECTORY}/git/tree.sh
