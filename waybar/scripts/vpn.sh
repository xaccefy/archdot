#!/bin/bash

# vpn.sh - VPN status for Waybar (JSON output)
# Shows VPN interface name and IP when connected

INTERFACES=("tun0" "tun1" "wg0" "wg1" "proton0" "nordlynx")

get_vpn_ip() {
    for iface in "${INTERFACES[@]}"; do
        if ip link show "$iface" &>/dev/null; then
            local ip=$(ip -4 addr show "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
            if [[ -n "$ip" ]]; then
                printf '%s' "$ip"
                return 0
            fi
        fi
    done
}

get_vpn_status() {
    for iface in "${INTERFACES[@]}"; do
        if ip link show "$iface" &>/dev/null; then
            local ip=$(ip -4 addr show "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
            if [[ -n "$ip" ]]; then
                echo "{\"text\": \"VPN: $iface $ip\", \"tooltip\": \"Connected via $iface\\nIP: $ip\", \"class\": \"connected\"}"
                return 0
            fi
        fi
    done
    echo '{"text": "VPN: OFF", "tooltip": "No VPN connected", "class": "disconnected"}'
}

case "$1" in
    copy) get_vpn_ip | wl-copy -n ;;
    *) get_vpn_status ;;
esac
