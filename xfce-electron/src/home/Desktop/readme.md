## app 目录权限(更新只用换此目录下的文件)
```shell
$ ls -l resources
total 11040
-rw-r--r--    1 root     root        312025 Mar 27 07:53 AppIcon.icns
-rw-r--r--    1 root     root       2592473 Mar 27 07:53 app.asar
-rw-r--r--    1 root     root          9662 Mar 27 07:53 app.ico
-rw-r--r--    1 root     root          3918 Mar 27 07:53 app.png
-rw-r--r--    1 root     root           947 Mar 27 07:53 aria2.conf
-rwxr-xr-x    1 root     root       8373624 Mar 27 07:53 aria2c
```

## 运行 docker
```
端口 vnc:5901, novnc:6901
密码: headless
```  
```c
// 必须映射的app目录, 加上你自己的目录  
docker run -d \
    -p 6901:6901 \                        // 主机端口:窗口端口
    -v ~/resources:/electron/resources \  // 主机目录:窗口目录
    -v /data:/data \                      // 可选(自定), 上传下载目录
    dkcourser/electron:amd64
```
