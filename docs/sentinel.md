# redis-sentinel && redis-server

配置文件路径：/usr/local/etc/redis/sentinel.conf

## Docker run

- 默认配置运行
~~~sh
# 注意将你的配置文件 sentinel.conf 放到 redis目录下
docker run --name sentinel -itd -p 26379:26379 \
	-e REDIS_MASTER_HOST="192.168.2.8" -e REDIS_MASTER_PASSWORD="123456" \
	tekintian/alpine-redis-sentinel:6.2
~~~

- 使用自己的配置文件运行
~~~sh
# 注意将你的配置文件 sentinel.conf 放到 redis目录下, 
# 如果文件名不是 sentinel.conf，则需要使用 -e SENTINEL_CONF="xxx" 进行指定
docker run --name sentinel -itd -p 26379:26379 \
	-e REDIS_MASTER_HOST="192.168.2.8" -e REDIS_MASTER_PASSWORD="123456" \
	-e SENTINEL_CONF="/usr/local/etc/redis/sentinel.conf" \
	-v $PWD/redis:/usr/local/etc/redis \
	tekintian/alpine-redis-sentinel:6.2
~~~


## 同时运行 redis-server 和redis-sentinel
默认只运行 redis-sentinel， 如果需要同时运行server和sentinel
只需要加上环境变量 -e RUN_REDIS_PORT="6379"即可
如：
~~~sh
docker run --name sentinel -itd -p 26379:26379 \
	-e REDIS_MASTER_HOST="192.168.2.8" -e REDIS_MASTER_PASSWORD="123456" \
	-e RUN_REDIS_PORT="6379" -p 6379:6379 \
	tekintian/alpine-redis-sentinel:6.2
~~~


## 支持的环境变量与默认值

REDIS_MASTER_HOST=192.168.2.8
REDIS_MASTER_PORT_NUMBER=6379
REDIS_SENTINEL_QUORUM=2
REDIS_MASTER_PASSWORD="str0ng_passw0rd"
REDIS_SENTINEL_PORT_NUMBER=26379
REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS=5000
REDIS_SENTINEL_FAILOVER_TIMEOUT=60000
PROTECTED_MODE=no
DAEMONIZE=no
SENTINEL_LOGFILE=""
SENTINEL_CONF="/usr/local/etc/redis/sentinel.conf"

## 默认配置文件模板
~~~conf
# sentinel.conf
port ${REDIS_SENTINEL_PORT_NUMBER}
bind 0.0.0.0

protected-mode ${PROTECTED_MODE}
daemonize ${DAEMONIZE}
pidfile /var/run/redis-sentinel.pid
logfile ${SENTINEL_LOGFILE}
dir /tmp
sentinel down-after-milliseconds mymaster ${REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS}
acllog-max-len 128
sentinel failover-timeout mymaster ${REDIS_SENTINEL_FAILOVER_TIMEOUT}
sentinel parallel-syncs mymaster 1
# SECURITY
sentinel deny-scripts-reconfig yes
sentinel resolve-hostnames yes
sentinel announce-hostnames no

sentinel monitor mymaster ${REDIS_MASTER_HOST} ${REDIS_MASTER_PORT_NUMBER} ${REDIS_SENTINEL_QUORUM}
sentinel auth-pass mymaster ${REDIS_MASTER_PASSWORD}
# sentinel auth-user mymaster myuser
~~~
