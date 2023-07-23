## 初始化 Gitlab Token 資訊
## Ref : https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html
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
echo-i "Check Personal Access Token ${GIT_ACCESS_NAME} : ${GIT_ACCESS_TOKEN}"
CMD="if User.find_by_username('root').personal_access_tokens.find_by_token('${GIT_ACCESS_TOKEN}').nil? ;"
CMD="${CMD} p '${GIT_ACCESS_NAME} not exist.' ;"
CMD="${CMD} else ;"
CMD="${CMD} p '${GIT_ACCESS_NAME} exist.' ;"
CMD="${CMD} end"

gitlab-rails runner "${CMD}"
##
#echo-i "Generate access_token file"
#echo ${GIT_ACCESS_TOKEN} > access_token
##
#echo-i "Test Personal Access Token"
#source ./src/gitlab.sh
#echo-i $(gitlab-version)
