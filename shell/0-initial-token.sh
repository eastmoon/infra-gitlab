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
echo-i "Create Personal Access Token ${GIT_ACCESS_NAME} : ${GIT_ACCESS_TOKEN}"
CMD="token = User.find_by_username('root').personal_access_tokens.create(scopes: [:api, :read_user, :read_api, :read_repository, :write_repository, :sudo], name: '${GIT_ACCESS_NAME}', expires_at: 365.days.from_now); "
CMD="${CMD} token.set_token('${GIT_ACCESS_TOKEN}');"
CMD="${CMD} token.save!"
gitlab-rails runner "${CMD}"
##
echo-i "Generate access_token file"
echo ${GIT_ACCESS_TOKEN} > access_token
##
echo-i "Test Personal Access Token"
source ./src/gitlab.sh
echo-i $(gitlab-version)
