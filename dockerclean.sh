#!/bin/bash
set -e

cleanDocker() {
  # Remove unused containers
  echo "===> Removing unused containers"
  docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v

  # Remove untagged images
  echo "===> Removing untagged images"
  docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs docker rmi

  # Remove unused volumes
  echo "===> Removing unused volumes"
  docker volume ls -qf dangling=true | xargs docker volume rm
}

# Call all functions
cleanDocker
