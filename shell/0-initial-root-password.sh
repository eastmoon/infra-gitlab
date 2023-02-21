## 初始化 Gitlab root 密碼
## Ref : https://docs.gitlab.com/ee/security/reset_user_password.html
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
# Declare variable
source ./src/conf.sh
# Execute script
##
#gitlab-rails runner "PersonalAccessToken.find_by_token('token-string-here123').revoke!"
##
ROOT_PASSWORD='!WDV$ESZ2wsx3edc'
echo-i "Change Root passowrd to ${ROOT_PASSWORD}"
CMD="user = User.find_by_username('root');"
CMD="${CMD} user.password = '${ROOT_PASSWORD}';"
CMD="${CMD} user.password_confirmation = '${ROOT_PASSWORD}';"
CMD="${CMD} user.save!"
echo ${CMD}
gitlab-rails runner "${CMD}"
