# Ansible Control
A control repo for ansible.

** Developer preview only - under construction **


# Useful Commands

* Create a network
  `docker network create nginx-proxy`

* Build and run a specific service in docker-compose
  `docker-compose up --build webserver-nginx`

* Force build a specific service in docker-compose
  `docker-compose build --no-cache wordpress`

* List all containers
  `docker ps -a -q -f status=exited`

* Remove unused containers
  ```
  docker ps --filter status=dead --filter status=exited -aq \
    | xargs docker rm -v
  ```

* remove untagged images
  ```
  docker images --no-trunc | grep '<none>' | awk '{ print $3 }' \
    | xargs docker rmi
  ```

* remove unused volumes
  `docker volume ls -qf dangling=true | xargs docker volume rm`

* ssh into a docker contatiner
  `docker exec -it wordpressdev_wordpress_1 bash`

* stop the latest docker container
  `docker stop $(docker ps -a -q)`

* remove the latest docker container
  `docker rm $(docker ps -a -q)`
