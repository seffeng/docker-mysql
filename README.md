# Docker Debian MySQL

## 版本说明

* [mariadb-10.6 , latest](https://github.com/seffeng/docker-mysql/tree/mariadb)
* [8.0.28](https://github.com/seffeng/docker-mysql/tree/8.0)
* [5.7.37](https://github.com/seffeng/docker-mysql/tree/5.7)

## 环境

```
debian: ^11.3
mysql: ^8.0.29
```

## 常用命令：

```sh
# 拉取镜像
$ docker pull seffeng/mysql:8.0

# 运行
$ docker run --name mysql-test -d -p <port>:3306 -v <data-dir>:/opt/websrv/data/mysql -v <tmp-dir>:/opt/websrv/tmp -v <log-dir>:/opt/websrv/logs seffeng/mysql:8.0

# 查看正在运行的容器
$ docker ps

# 停止
$ docker stop [CONTAINER ID | NAMES]

# 启动
$ docker start [CONTAINER ID | NAMES]

# 进入终端
$ docker exec -it [CONTAINER ID | NAMES] sh

# 删除容器
$ docker rm [CONTAINER ID | NAMES]

# 镜像列表查看
$ docker images

# 删除镜像
$ docker rmi [IMAGE ID]
```

## 备注

```shell
# mysql 初始账号：root；初始密码：空

# 登录后修改密码
$ ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
$ FLUSH PRIVILEGES;

# 创建用户
$ CREATE USER 'root'@'%' IDENTIFIED BY 'password';
$ GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;

## mysql8 密码验证方式修改
$ ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
## 或修改配置文件，在[mysqld]中添加下边的代码 
default_authentication_plugin=mysql_native_password
```
```shell
# 建议容器之间使用网络互通
## 1、添加网络[已存在则跳过此步骤]
$ docker network create network-01

## 运行容器增加 --network network-01 --network-alias [name-net-alias]
$ docker run --name mysql-alias1 --network network-01 --network-alias mysql-alias1 -d -p 3306:3306 -v /opt/websrv/data/mysql:/opt/websrv/data/mysql -v /opt/websrv/tmp:/opt/websrv/tmp -v /opt/websrv/logs/mysql:/opt/websrv/logs seffeng/mysql:8.0
```