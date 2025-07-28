#!/usr/bin/env sh

while true; do
    # 获取时间
    time=$(date +"%Y-%m-%d %I:%M:%S %p W%U")

    # 获取电池信息（通过 sysfs）
    battery_path="/sys/class/power_supply/BAT0"
    if [ -d "$battery_path" ]; then
        capacity=$(cat "$battery_path/capacity")
        status=$(cat "$battery_path/status")
        case "$status" in
            "Charging")    icon="⚡" ;;
            "Discharging") icon="🔋" ;;
            "Full")        icon="🟢" ;;  # 满电时显示绿色圆圈
            "Not charging") icon="🔌" ;; # 未充电但插电
            *)            icon="❓" ;;   # 未知状态
        esac
        battery="$icon $capacity%"
    else
        battery=""
    fi

    # 输出状态栏内容
    echo "$battery $time"
    sleep 1
done
