## 初始化 Gitlab 專案的主要資訊，以此方式建立並確保可重複執行整個設置行為
#!/bin/bash
set -e

# Include library
source ./src/utils.sh
source ./src/gitlab.sh

# Execute script
## Retrieve gitlab version infromation
echo-i $(gitlab-version)

## Retrieve 1000 project information
retrieve-project

## Remove case 2
delete-project-with-name demo-case-2-*
delete-project-with-name test-case-2*

## Remove case 3
delete-project-with-name demo-case-3-*
delete-project-with-name test-case-3*

## Remove case 4
delete-project-with-name demo-case-4-*

## Remove case 5
delete-project-with-name demo-case-5-*
