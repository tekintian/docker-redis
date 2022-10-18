#!/bin/sh
# build redis-sentinel docker images
# @Author tekintian@gmail.com
# 
# redis 6.2.x小版本号
REDIS_MVER=7

docker build -f Dockerfile -t tekintian/alpine-redis-sentinel:6.2 .

docker tag tekintian/alpine-redis-sentinel:6.2 tekintian/alpine-redis-sentinel:6.2.${REDIS_MVER}

# push
docker push tekintian/alpine-redis-sentinel:6.2
docker push tekintian/alpine-redis-sentinel:6.2.${REDIS_MVER}
