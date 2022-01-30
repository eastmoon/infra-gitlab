# Create project with Gitlab API
# https://docs.gitlab.com/ee/api/projects.html

# include shell script

# Declare variable

# Declare function
## 建立專案，此專案為完全空白
## 專案 ( Project ) 等於 Git 中的儲存庫 ( Repository )
## @function ( NAME, GROUP )
## @param NAME, 專案名稱
## @param GROUP, 群組名稱, 在 Gitlab 也稱為 Namespace
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

## 建立專案，並預設一個 readme.md 文檔
## 專案 ( Project ) 等於 Git 中的儲存庫 ( Repository )
## @function ( NAME, GROUP )
## @param NAME, 專案名稱
## @param GROUP, 群組名稱, 在 Gitlab 也稱為 Namespace
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

function delete-project() {
    name=${1}
    id=$(jshon -e id < .tmp/project_${name})
    id=${id//\ }
    id=${id//\"}
    #
    echo-i "> Project delete ${name}"
    curl -s --request DELETE --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" \
        "http://${GIT_SERVER}/api/v4/projects/${id}" > .log/project_delete_${name}
}

function delete-project-with-name() {
    name=${1}
    for filename in $(ls .tmp/project_${name})
    do
        project_name=$(jshon -e name < ${filename})
        project_name=${project_name//\ }
        project_name=${project_name//\"}
        delete-project ${project_name}
        rm ${filename}
    done

}

## 編輯專案描述
## 專案 ( Project ) 等於 Git 中的儲存庫 ( Repository )
## @function ( NAME, DESCRIPT )
## @param NAME, 專案名稱
## @param DESCRIPT, 專案描述
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

## 取回專案列表，並存入 .tmp/projects，與拆解單一專案資訊至 .tmp/project_<NAME>
## 專案取回要提供 per_page 參數，已設定取回的數量；此函數預設取回 1000 個專案清單。
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

## 保護分支資訊
## @function ( NAME )
## @param NAME, 專案名稱
function protect-branch-info() {
    name=${1}
    id=$(jshon -e id < .tmp/project_${name})
    id=${id//\ }
    id=${id//\"}
    #
    curl -s --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" \
        "http://${GIT_SERVER}/api/v4/projects/${id}/protected_branches"
}

## 保護分支
## @function ( NAME, BRANCH )
## @param NAME, 專案名稱
## @param BRANCH, 分支名稱或白名單文字 ( White Card )
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

## 解除保護分支
## @function ( NAME, BRANCH )
## @param NAME, 專案名稱
## @param BRANCH, 分支名稱或白名單文字 ( White Card )
function unprotect-branch() {
    name=${1}
    branch=${2}
    id=$(jshon -e id < .tmp/project_${name})
    #
    echo-i "> Project ${name}, ${id} : Unprotect ${branch} Branch"
    curl -s --request DELETE  --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" \
        "http://${GIT_SERVER}/api/v4/projects/${id}/protected_branches/${branch}" > .log/project_${name}-unprotect-master-branch
}
