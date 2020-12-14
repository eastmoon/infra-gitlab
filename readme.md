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

+ 啟動、關閉
+ [備份、重建](https://docs.gitlab.com/ee/raketasks/backup_restore.html)
+ 帳號與權限
+ 安全性設定 ( SSL、Https )
+ 建立專案
+ 移除專案

## 參考

+ [Community Edition or Enterprise Edition](https://about.gitlab.com/install/ce-or-ee/)
    - **The Enterprise Edition is available for free and includes all of the features available in the Community Edition, without the need to register or obtain a license. If you decide to upgrade to a paid tier and unlock additional features, you will be able to do this more easily if you are already on the Enterprise Edition.**
    - **If you only want to download open source software, Community Edition is the best choice. This distribution does not contain proprietary code. Functionally it will behave the same as Enterprise Edition without a license.**
+ [Gitlab install](https://docs.gitlab.com/omnibus/installation/)
    - [GitLab Docker images](https://docs.gitlab.com/omnibus/docker/)
    - [Official Linux package (Ubuntu、Debian、CentOS)](https://about.gitlab.com/install/#ubuntu)
+ [和艦長一起 30 天玩轉 GitLab 系列](https://ithelp.ithome.com.tw/m/users/20120986/ironman/2733?sc=iThelpR)
    - [Admin Area—維運 GitLab Server 的管理者後台](https://ithelp.ithome.com.tw/m/articles/10215637)
