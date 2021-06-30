docker build -t james .

docker run -d -t -p 80:80 james

docker exec -i -t ef /bin/bash

docker stop $(docker ps -a -q)

docker rmi -f $(docker images -q)

docker container prune

# remove everything
docker system prune

# check uploaded image
docker --version
docker pull stefvanbuuren/james/latest
docker images
docker run -d -t -p 80:80 stefvanbuuren/james
