# Create project with Gitlab API
# https://docs.gitlab.com/ee/api/projects.html#create-project

# Declare variable
export ACCESS_TOKEN < access_token

# Declare function
function create-project() {
    name=${1}
    group_name=${2}
    group_id=$(jshon -e id < .tmp/group_${group_name})
    data='{"name": "'${name}'", "path": "'${name}'", "namespace_id": "'${group_id}'", "description": "The '${name}' project for group '${group_name}'", "visibility": "private"}'
    curl --request POST --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://localhost/api/v4/projects" > .tmp/project_${name}
}

# Execute script
# curl --request GET --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" "http://localhost/api/v4/projects"
[ ! -d ./.tmp ] && mkdir .tmp
create-project ws-core RD
create-project ws-corex RD
create-project ws-corexx RD
create-project ws-corexxX RD
