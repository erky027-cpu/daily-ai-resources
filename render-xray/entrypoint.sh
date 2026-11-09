#!/bin/sh
# Render 注入 $PORT（默认 10000）；UUID 与 WS_PATH 由 Render 环境变量提供。
set -e
PORT=${PORT:-10000}
UUID=${UUID:?UUID env var is required}
WS_PATH=${WS_PATH:?WS_PATH env var is required}
sed -e "s/__PORT__/${PORT}/g" -e "s/__UUID__/${UUID}/g" -e "s#__WS_PATH__#${WS_PATH}#g" /etc/xray/config.template.json > /etc/xray/config.json
exec xray run -c /etc/xray/config.json
