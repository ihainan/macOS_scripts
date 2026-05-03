#!/bin/bash
# 删除 aTrust 注入的 192.168.100.x 路由，让流量重新走 Surge

deleted=0

while read -r route; do
    if sudo route delete "$route" 2>/dev/null; then
        echo "Deleted: $route"
        ((deleted++))
    fi
done < <(netstat -rn | awk '{print $1}' | grep '^192\.168\.100')

if [ "$deleted" -eq 0 ]; then
    echo "No 192.168.100.x routes found via aTrust, nothing to do."
else
    echo "Done. Deleted $deleted route(s)."
fi
