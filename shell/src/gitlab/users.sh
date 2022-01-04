# Create user with Gitlab API
# https://docs.gitlab.com/ee/api/users.html#user-creation
# https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project

# include shell script

# Declare variable

# Declare function
function create-user() {
    name=${1}
    email=${2}
    data='{"name": "'${name}'","username": "'${name}'", "email": "'${email}'", "password": "1234qwer", "can_create_group": "false", "skip_confirmation": "true"}'
    #
    echo-i "> User create ${name}, ${email}"
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://${GIT_SERVER}/api/v4/users" > .log/user_${name}
}

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

function add-group() {
    user=${1}
    group=${2}
    level=${3}
    [ ! -z ${level} ] && level=30
    user_id=$(jshon -e id < .tmp/user_${user})
    group_id=$(jshon -e id < .tmp/group_${group})
    #
    echo-i "> User ${user} add group ${group}"
    curl --silent --show-error --request POST --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" \
        --data "user_id=${user_id}&access_level=${level}" \
        "http://${GIT_SERVER}/api/v4/groups/${group_id}/members" > .log/user_${user}_to_${group}

}
