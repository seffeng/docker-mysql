# Docker Alpine MariaDB

## 环境

```
alpine: ^3.13
mariadb: ^10.4
```

## 常用命令：

```sh
# 拉取镜像
$ docker pull seffeng/mysql

# 运行，注意：配置<data-dir>运行将失败，请查看备注说明
$ docker run --name mysql-test -d -p <port>:3306 -v <data-dir>:/opt/websrv/data/mysql -v <tmp-dir>:/opt/websrv/tmp -v <log-dir>:/opt/websrv/logs seffeng/mysql

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

```
# mysql 初始账号：root；初始密码：root
```
```shell
# 建议容器之间使用网络互通
## 1、添加网络[已存在则跳过此步骤]
$ docker network create network-01

## 运行容器增加 --network network-01 --network-alias [name-net-alias]
$ docker run --name mysql-alias1 --network network-01 --network-alias mysql-alias1 -d -p 3306:3306 -v /opt/websrv/data/mysql:/opt/websrv/data/mysql -v /opt/websrv/tmp:/opt/websrv/tmp -v /opt/websrv/logs/mysql:/opt/websrv/logs seffeng/mysql
```
#### 若需要链接容器外部数据库目录`<data-dir>`，操作步骤如下：

##### 方法一：

1、运行

```shell
$ docker run --name mysql-tmp -it -v <tmp-dir>:/opt/websrv/tmp seffeng/mysql sh
```

2、打包原有数据库目录:

```shell
$ cd /opt/websrv/data && tar -zcf mysql.tar.gz mysql
```

3、将 mysql.tar.gz 转存到主机，并解压到存储目录，如：/data/，则数据库目录为：/data/mysql

4、退出容器，创建临时目录

```shell
$ mkdir -p <tmp-dir> && chmod 777 <tmp-dir>
```

5、运行新容器

```shell
$ docker run --name mysql-test -d -p <port>:3306 -v /data/mysql:/opt/websrv/data/mysql -v <tmp-dir>:/opt/websrv/tmp -v <log-dir>:/opt/websrv/logs seffeng/mysql
```

##### 方法二（建议）：

1、运行

```shell
$ docker run --name mysql-tmp -it -v <data-dir>:/opt/websrv/data/mysql seffeng/mysql sh
```

2、重新生成数据库，此时数据库账号：root，密码为空，仅能 localhost 访问

```shell
$ mysql_install_db --user=mysql --datadir=/opt/websrv/data/mysql --skip-test-db
```

3、可通过以下操作设置账号：root，密码：root。访问 % 。

```shell
$ /etc/init.d/mysql.server start
$ echo -e "USE mysql;\nGRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;\nDROP USER 'root'@'localhost';\nDROP USER 'mysql'@'localhost';\nFLUSH PRIVILEGES;\n" > initdb
$ mysql -u root < initdb
$ /etc/init.d/mysql.server stop && rm -f initdb
```

4、退出容器，创建临时目录

```shell
$ mkdir -p <tmp-dir> && chmod 777 <tmp-dir>
```

5、运行新容器

```shell
$ docker run --name mysql-test -d -p <port>:3306 -v <data-dir>:/opt/websrv/data/mysql -v <tmp-dir>:/opt/websrv/tmp -v <log-dir>:/opt/websrv/logs seffeng/mysql
```

6、完整示例

```shell
$ docker run --name mysql-tmp -it -v /opt/websrv/data/mysql:/opt/websrv/data/mysql seffeng/mysql sh

# 容器内操作
$ mysql_install_db --user=mysql --datadir=/opt/websrv/data/mysql --skip-test-db
$ /etc/init.d/mysql.server start
echo -e "USE mysql;\nGRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;\nDROP USER 'root'@'localhost';\nDROP USER 'mysql'@'localhost';\nFLUSH PRIVILEGES;\n" > initdb
$ mysql -u root < initdb
$ /etc/init.d/mysql.server stop && rm -f initdb
$ exit # 容器内操作完成，退出容器

$ mkdir -p /opt/websrv/tmp && chmod 777 /opt/websrv/tmp
#运行新容器
$ docker run --name mysql-alias1 -d -p 3306:3306 -v /opt/websrv/data/mysql:/opt/websrv/data/mysql -v /opt/websrv/tmp:/opt/websrv/tmp -v /opt/websrv/logs/mysql:/opt/websrv/logs seffeng/mysql
```

