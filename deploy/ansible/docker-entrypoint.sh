#!/bin/bash
set -e

modifySSHKeys() {
  # authorized keys are mounted from host.
  # change permissions for authorized keys to connect passwordless.
  echo "===> change .ssh/authorized keys to enable ansible to connect passwordless"
  chmod 600 /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/id_rsa
  chmod 700 /root/.ssh
  chown -R root:root /root
}

installAnsibleGalaxyRoles() {
  # install Galaxy roles, if any to ./galaxyroles
  echo "===> install Galaxy roles, if any to ./galaxyroles"
  if [ -z "$REQUIREMENTS" ]; then
    REQUIREMENTS=./requirements.yml
  fi

  if [ -f "$REQUIREMENTS" ]; then
    echo "==> found $REQUIREMENTS"
    ansible-galaxy install -r $REQUIREMENTS
  fi
}

runAnsiblePlaybook() {
  # execute playbook ./site.yml
  echo "===> execute playbook ./site.yml"
  if [ -z "$PLAYBOOK" ]; then
    PLAYBOOK=./site.yml
  fi

  if [ -z "$INVENTORY" ]; then
    INVENTORY=./inventories/local.ini
  fi

  echo "==> running default inventory $INVENTORY and playbook $PLAYBOOK"
  exec ansible-playbook -i $INVENTORY $PLAYBOOK
}

# Call all functions
modifySSHKeys
installAnsibleGalaxyRoles
# runAnsiblePlaybook
exec "$@"
