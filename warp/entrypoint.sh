#!/bin/bash
set -e

cleanup() {
    echo "Caught termination signal, shutting down..."
    jobs -p | xargs -r kill || true
}
trap cleanup TERM INT

# 启动 dbus
/etc/init.d/dbus start
sleep 1

# 启动 warp 后台服务
warp-svc >/dev/null 2>&1 &
sleep 3

# 注册（已注册则忽略）
warp-cli --accept-tos registration new || true

# 设置为 proxy 模式
warp-cli --accept-tos mode proxy

# 连接
warp-cli --accept-tos connect

echo "Waiting for WARP to connect..."
sleep 5

# 自动刷新逻辑
if [[ "${REFRESH_INTERVAL:-0}" =~ ^[1-9][0-9]*$ ]]; then
    echo "WARP IP refresh enabled, interval: ${REFRESH_INTERVAL} minutes."
    (
        while true; do
            sleep $(( REFRESH_INTERVAL * 60 ))
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Refreshing WARP connection to get a new IP..."
            warp-cli --accept-tos disconnect || true
            sleep 3
            warp-cli --accept-tos connect || true
        done
    ) &
else
    echo "WARP IP refresh disabled (REFRESH_INTERVAL is 0 or not set)."
fi

echo "0.0.0.0 1080 127.0.0.1 40000" > /etc/rinetd.conf
exec rinetd -f -c /etc/rinetd.conf