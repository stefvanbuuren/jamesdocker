
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jamesdocker

<!-- badges: start -->
<!-- badges: end -->

Repository containing `Dockerfile` to build the `james` image from R
sources.

Some commands of interest for development with Docker Desktop:

``` bash
# build the image
docker build -t james .

# start image locally
docker run -d -t -p 80:80 james

# stop the image
docker stop $(docker ps -a -q)

# go into image
docker exec -i -t ef /bin/bash

# remove old images
docker rmi -f $(docker images -q)
docker container prune

# remove everything
docker system prune
```

In order to access some private repositories need for building, store
your `GITHUB_PAT` in a local file `docker/opencpu_config/Renviron`. For
example, `Renviron` could look like

    GITHUB_PAT=ff8...

with `ff8...` replaces by your `GITHUB_PAT`. For obvious reasons, the
`Renviron` file is excluded from the online GitHub repository.
