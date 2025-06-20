#!/bin/bash
initialize_fim() { echo "Initializing FIM..."; find $MONITORED_DIRS -type f -print0 | xargs -0 sha256sum > "$BASELINE_FILE"; }
check_fim() {
    echo "--- [10] Checking File Integrity ---"
    local changes=0
    sha256sum -c --quiet "$BASELINE_FILE" | grep -v 'OK$' || changes=1
    diff <(awk '{print $2}' "$BASELINE_FILE"|sort) <(find $MONITORED_DIRS -type f|sort) | grep '[<>]' || changes=1
    if [ $changes -eq 0 ]; then echo "OK: No file changes."; else echo "ALERT: File changes detected."; fi
}
