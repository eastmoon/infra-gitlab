## Git 操作，藉由 git-init 下載並切換專案分支，並由當前分支在建立新分支
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/git.sh

# Execute script
## Remove legacy repository
cd ${SHELL_GIT_DIR}
[ -d ws-core ] && rm -rf ws-core
## Clone repository
git-init RD ws-core master
## Create new branch "feature/demo-1"
git-init-branch ws-core feature/demo-1
git-init RD ws-core feature/demo-1
## Add a file
cd ${SHELL_GIT_DIR}/ws-core
echo 1234 > demofile-`date "+%Y%m%d%H%M%S"`
git add .
git commit -m"feat: new demo file"
git push
cd ${SHELL_ROOT_DIR}
# Clone new branch "feature/demo-2"
git-init-branch ws-core feature/demo-2
