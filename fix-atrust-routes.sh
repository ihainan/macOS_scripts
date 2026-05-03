#!/bin/bash
# 删除 aTrust 注入的 192.168.100.x 路由，让流量重新走 Surge

ATRUST_IF="utun11"

# 检查 aTrust VPN 是否已连接
if ! ifconfig "$ATRUST_IF" &>/dev/null; then
    echo "aTrust VPN is not connected (interface $ATRUST_IF not found), nothing to do."
    exit 0
fi

# 找出所有经由 aTrust 的 192.168.100.x 路由
routes=$(netstat -rn | awk -v iface="$ATRUST_IF" '$6 == iface {print $1}' | grep '^192\.168\.100')

if [ -z "$routes" ]; then
    echo "aTrust VPN is connected, but no 192.168.100.x routes were injected, nothing to do."
    exit 0
fi

deleted=0
while read -r route; do
    if sudo route delete "$route" 2>/dev/null; then
        echo "Deleted: $route"
        ((deleted++))
    fi
done <<< "$routes"

echo "Done. Deleted $deleted route(s)."
