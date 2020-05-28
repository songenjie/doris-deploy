# machine deploy

## 部署

1. 脚本

|脚本名称|操作|
|---|---|
|install.sh|install|
|restart.sh|restart|
|start.sh|start|
|stop_clean.sh|stop and clean lib、conf、storage|
|stop_clean_start.sh| stop and clean lib、conf、storage and restart|
|stop.sh|stop |
|udpateservice.sh|update service conf|
|updateconf.sh|update conf|
|updatelib.sh|update lib|

2. 参数

- $1 fe/be/broker
- $2 cluster
- $3 masteip:editport
- $4 build output dir
- $5 deploy ips file



## fe alter

1. 脚本

|脚本名称|操作|
|---|---|
|alter_system.sh|alter system|

2. 参数

- $1 FOLLOWER/OBSERVER/BACKEND/BROKER 
- $2 ADD/DROP
- $3 master $ip
- $4 master port
- $5 port 9510  9550 9580
- $6 file

