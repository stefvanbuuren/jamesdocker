FROM opencpu/base

# install for V8 package
RUN apt-get update && apt-get install -y libnode-dev

# Put a copy of our R code into the container
WORKDIR /usr/local/src
COPY . /usr/local/src/app

COPY docker/opencpu_config/Renviron .Renviron

# Move OpenCPU configuration files into place
COPY docker/opencpu_config/* /etc/opencpu/

# Run script to install R dependencies
RUN /usr/bin/R -f app/docker/installer.R

LABEL maintainer="stef.vanbuuren@tno.nl"

# install Arial
RUN mkdir /usr/share/fonts/truetype/arial/
COPY docker/fonts/truetype/arial/* /usr/share/fonts/truetype/arial/

CMD service cron start && apachectl -DFOREGROUND
