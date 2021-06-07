# docker JAMES - BDS version
FROM opencpu/base

LABEL maintainer="stef.vanbuuren@tno.nl"

# install Arial
RUN mkdir /usr/share/fonts/truetype/arial/
COPY docker/fonts/truetype/arial/* /usr/share/fonts/truetype/arial/

# install for V8 package
RUN apt-get update && apt-get install -y libnode-dev

# install for systemfonts package
RUN apt -y install libfontconfig1-dev

# Put a copy of our R code into the container
# WORKDIR /usr/local/src
# COPY . /usr/local/src/app
COPY docker/opencpu_config/Renviron .Renviron

# install R packages needed for JAMES
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("growthcharts/james")'

# Move OpenCPU configuration files into place - opt 3
ADD docker/opencpu_config/* /etc/opencpu/

CMD service cron start && apachectl -DFOREGROUND
