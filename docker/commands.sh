docker build -t james .
docker build -t rewrite .

docker run -d -t -p 80:80 james
docker run -d -t -p 80:80 rewrite

docker exec -i -t ef /bin/bash

docker stop $(docker ps -a -q)

docker rmi -f $(docker images -q)

docker container prune

# remove everything
docker system prune
