#!/bin/sh

# 读取 UCI 配置
INTERFACE=$(uci get mac-switch.@settings[0].interface 2>/dev/null)
MAC_PREFIX=$(uci get mac-switch.@settings[0].mac_prefix 2>/dev/null)
CHECK_METHOD=$(uci get mac-switch.@settings[0].check_method 2>/dev/null)
CHECK_TARGET=$(uci get mac-switch.@settings[0].check_target 2>/dev/null)
LOG_FILE="/tmp/mac_switch.log"

# 如果未配置接口，退出
[ -z "$INTERFACE" ] && exit 0

# 1. 检测网络连通性
check_network() {
    if [ "$CHECK_METHOD" = "ping" ]; then
        ping -c 3 -W 5 "$CHECK_TARGET" > /dev/null 2>&1
    else
        wget -q --spider "$CHECK_TARGET" > /dev/null 2>&1
    fi
    return $?
}

if check_network; then
    exit 0
fi

echo "$(date): 网络断开 ($INTERFACE)，正在切换 MAC..." >> "$LOG_FILE"

# 2. 生成新 MAC (确保第二位是2/6/A/E，符合无线单播地址规范)
[ -z "$MAC_PREFIX" ] && MAC_PREFIX="00:11:22"
RAND_SUFFIX=$(hexdump -n 3 -e '3/1 "%02x:"' /dev/urandom | sed 's/:$//')
NEW_MAC="${MAC_PREFIX}:${RAND_SUFFIX}"
# 修正 U/L 位
NEW_MAC=$(echo "$NEW_MAC" | sed 's/^\(.\)[0-9a-f]/\12/')

# 3. 应用新 MAC
if echo "$INTERFACE" | grep -qE "^(wlan|ath|ra)"; then
    wifi down
    ifconfig "$INTERFACE" down
    ifconfig "$INTERFACE" hw ether "$NEW_MAC"
    ifconfig "$INTERFACE" up
    wifi up
else
    ifdown "$INTERFACE"
    ifconfig "$INTERFACE" down
    ifconfig "$INTERFACE" hw ether "$NEW_MAC"
    ifconfig "$INTERFACE" up
    ifup "$INTERFACE"
fi

echo "$(date): MAC 已切换为 $NEW_MAC" >> "$LOG_FILE"
