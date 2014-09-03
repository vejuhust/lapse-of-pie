TZ='Asia/Shanghai'; export TZ
sleep 15
MASTEREMAIL=weye@microsoft.com
CONTENT=$(printf "Subject: %s status at %s\n" "$(hostname)" "$(date '+%Y-%m-%d %H:%M:%S')")
CONTENT="$CONTENT"$(printf "\n\n[who] %s\n" "$(who)")
CONTENT="$CONTENT"$(printf "\n\n[uptime] %s\n" "$(uptime)")
CONTENT="$CONTENT"$(printf "\n\n[thermal] %s\n" "$(cat /sys/class/thermal/thermal_zone0/temp)")
CONTENT="$CONTENT"$(printf "\n\n[mem_total] %s\n" "$(cat /proc/meminfo | grep MemTotal)")
CONTENT="$CONTENT"$(printf "\n\n[mem_free] %s\n" "$(cat /proc/meminfo | grep MemFree)")
CONTENT="$CONTENT"$(printf "\n\n[sd_disk] %s\n" "$(df -m | grep rootfs)")
CONTENT="$CONTENT"$(printf "\n\n[ip] %s\n" "$(/sbin/ifconfig | grep eth0 -A 1 | tail -1)")
echo "$CONTENT" | /usr/sbin/ssmtp "$MASTEREMAIL"
