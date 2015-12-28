## 环境

基于：centos:6
软件：
```
	apache-ant-1.9.6(包含svnant)
	apache-tomcat-7.0.65
	jdk-7u45-linux-x64
```

## 自定义 ant、project 配置文件

添加自定义配置文件,目录结构如下:
```
config/
├── projname
│   ├── akkalog.conf
│   ├── application.conf
│   ├── config.properties
│   ├── ehcache.xml
│   ├── lbpcascade_frontalface.xml
│   ├── log4j.properties
│   ├── logback.xml
│   ├── qqconnectconfig.properties
│   ├── RedisConnector.properties
│   └── web.properties
└── ant_build.xml
```
打包压缩为 config.tgz ，构建镜像时会自动加入。
*ant_build.sample.xml*为ant配置文件示例。


## 构建镜像

为避免因网络超时，可将软件包下载到本地，再构建镜像。
运行实例后，通过 ssh 登陆（devops）并执行`./deploy.sh`重新拉取代码，部署项目。
