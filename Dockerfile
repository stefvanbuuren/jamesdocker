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
RUN R -e 'install.packages("brokenstick")'
RUN R -e 'install.packages("dscore")'

# private repos
RUN R -e 'remotes::install_github("stefvanbuuren/clopus")'
RUN R -e 'remotes::install_github("stefvanbuuren/donorloader")'
RUN R -e 'remotes::install_github("growthcharts/nlreferences")'

# public repos
ADD https://api.github.com/repos/stefvanbuuren/chartcatalog/commits /dev/null
RUN R -e 'remotes::install_github("stefvanbuuren/chartcatalog")'

ADD https://api.github.com/repos/stefvanbuuren/chartbox/commits /dev/null
RUN R -e 'remotes::install_github("stefvanbuuren/chartbox")'

ADD https://api.github.com/repos/stefvanbuuren/jamesclient/commits /dev/null
RUN R -e 'remotes::install_github("stefvanbuuren/jamesclient")'

RUN R -e 'remotes::install_github("stefvanbuuren/curvematching")'

ADD https://api.github.com/repos/stefvanbuuren/minihealth/commits /dev/null
RUN R -e 'remotes::install_github("stefvanbuuren/minihealth")'

ADD https://api.github.com/repos/stefvanbuuren/growthscreener/commits /dev/null
RUN R -e 'remotes::install_github("stefvanbuuren/growthscreener")'
RUN R -e 'remotes::install_github("stefvanbuuren/chartplotter")'

ADD https://api.github.com/repos/stefvanbuuren/james/commits /dev/null
RUN R -e 'remotes::install_github("stefvanbuuren/james")'


# Move OpenCPU configuration files into place
ADD docker/opencpu_config/* /etc/opencpu/

CMD service cron start && apachectl -DFOREGROUND
