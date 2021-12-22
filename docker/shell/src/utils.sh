# Declare function

## Colorful echo
function echo-e() {
    echo -e "\033[31m[`date`]\033[0m ${1}"
}
function echo-i() {
    echo -e "\033[32m[`date`]\033[0m ${1}"
}
function echo-w() {
    echo -e "\033[33m[`date`]\033[0m ${1}"
}

# Filesystem control
function copy() {
    SOURCE=${1}
    DESTINATION=${2}
    if [ -d ${SOURCE} ];
    then
        [ ! -d ${DESTINATION} ] && mkdir -p ${DESTINATION}
        cp -R ${SOURCE}/* ${DESTINATION}
    fi
}
