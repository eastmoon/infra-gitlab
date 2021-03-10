# Create user with Gitlab API
# https://docs.gitlab.com/ee/api/users.html#user-creation
# https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project

# Declare variable
export ACCESS_TOKEN < access_token

# Declare function
function create-user() {
    name=${1}
    email=${2}
    data='{"name": "'${name}'","username": "'${name}'", "email": "'${email}'", "password": "1234qwer", "can_create_group": "false", "skip_confirmation": "true"}'
    curl --request POST --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" --header "Content-Type: application/json" \
        --data "${data}" \
        "http://localhost/api/v4/users" > .tmp/user_${name}
}

function add-group() {
    user=${1}
    group=${2}
    user_id=$(jshon -e id < .tmp/user_${user})
    group_id=$(jshon -e id < .tmp/group_${group})
    curl --request POST --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" \
        --data "user_id=${user_id}&access_level=30" \
        "http://localhost/api/v4/groups/${group_id}/members" > .tmp/user_${user}_to_${group}

}

# Execute script
[ ! -d ./.tmp ] && mkdir .tmp
#create-user testA testA@testmail.com
add-group testA RD
add-group testA PM
add-group testA QA
#create-user testB testB@testmail.com
add-group testB RD
#create-user testC testC@testmail.com
add-group testC PM
#create-user testD testD@testmail.com
add-group testD QA
