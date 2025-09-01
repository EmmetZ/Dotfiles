#!/bin/bash

# 检查是否插电

# 获取电源状态
if [ -f /sys/class/power_supply/ACAD/online ]; then
    status=$(cat /sys/class/power_supply/ACAD/online)
elif [ -f /sys/class/power_supply/AC/online ]; then
    status=$(cat /sys/class/power_supply/AC/online)
else
    tuned-adm profile balanced-battery
    exit 1
fi

# 判断状态
if [ "$status" -eq 1 ]; then
    tuned-adm profile balanced-battery
elif [ "$status" -eq 0 ]; then
    tuned-adm profile powersave
else
    tuned-adm profile balanced-battery
fi
