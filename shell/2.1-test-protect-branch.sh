## Gitlab 專案對於分支保護 ( Protect Branch ) 設定
#!/bin/bash
set -e
# Include library
source ./src/utils.sh
source ./src/gitlab.sh

# Execute script
## Retrieve gitlab version infromation
echo-i $(gitlab-version)

## Setting protect branch
retrieve-project
unprotect-branch ws-core master
unprotect-branch ws-corex master
unprotect-branch ws-corexx master
protect-branch ws-corex release*
protect-branch ws-corexx master
echo-i $(protect-branch-info ws-core)
echo-i $(protect-branch-info ws-corex)
echo-i $(protect-branch-info ws-corexx)
