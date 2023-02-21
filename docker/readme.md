# Gitlab

針對 gitlab 的 root 密碼以兩個方式取得：

+ 使用 ```conf/initial_root_password``` 內容作為密碼
+ 執行腳本替換指定的密碼
    - 等待主機開啟完畢，可以使用 ```docker logs -f <container name>``` 確認
    - 進入開發環境，```dockerw into```
    - 執行替換密碼腳本，```0-initial-root-password.sh```
