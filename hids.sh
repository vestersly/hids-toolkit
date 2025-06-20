#!/bin/bash
cd "$(dirname "$0")"
CONFIG_FILE="hids.conf"
MODULES_DIR="modules"
REPORTS_DIR="reports"
show_help() { echo "Usage: $0 {init|check|help}"; }
load_dependencies() {
    source "$CONFIG_FILE" || { echo "FATAL: Config not found."; exit 1; }
    for module in "$MODULES_DIR"/*.sh; do source "$module"; done
}
if [ $# -eq 0 ]; then show_help; exit 1; fi
load_dependencies
case "$1" in
    init)
        echo "===== HIDS Initialization Started ====="
        initialize_fim; initialize_users; initialize_logs
        initialize_processes_network; initialize_system_config
        echo "===== HIDS Initialization Complete ====="
        ;;
    check)
        report_file="${REPORTS_DIR}/report_$(date +%Y-%m-%d_%H-%M-%S).txt"
        exec > >(tee -a "$report_file") 2>&1
        echo "===== HIDS Check Started: $(date) ====="
        echo "Report: $report_file"
        check_fim; check_users; check_logs
        check_processes_network; check_system_config
        echo "===== HIDS Check Complete ====="
        if [ ! -z "$REPORT_EMAIL" ] && grep -q "ALERT" "$report_file"; then
            mail -s "HIDS Alert on $(hostname)" "$REPORT_EMAIL" < "$report_file"
            echo "Email alert sent to $REPORT_EMAIL"
        fi
        ;;
    *) show_help; exit 1;;
esac
exit 0
