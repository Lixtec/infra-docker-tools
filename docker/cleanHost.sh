#!/bin/bash
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
docker volume rm $(docker volume list)
docker system prune -f
docker volume prune -f

