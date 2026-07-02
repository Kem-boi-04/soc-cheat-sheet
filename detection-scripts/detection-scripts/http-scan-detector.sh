#!/bin/bash
# HTTP Scanner Detector - Run every 1 min

LOG="/var/log/nginx/access.log"
THRESHOLD=50

tail -n 200 "$LOG" | awk '$9==404 {print $1}' | sort | uniq -c | while read count ip; do
  if [ $count -gt $THRESHOLD ]; then
    echo "[$(date)] Scanning IP: $ip - $count 404s in last 60s" | logger -t http-scanner
    # Optionally block:
    # iptables -A INPUT -s "$ip" -j DROP
  fi
done
