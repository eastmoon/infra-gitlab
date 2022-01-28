# Declare function

## Colorful echo

## 顯示錯誤訊息
## @function ( MESSAGE )
## @param MESSAGE, 需要顯示的錯誤訊息
function echo-e() {
    echo -e "\033[31m[`date`]\033[0m ${1}"
}
## 顯示處理訊息
## @function ( MESSAGE )
## @param MESSAGE, 需要顯示的處理訊息
function echo-i() {
    echo -e "\033[32m[`date`]\033[0m ${1}"
}
## 顯示警告訊息
## @function ( MESSAGE )
## @param MESSAGE, 需要顯示的警告訊息
function echo-w() {
    echo -e "\033[33m[`date`]\033[0m ${1}"
}

# Filesystem control

## 檔案、目錄複製
## @function ( SOURCE, DESTINATION )
## @param SOURCE, 複製來源檔案、目錄
## @param DESTINATION, 複製目標檔案、目錄
function copy() {
    SOURCE=${1}
    DESTINATION=${2}
    if [ -d ${SOURCE} ];
    then
        [ ! -d ${DESTINATION} ] && mkdir -p ${DESTINATION}
        cp -R ${SOURCE}/* ${DESTINATION}
    fi
}
