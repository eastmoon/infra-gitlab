# Gitlab 資料建立

以腳本方式建立 Gitlab 的相關資訊，在使用此腳本前，必需自 Root 帳號取得可使用的 Access Token ( 請存放於 access_token 檔案 )；此腳本共會處裡三類資料

+ 群組
    - Gitlab 的 group 分類，用於歸類專案與用戶可監控專案項目
+ 用戶
    - Gitlab 的 user，提供預設的用戶資料、密碼、無需信件認證，用戶也必需歸類在指定的群組下
+ 專案
    - Gitlab 的 project，提供預設的專案目錄，並歸類在正確的群組下

此腳本需使用 shell 函式庫 [jshon](http://kmkeen.com/jshon/) 以此解析 Gitlab 回應的複雜資料集
