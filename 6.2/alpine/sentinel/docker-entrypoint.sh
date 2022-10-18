#!/bin/sh
set -e

um="$(umask)"
if [ "$um" = '0022' ]; then
	umask 0077
fi

if [ -f "/usr/local/etc/redis/sentinel.conf" ];then
	# sentinel.conf配置文件变量替换
	cat /usr/local/etc/redis/sentinel.conf |/usr/bin/envsubst > /usr/local/etc/redis/sentinel.conf
	exec redis-sentinel /usr/local/etc/redis/sentinel.conf
else
	echo "sentinel config file not exist! /usr/local/etc/redis/sentinel.conf"
	exit
fi
