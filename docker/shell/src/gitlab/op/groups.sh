# Create group with Gitlab API
# https://docs.gitlab.com/ee/api/groups.html#new-group

# include shell script

# Declare variable

# Declare function
function create-group() {
    ## create one group by name
    name=${1}
    descript=${2}
    data='{"name": "'${name}'", "path": "'${name}'", "description": "'${descript}'", "visibility": "private"}'
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/groups" > .log/group_${1}
}

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
