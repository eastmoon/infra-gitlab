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
    #
    echo-i "> Project create ${group_name}/${name}"
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/projects" > .log/project_${name}
}

function create-project-with-readme() {
    name=${1}
    group_name=${2}
    group_id=$(jshon -e id < .tmp/group_${group_name})
    data='{"name": "'${name}'", "path": "'${name}'", "namespace_id": "'${group_id}'", "description": "The '${name}' project for group '${group_name}'", "visibility": "private", "initialize_with_readme": "true"}'
    #
    echo-i "> Project create ${group_name}/${name}"
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/projects" > .log/project_${name}
}

function edit-project-desc() {
    name=${1}
    desc=${2}
    id=$(jshon -e id < .tmp/project_${name})
    data='{"description": "'${desc}'"}'
    #
    echo-i "> Project ${name}, ${id} : Edit ${data}"
    curl -s --request PUT  --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/projects/${id}" > .log/project_${name}-desc

}

function retrieve-project() {
    ## Retrieve first 1000 project
    curl -s --request GET --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" "http://${GIT_SERVER}/api/v4/projects?pagination=keyset&per_page=1000&order_by=id&simple=true" > .tmp/projects
    for i in $(seq 0 1 $( expr $(jshon -l < .tmp/projects) - 1))
    do
        project_name=$(jshon -e ${i} -e name < .tmp/projects)
        project_name=${project_name//\ }
        project_name=${project_name//\"}
        echo $(jshon -e ${i} < .tmp/projects) > .tmp/project_${project_name}
    done
}

function protect-branch-info() {
    name=${1}
    id=$(jshon -e id < .tmp/project_${name})
    id=${id//\ }
    id=${id//\"}
    #
    curl -s --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" \
        "http://${GIT_SERVER}/api/v4/projects/${id}/protected_branches"
}
function protect-branch() {
    name=${1}
    branch=${2}
    id=$(jshon -e id < .tmp/project_${name})
    query="name=${branch}&push_access_level=40&merge_access_level=40&unprotect_access_level=60"
    #
    echo-i "> Project ${name}, ${id} : Protect ${branch} Branch"
    curl -s --request POST  --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" \
        "http://${GIT_SERVER}/api/v4/projects/${id}/protected_branches?${query}" > .log/project_${name}-protect-master-branch
}

function unprotect-branch() {
    name=${1}
    branch=${2}
    id=$(jshon -e id < .tmp/project_${name})
    #
    echo-i "> Project ${name}, ${id} : Unprotect ${branch} Branch"
    curl -s --request DELETE  --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" \
        "http://${GIT_SERVER}/api/v4/projects/${id}/protected_branches/${branch}" > .log/project_${name}-unprotect-master-branch
}
