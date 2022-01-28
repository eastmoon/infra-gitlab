# Create group with Gitlab API
# https://docs.gitlab.com/ee/api/groups.html#new-group

# include shell script

# Declare variable

# Declare function
## 建立群組
## @function ( NAME, DESCRIPT )
## @param NAME, 群組名稱
## @param DESCRIPT, 群組描述
function create-group() {
    ## create one group by name
    name=${1}
    descript=${2}
    data='{"name": "'${name}'", "path": "'${name}'", "description": "'${descript}'", "visibility": "private"}'
    #
    echo-i "> Group create ${name}, ${descript}"
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/groups" > .log/group_${1}
}

## 取回群組列表，並存入 .tmp/groups，與拆解單一群組資訊至 .tmp/group_<NAME> 
function retrieve-group() {
    ## Retrieve all group information
    curl -s --request GET --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" "http://${GIT_SERVER}/api/v4/groups" > .tmp/groups
    for i in $(seq 0 1 $( expr $(jshon -l < .tmp/groups) - 1))
    do
        group_name=$(jshon -e ${i} -e name < .tmp/groups)
        group_name=${group_name//\ }
        group_name=${group_name//\"}
        echo $(jshon -e ${i} < .tmp/groups) > .tmp/group_${group_name}
    done
}
