# Create project with Gitlab API
# https://docs.gitlab.com/ee/api/projects.html#create-project

# include shell script

# Declare variable

# Declare function
function create-project() {
    name=${1}
    group_name=${2}
    group_id=$(jshon -e id < .tmp/group_${group_name})
    data='{"name": "'${name}'", "path": "'${name}'", "namespace_id": "'${group_id}'", "description": "The '${name}' project for group '${group_name}'", "visibility": "private"}'
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/projects" > .log/project_${name}
}

function retrieve-project() {
    ## Retrieve first 1000 project
    curl -s --request GET --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" "http://${GIT_SERVER}/api/v4/projects?pagination=keyset&per_page=1000&order_by=id&simple=true" > .tmp/projects
    for i in $(seq 0 1 $( expr $(jshon -l < .tmp/projects) - 1))
    do
        project_name=$(jshon -e ${i} -e name < .tmp/projects)
        project_name=${project_name//\ }
        project_name=${project_name//\"}
        project_id=$(jshon -e ${i} -e id < .tmp/projects)
        project_id=${project_id//\ }
        project_id=${project_id//\"}
        echo $(jshon -e ${i} < .tmp/projects) > .tmp/project_${project_id}_${project_name}
    done
}
