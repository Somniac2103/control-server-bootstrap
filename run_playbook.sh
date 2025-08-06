#!/bin/bash

# /usr/bin/ansible-playbook -i "127.0.0.1," /opt/control-server-bootstrap/control-server-bootstrap.yml

# === CONFIGURATION ===
USER="$(whoami)"
PLAYBOOK_PATH="/opt/control-server-bootstrap/control-server-bootstrap.yml"
INVENTORY="127.0.0.1,"
ANSIBLE_BIN="/usr/bin/ansible-playbook"
LOG_FILE="/var/log/ansible-playbook.log"

# === FUNCTIONS ===

check_passwordless_sudo() {
    sudo -n true 2>/dev/null
    return $?
}

run_playbook() {
    echo "[$(date)] ✅ Passwordless sudo confirmed. Running Ansible playbook..." | tee -a "$LOG_FILE"

    echo "[$(date)] ➡️ Executing: $ANSIBLE_BIN -i $INVENTORY $PLAYBOOK_PATH" | tee -a "$LOG_FILE"

    $ANSIBLE_BIN -i "$INVENTORY" "$PLAYBOOK_PATH" >> "$LOG_FILE" 2>&1
    RC=$?

    if [[ $RC -eq 0 ]]; then
        echo "[$(date)] ✅ Playbook finished successfully." | tee -a "$LOG_FILE"
    else
        echo "[$(date)] ❌ Playbook failed with exit code $RC" | tee -a "$LOG_FILE"
    fi
}


# handle_failure() {
#     echo "[$(date)] ❌ ERROR: Passwordless sudo is not enabled for user '$USER'" | tee -a "$LOG_FILE"
#     echo "[$(date)] ❌ Playbook was NOT executed." | tee -a "$LOG_FILE"
#     exit 1
# }

# # === MAIN EXECUTION ===

# if check_passwordless_sudo; then
#     run_playbook
# else
#     handle_failure
# fi
