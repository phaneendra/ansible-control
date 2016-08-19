#!/bin/bash
set -e

modifyKeys() {
  # authorized keys are mounted from host.
  # change permissions for authorized keys to connect passwordless.
  echo "===> change .ssh/authorized keys to enable ansible to connect passwordless"
  chmod 600 /home/ansible/.ssh/authorized_keys
  chmod 700 /home/ansible/.ssh
  chown -R ansible:ansible /home/ansible
}

# Call all functions
modifyKeys
exec "$@"
