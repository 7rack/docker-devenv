## 环境

基于：centos:6 
软件：
```
node 4.2.3
```

## 自定义 project 配置文件

修改`deploy.js`中的token。deploy.js 参考[gitlab-webhooker](https://www.npmjs.com/package/gitlab-webhooker)，有所更改。 
修改`deploy.sh`中*project_url*为需要部署的工程git repo。 
添加开发账户的公钥到 gitlab。 

## 构建镜像

使用 node js 长期支持版本,添加了 SSH 服务供 debug 。
