#!/bin/bash

log_dir="./ip_address_logs/$(date | awk '{print $1, $2, $3}' | sed 's/ /_/g')"
mkdir -p "$log_dir"

file_path="$log_dir/$(date | cut -d'_' -f1-3,4 | cut -d':' -f1,2 | sed 's/ /_/g')"
the_time=$(date | cut -d " " -f 4 | cut -d ":" -f 3)

if [ "$the_time" -gt 50 ]; then
echo -e "\n---CAUTION---\nThe time is $(date | cut -d " " -f 4)\nTwo log files might be created.\n"
fi

for address in "$@"; do
if ping -c 4 -W 1 "$address" | grep -q "100% packet loss"; then
echo -e "Packet lost: $(ping -c 4 -W 1 "$address" | grep -e "---" | cut -d " " -f 2)"
echo -e "$(ping -c 4 -W 1 "$address" | grep -v "bytes of data")\n" >> "$file_path" &
else
ping -c 4 -W 2 "$address"
echo -e "\n"
fi
done

echo -e "\nPath for lost packet logs: $log_dir\n"
