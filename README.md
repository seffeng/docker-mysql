# Docker Alpine MySQL

## 环境

```
alpine: ^3.11
mysql: 5.7.28
```

## 常用命令：

```sh
# 拉取镜像
$ docker pull seffeng/mysql

# 运行
$ docker run --name mysql-test -d -v <data-dir>:/opt/websrv/data/mysql -v <tmp-dir>:/opt/websrv/tmp -v <log-dir>:/opt/websrv/logs seffeng/mysql

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
