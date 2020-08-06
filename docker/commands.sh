docker build -t james .

docker run -d -t -p 80:80 james

docker exec -i -t ef /bin/bash

docker stop $(docker ps -a -q)

docker rmi -f $(docker images -q)
