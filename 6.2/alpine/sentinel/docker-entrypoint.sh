#!/bin/sh
set -e

if [ "${RUN_REDIS_PORT}" != '' ]; then
	find . \! -user redis -exec chown redis '{}' +
	# 将redis-server以后台 & 方式启动
	echo "starting redis-server on port ${RUN_REDIS_PORT}..."
	redis-server "$@" --port ${RUN_REDIS_PORT} &
fi

if [ -f "${SENTINEL_CONF}" ];then
	# sentinel.conf配置文件变量替换
	cat ${SENTINEL_CONF} |/usr/bin/envsubst > ${SENTINEL_CONF}
	exec redis-sentinel ${SENTINEL_CONF}
else
	echo "sentinel config file not exist! ${SENTINEL_CONF}"
	exit
fi

um="$(umask)"
if [ "$um" = '0022' ]; then
	umask 0077
fi

exec "$@"