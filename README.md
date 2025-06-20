# Host-based Intrusion Detection System (HIDS) Toolkit

A security tool designed to monitor a Linux system for suspicious activities and potential intrusions. This HIDS operates by establishing a baseline of the system's normal state and then periodically checking for deviations from that baseline.

Developed as a school project, this HIDS aims to demonstrate fundamental concepts of system security, incident detection, and shell scripting.

---

## ✨ Key Features

*   **File Integrity Monitoring (FIM):** Tracks changes to critical system files and directories using `sha256sum`.
*   **User Account Monitoring:** Detects the creation, modification, or deletion of user accounts and groups.
*   **Log Analysis:** Scans system logs for predefined suspicious keywords.
*   **Process & Network Monitoring:** Identifies unusual processes and unauthorized open network ports.
*   **System Configuration Monitoring:** Monitors changes to critical system configurations like `crontab`.
*   **Automated Reporting & Alerts:** Generates detailed reports and can send email notifications upon detection of suspicious activities.

---

## 🚀 Getting Started

Follow these steps to get a copy of the project up and running on your local machine.

### Prerequisites
* A Linux-based operating system (e.g., Kali Linux, Ubuntu)
* `bash`, `sudo` privileges, and standard Linux core utilities (`git`, `grep`, `diff`, etc.)

### 1. Clone the Repository
Clone the project from GitHub to your local machine.

```bash
git clone https://github.com/vestersly/hids-toolkit.git
cd hids-toolkit
