# Gitlab 資料建立

以腳本方式建立 Gitlab 的相關資訊，在使用此腳本前，必需自 Root 帳號取得可使用的 Access Token ( Token 稱呼為 admin-shell-token 並存放於 access_token 檔案 )；此腳本共會處裡三類資料

+ 群組
    - Gitlab 的 group 分類，用於歸類專案與用戶可監控專案項目
+ 用戶
    - Gitlab 的 user，提供預設的用戶資料、密碼、無需信件認證，用戶也必需歸類在指定的群組下
+ 專案
    - Gitlab 的 project，提供預設的專案目錄，並歸類在正確的群組下

此腳本需使用 shell 函式庫 [jshon](http://kmkeen.com/jshon/) 以此解析 Gitlab 回應的複雜資料集

# 函式庫

+ conf.sh，定義函式庫的必須參數
+ utils.sh，定義與巨集 linux shell 指令
+ gitlab.sh，定義與巨集 gitlab 操作指令函數
    - info.sh，Gitlab 的系統資訊相關指令
    - groups.sh，Gitlab 的 group 分類相關指令
    - users.sh，Gitlab 的 user 分類相關指令
    - projects.sh，Gitlab 的 project 分類相關指令
+ git.sh，定義與巨集 git 操作指令函數
    - info.sh，Git 對 Repository 資訊相關指令
    - repository.sh，Git 對 Repository 與 Branch 操控指令
    - tree.sh，Git 對 Repository 的 git tree 操控指令

# 腳本

腳本以 Linux Shell Script 撰寫，並利用函式庫的內容來完成對 Gitlab 與 Git 操作

## 0、初始 Access Token

以 Gitlab 的 Ruby on Rails 服務，建立可供 Gitlab API 操作使用的 ACCESS TOKEN。

## 1、初始 Gitlab

依據 Gitlab 專案所需，建立以下主要資訊

+ 群組 ( Group )
+ 用戶 ( User )，並規劃用戶操作群組的權限
+ 專案 ( Project )，並規劃專案所屬群組的關係

## 2、feature、refactor 等開發分支

使用 Git 指令建立開發分支

+ 開發需求分支 ```feature/<branch name>```
+ 開發重構分支 ```refactor/<branch name>```

範例會分別在 feature、refactor 工作，並最後合併回 master 分支

### 2.1、測試分支產生

檢驗 git 功能腳本

+ ```git-init```
+ ```git-init-branch```
+ ```git-tree-add-commit```
+ ```git-info-repo```
+ ```git-info-repo-log```

### 2.2、測試分支刪除

檢驗 git 功能腳本

+ ```git-init```
+ ```git-init-branch```
+ ```git-remove-branch```
+ ```git-info-repo```

## 3、release 分支

使用 Gitlab 指令建立受保護的產品分支

+ 解除舊產品分支 ```master```
+ 設定保護分支白名單 ```release*```
+ 建立產品分支 ```release```

### 3.1、測試分支保護

檢驗 gitlab 功能腳本

+ ```unprotect-branch```
+ ```protect-branch```

逐一確認 unportect branch、protect branch、protect branch white card 的結果

## 4、fix 分支

使用 Git 指令建立維護分支並合併修復內容

+ 建立維護分支 ```fix-release```
+ 修改內容
+ 依序合併分支
    - ```fix-release``` merge to ```master```
    - ```master``` push to ```release```

## 5、鏡像專案與遠程分支

使用 Git 指令鏡像專案，並將專案內容推送至目標專案

+ 建立鏡像專案
    - 將來源專案的原碼樹從自身的主線分支 ( master ) 或特定分支 ( feature/<branch name>) 鏡像到目標專案的主線分支 ( master )
    - 需要注意，目標專案若要推送到主線分支 ( master )，必須為尚未建立主線分支的空專案，例如使用 ```create-project``` 建立的專案
+ 建立遠程分支 ```remote/<branch name>```
    - 將來源專案的原碼樹從自身的遠程分支 ( ```remote/<branch name>``` ) 鏡像到目標專案的開發分支 ( ```feature/<branch name>``` )，並透過分支來雙向溝通原始碼
    - 修改開發分支，合併回來源專案；修改遠程分支，推送回目標專案

原則上，不論是鏡像專案、遠程分支，都是以目標專案為中心在執行相關操作，來源方僅需提供分支與內容。

## 6、子專案

# 參考

+ [Git 入門](https://backlog.com/git-tutorial/tw/)
    - [什麼是分支？](https://backlog.com/git-tutorial/tw/stepup/stepup1_1.html)
    - [分支的切換](https://backlog.com/git-tutorial/tw/stepup/stepup1_3.html)
    - [分支的合并](https://backlog.com/git-tutorial/cn/stepup/stepup1_4.html)
+ 議題參考
    - [解決Git常見錯誤 non-fast-forward問題](https://ithelp.ithome.com.tw/articles/10199000)
    - [聽說 git push -f 這個指令很可怕，什麼情況可以使用它呢？](https://gitbook.tw/chapters/github/using-force-push)
