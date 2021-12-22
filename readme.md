# Gitlab


## 指令

+ 啟動虛擬環境
```
dockerw start
```

+ 關閉虛擬環境
```
dockerw down
```

+ 進入容器
```
dockerw into
```

## 設定

Gitlab 的設定可分成在 gitlab.rb 設定和在 Admin 頁面設定 ( 用 root 登入 )，其兩者差別在

+ gitlab.rb 設定偏重在初始化帳戶、加密安全性、關聯服務 ( 軟體 ) 設定
+ Admin 設定偏重在專案資料、使用者帳戶等，偏重在 git 相關指令的細項參數管理

需注意，Admin 設定可使用 backup 備份，但 gitlab.rb 並不包括在其中

## 操作

+ [備份、重建](https://docs.gitlab.com/ee/raketasks/backup_restore.html)
+ [帳號與權限](./shell/readme.md)
+ [專案管理](./shell/readme.md)

## 議題

### Gitlab runner

提供 Gitlab CI/CD 的執行環境，其原始設計為使用外部主機、亦可自行建立主機並提供算力，供其運作。

+ Gitlab document
    - [Run GitLab Runner in a container](https://docs.gitlab.com/runner/install/docker.html)
    - [Registering runners](https://docs.gitlab.com/runner/register/index.html#docker)
+ 文獻
    - [Gitlab-CI 入門實作 — 自動化部署篇](https://medium.com/nick-%E5%B7%A5%E7%A8%8B%E5%B8%AB%E5%AD%B8%E7%BF%92%E8%A8%98/%E6%95%99%E5%AD%B8-gitlab-ci-%E5%85%A5%E9%96%80%E5%AF%A6%E4%BD%9C-%E8%87%AA%E5%8B%95%E5%8C%96%E9%83%A8%E7%BD%B2%E7%AF%87-ci-cd-%E7%B3%BB%E5%88%97%E5%88%86%E4%BA%AB%E6%96%87-cbb5100a73d4)
    - [Gitlab CI/CD 簡單介紹](https://kheresy.wordpress.com/2019/02/13/gitlab-ci-cd/)
    - [Gitlab CI/CD 介紹與 Runner 的架設](https://sean22492249.medium.com/gitlab-ci-cd-%E4%BB%8B%E7%B4%B9%E8%88%87-runner-%E7%9A%84%E6%9E%B6%E8%A8%AD-afdbde9f22aa)


簡單說明流程：

+ 安裝 gitlabe runner 在提供 CI / CD 運作的環境主機，可以區分為本機軟體或容器服務兩種
+ 使用 ```gitlab-runner register``` 指令將主機與 gitlab 主機註冊
    - 註冊可區分為單一專案、單一群組、共享等方式
    - 若並非所有專案皆需要，則可使用單一專案測試
    - 注意，在填寫註冊資料時會詢問 tag，這會直接影響到當前專案是否可執行的條件，若要避免問題可以在 Runner 中設定無視 tag

總體而言，Gitlab runner 可以用於替代 Jenkins 的運作，並以此設計編譯、封裝服務；但需注意，原則上 Gitlab runner 的運作同樣採用獨立服務容器的運作方式，但這樣是否會導致部屬內容不如預期，此方面則需考量設計需要。

### Gitlab page

提供 Gitlab CI/CD 完成後，另其結果彙整並輸出到靜態網頁。

+ Gitlab document
    - [GitLab Pages](https://docs.gitlab.com/ce/user/project/pages/)
    - [GitLab Pages administration](https://docs.gitlab.com/ee/administration/pages/index.html)
+ 文獻
    - [Hosting on GitLab.com with GitLab Pages](https://about.gitlab.com/blog/2016/04/07/gitlab-pages-setup/)
    - [GitLab: Project Wiki & GitLab Pages](https://ithelp.ithome.com.tw/articles/10223232)

總體而言，Gitlab page 是一個用來呈現結果的靜態頁面服務，依據其說明亦可使用容器來提供網頁使用；但在存取頁面有個致命問題，必須配合 DNS 進行白名單 ( wildcard ) 設定，這問題主要是根源於其安全機制與路由規劃，這樣的嚴苛設定，對小型專案、無法控制區域 DNS 主機的團隊有很大的應用障礙，亦因此社群於 2017 提出相關討論，但至今仍未修改此項服務。

+ [GitLab Pages without DNS wildcard](https://gitlab.com/gitlab-org/gitlab-foss/-/issues/29963)
+ [Tech Eval: GitLab Pages without DNS wildcard (golang version)](https://gitlab.com/gitlab-org/gitlab/-/issues/29841)

## 參考

+ [Community Edition or Enterprise Edition](https://about.gitlab.com/install/ce-or-ee/)
    - **The Enterprise Edition is available for free and includes all of the features available in the Community Edition, without the need to register or obtain a license. If you decide to upgrade to a paid tier and unlock additional features, you will be able to do this more easily if you are already on the Enterprise Edition.**
    - **If you only want to download open source software, Community Edition is the best choice. This distribution does not contain proprietary code. Functionally it will behave the same as Enterprise Edition without a license.**
+ [Gitlab install](https://docs.gitlab.com/omnibus/installation/)
    - [GitLab Docker images](https://docs.gitlab.com/omnibus/docker/)
    - [Official Linux package (Ubuntu、Debian、CentOS)](https://about.gitlab.com/install/#ubuntu)
+ [和艦長一起 30 天玩轉 GitLab 系列](https://ithelp.ithome.com.tw/m/users/20120986/ironman/2733?sc=iThelpR)
    - [Admin Area—維運 GitLab Server 的管理者後台](https://ithelp.ithome.com.tw/m/articles/10215637)
