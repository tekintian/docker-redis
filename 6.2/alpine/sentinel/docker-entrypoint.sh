#!/bin/sh
set -e

if [ "${RUN_REDIS_PORT}" != '' ]; then
	find . \! -user redis -exec chown redis '{}' +
	# 将redis-server以后台 & 方式启动
	echo "starting redis-server on port ${RUN_REDIS_PORT}..."
	redis-server "$@" --port ${RUN_REDIS_PORT} &
fi

if [ -f "/usr/local/etc/redis/sentinel.conf" ];then
	# sentinel.conf配置文件变量替换
	cat /usr/local/etc/redis/sentinel.conf |/usr/bin/envsubst > /usr/local/etc/redis/sentinel.conf
	exec redis-sentinel /usr/local/etc/redis/sentinel.conf
else
	echo "sentinel config file not exist! /usr/local/etc/redis/sentinel.conf"
	exit
fi

um="$(umask)"
if [ "$um" = '0022' ]; then
	umask 0077
fi

exec "$@"