#!/bin/bash
initialize_processes_network() { echo "Process/Net module requires no init."; }
check_processes_network() {
    echo "--- [40] Checking Processes & Network ---"
    local issues=0
    if ps aux | awk '$11 ~ /^\/tmp\//' | grep -q .; then echo "ALERT: Process running from /tmp detected."; issues=1; fi
    for port in $(ss -tuln | awk 'NR>1 {print $5}' | sed 's/.*://' | sort -un); do
        [[ " $ALLOWED_PORTS " =~ " $port " ]] || { echo "ALERT: Unauthorized port open: $port"; issues=1; }
    done
    if [ $issues -eq 0 ]; then echo "OK: No suspicious processes or ports found."; fi
}
