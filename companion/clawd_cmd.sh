#!/bin/bash
# clawd_cmd.sh — send an expression command to Clawd Mochi over WiFi.
#   c/k = working   l = heart   x = X/dizzy   o = surprised   z = sleepy
#   w/r = "resting" -> picks a random cute face
#
# Reaches the device by mDNS name first, then falls back to a fixed IP.
# Set HOST_IP to your device's IP (shown on its screen at boot) as a backup.
HOST_MDNS="clawd.local"
HOST_IP="192.168.1.123"     # <-- change to your device IP (see the boot screen)
K="${1:-w}"
[ "$K" = "c" ] && K="k"
send(){
  curl -s --max-time 2 "http://${HOST_MDNS}/cmd?k=$1" >/dev/null 2>&1 && return 0
  curl -s --max-time 2 "http://${HOST_IP}/cmd?k=$1"   >/dev/null 2>&1
}
if [ "$K" = "w" ] || [ "$K" = "r" ]; then
  POOL=(w p h e s g i)      # normal/happy/blush/star/squish/angry/wink
  K="${POOL[$RANDOM % ${#POOL[@]}]}"
fi
send q          # leave terminal mode if active (no-op otherwise)
send "$K"
exit 0
