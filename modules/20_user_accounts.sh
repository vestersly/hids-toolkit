#!/bin/bash
initialize_users() { echo "Initializing Users..."; cp /etc/passwd "$PASSWD_BASELINE"; sudo cp /etc/shadow "$SHADOW_BASELINE"; cp /etc/group "$GROUP_BASELINE"; }
check_users() {
    echo "--- [20] Checking User Accounts ---"
    local changes=0
    diff "$PASSWD_BASELINE" /etc/passwd >/dev/null || { echo "ALERT: /etc/passwd modified."; changes=1; }
    sudo diff "$SHADOW_BASELINE" /etc/shadow >/dev/null || { echo "ALERT: /etc/shadow modified."; changes=1; }
    diff "$GROUP_BASELINE" /etc/group >/dev/null || { echo "ALERT: /etc/group modified."; changes=1; }
    if [ -n "$(sudo awk -F: '($2 == "") {print $1}' /etc/shadow)" ]; then echo "CRITICAL ALERT: User with empty password found!"; changes=1; fi
    if [ $changes -eq 0 ]; then echo "OK: No user account changes."; fi
}
