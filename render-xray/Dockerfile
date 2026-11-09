# Xray VLESS+WS on Render (free tier)
# 官方 xray 镜像没有 shell，多阶段构建：取官方镜像里的二进制，拷进 Alpine 跑。
# Render 在容器外做 TLS（443 -> $PORT），容器内 xray 只跑明文 WS，不用证书。
# UUID / WS_PATH 不写进仓库，从 Render 环境变量注入。
FROM ghcr.io/xtls/xray-core:latest AS xray

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY --from=xray /usr/local/share/xray/geoip.dat /usr/local/share/xray/geoip.dat
COPY --from=xray /usr/local/share/xray/geosite.dat /usr/local/share/xray/geosite.dat
COPY config.template.json /etc/xray/config.template.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
