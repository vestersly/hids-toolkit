#!/bin/bash
# Module: System Configuration Checks

initialize_system_config() {
    echo "Initializing Crontab baseline..."
    # Ensure the baseline file exists, even if the crontab is empty.
    touch "$CRON_BASELINE_ROOT"
    # Redirect errors and ensure the command succeeds even if crontab is empty.
    sudo crontab -l -u root > "$CRON_BASELINE_ROOT" 2>/dev/null || true
    echo "Crontab baseline created."
}

check_system_config() {
    echo "--- [50] Checking System Config ---"
    local has_issue=0

    # 1. Check for crontab modifications
    echo "Checking for crontab modifications..."
    # Use a temporary file for the current state to avoid complex redirection issues
    local current_cron
    current_cron=$(mktemp)
    # Ensure the command succeeds and creates the temp file even if crontab is empty
    sudo crontab -l -u root > "$current_cron" 2>/dev/null || true

    # Now, diff the two guaranteed-to-exist files.
    if ! diff -q "$CRON_BASELINE_ROOT" "$current_cron" >/dev/null; then
        echo "ALERT: Root crontab has been modified."
        has_issue=1
    fi
    # Clean up the temporary file
    rm "$current_cron"

    # 2. Find SUID/SGID files (This check is noisy and for info only)
    echo "Searching for SUID/SGID files..."
    if find / -type f \( -perm /4000 -o -perm /2000 \) -not -path "$EXCLUDED_PATHS/*" -ls 2>/dev/null000 -o -perm /2000 \) -not -path "$EXCLUDED_PATHS/*" -ls 2>/dev/null | grep -q .; then
        echo "INFO: SUID/SGID files present. Please review for legitimacy."
    fi

    if [ $has_issue -eq 0 ]; then
        echo "OK: No critical system misconfigurations found."
    fi
    echo "------------------------------------"
}
