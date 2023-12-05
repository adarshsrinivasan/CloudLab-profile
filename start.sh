#!/bin/bash

set +x

IP_PREFIX="10.20.1"
PORT="6379"
PASSWORD="password"

printf "Startup script to setup Redis - $1 $2 \n"

if [ "$1" == "True" ]; then
  printf "Installing redis \n"
  sudo apt update
  sudo apt install redis-server -y
  node_num="$2"
  if [ "$node_num" == "0" ]; then
    printf "Initializing redis-server \n"
    rm -f /etc/redis/redis.conf
    echo "bind 127.0.0.1 ::1 $IP_PREFIX.$((node_num + 1))
protected-mode no
requirepass $PASSWORD" > /etc/redis/redis.conf
  else
    printf "Initializing redis-client \n"
    rm -f /etc/redis/redis.conf
    echo "bind 127.0.0.1 ::1 $IP_PREFIX.$((node_num + 1))
protected-mode no
replicaof $IP_PREFIX.1 $PORT
masterauth $PASSWORD
requirepass $PASSWORD" > /etc/redis/redis.conf
  fi
  systemctl restart redis
fi

printf "%s: %s\n" "$(date +"%T.%N")" "Redis setup completed!"