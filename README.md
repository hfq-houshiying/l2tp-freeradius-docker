## xl2tpd  + freeradius + mysql

### xl2tpd 

xl2tpd 基于 [hwdsl2](https://github.com/hwdsl2/docker-ipsec-vpn-server) 的 docker 镜像，

添加了 freeradius  认证功能 , 只要打开以下选项即可，其他参数在 l2tp.env 中有详细说明，

如果设置为 false 则默认使用 /etc/ppp/chap-secrets 进行认证

```
USE_RADIUS=true
```

### freeradius 

freeradius 基于 ubuntu 14.04 镜像制作，具体参数查看 `freeradius-env` 文件


### mysql 

mysql 镜像使用官方 5.6 镜像，5.7 导入 freeradius  库有问题，没有使用 5.7 镜像


### 启动

```
docker-compose up -d
```
