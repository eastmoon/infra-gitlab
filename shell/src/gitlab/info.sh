# include shell script

# Declare variable

# Declare function

## 取得 Gitlab Server 版本資訊
## Get gitlab version information, https://docs.gitlab.com/ee/api/version.html#version-api
function gitlab-version() {
    curl --silent --show-error --header "PRIVATE-TOKEN: ${GIT_ACCESS_TOKEN}" "http://${GIT_SERVER}/api/v4/version"
}
