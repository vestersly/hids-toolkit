#!/bin/bash
initialize_system_config() { echo "Initializing Crontab baseline..."; sudo crontab -l -u root > "$CRON_BASELINE_ROOT" 2>/dev/null; }
check_system_config() {
    echo "--- [50] Checking System Config ---"
    local issues=0
    if ! sudo diff "$CRON_BASELINE_ROOT" <(sudo crontab -l -u root 2>/dev/null) >/dev/null; then echo "ALERT: Root crontab modified."; issues=1; fi
    # This check is noisy, so it's more for manual review. We'll just report if any are found.
    if find / -type f \( -perm /4000 -o -perm /2000 \) -not -path "$EXCLUDED_PATHS/*" -ls 2>/dev/null | grep -q .; then echo "INFO: SUID/SGID files present. Please review."; fi
    if [ $issues -eq 0 ]; then echo "OK: No critical config changes."; fi
}
