# Create group with Gitlab API
# https://docs.gitlab.com/ee/api/groups.html#new-group

# Declare variable
export ACCESS_TOKEN < access_token

# Declare function
function create-group() {
    name=${1}
    descript=${2}
    data='{"name": "'${name}'", "path": "'${name}'", "description": "'${descript}'", "visibility": "private"}'
    curl --request POST --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://localhost/api/v4/groups" > .tmp/group_${1}
}
# Execute script
[ ! -d ./.tmp ] && mkdir .tmp
create-group RD "This group for development repository."
create-group PM "This group for project management repository."
create-group QA "This group for quality assurance repository."
