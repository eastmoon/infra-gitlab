## Gitlab 的專案在 CI 佈局的設置，建立開發主線 ( master，unprotect )、產品主線 ( release，protect )
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
