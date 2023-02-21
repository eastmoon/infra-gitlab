# Create user with Gitlab API
# https://docs.gitlab.com/ee/api/users.html#user-creation
# https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project

# include shell script

# Declare variable

# Declare function
## 建立用戶
## @function ( NAME, MAIL )
## @param NAME, 用戶名稱
## @param MAIL, 用戶信箱
function create-user() {
    name=${1}
    email=${2}
    data='{"name": "'${name}'","username": "'${name}'", "email": "'${email}'", "password": "ssap!2#4", "can_create_group": "false", "skip_confirmation": "true"}'
    #
    echo-i "> User create ${name}, ${email}"
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/users" > .log/user_${name}
}

## 建立管理用戶
## @function ( NAME, MAIL )
## @param NAME, 用戶名稱
## @param MAIL, 用戶信箱
function create-admin() {
    name=${1}
    email=${2}
    data='{"name": "'${name}'","username": "'${name}'", "email": "'${email}'", "password": "1234qwer", "admin": "true", "can_create_group": "true", "skip_confirmation": "true"}'
    #
    echo-i "> Admin user create ${name}, ${email}"
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/users" > .log/user_${name}
}


## 取回用戶列表，並存入 .tmp/users，與拆解單一用戶資訊至 .tmp/user_<NAME>
function retrieve-user() {
    ## Retrieve all group information
    curl -s --request GET --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" "http://${GIT_SERVER}/api/v4/users" > .tmp/users
    for i in $(seq 0 1 $( expr $(jshon -l < .tmp/users) - 1))
    do
        user_name=$(jshon -e ${i} -e name < .tmp/users)
        user_name=${user_name//\ }
        user_name=${user_name//\"}
        echo $(jshon -e ${i} < .tmp/users) > .tmp/user_${user_name}
    done
}

## 增加用戶至群組
## @function ( USER-NAME, GROUP-NAME, ACCESS_LEVEL )
## @param USER-NAME, 用戶名稱
## @param GROUP-NAME, 群組名稱
## @param ACCESS_LEVEL, 存取等級, 參考 : https://docs.gitlab.com/ee/api/access_requests.html
function add-user-to-group() {
    user=${1}
    group=${2}
    level=${3}
    [ -z ${level} ] && level=30
    user_id=$(jshon -e id < .tmp/user_${user})
    group_id=$(jshon -e id < .tmp/group_${group})
    #
    echo-i "> User ${user} add to group ${group} with access level ${level}"
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" \
        --data "user_id=${user_id}&access_level=${level}" \
        "http://${GIT_SERVER}/api/v4/groups/${group_id}/members" > .log/user_${user}_to_${group}
}
