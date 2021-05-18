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
RUN R -e 'install.packages("vctrs")'  # needs minimal 0.3.8
RUN R -e 'install.packages("tidyverse")'
RUN R -e 'install.packages("remotes")'

# private repos
RUN R -e 'remotes::install_github("growthcharts/donorloader")'  # 1
RUN R -e 'remotes::install_github("growthcharts/curvematching")'

# public repos
RUN R -e 'install.packages("dscore")'
RUN R -e 'remotes::install_github("growthcharts/nlreferences")'
RUN R -e 'remotes::install_github("growthcharts/brokenstick")'
RUN R -e 'remotes::install_github("growthcharts/chartcatalog")'
RUN R -e 'remotes::install_github("growthcharts/chartbox")'
RUN R -e 'remotes::install_github("growthcharts/jamesdemodata")'
RUN R -e 'remotes::install_github("growthcharts/bdsreader")'
RUN R -e 'remotes::install_github("growthcharts/jamesclient")'
RUN R -e 'remotes::install_github("growthcharts/growthscreener")'
RUN R -e 'remotes::install_github("growthcharts/chartplotter")'

ADD https://api.github.com/repos/stefvanbuuren/james/commits /dev/null
RUN R -e 'remotes::install_github("growthcharts/james")'

# Prevent: "namespace 'vctrs' 0.3.6 is already loaded, but >= 0.3.8 is required"
# Remove symlink in "/usr/lib/opencpu/library" solves this:
RUN R -e 'remove.packages("vctrs", "/usr/lib/opencpu/library")'

# Move OpenCPU configuration files into place
ADD docker/opencpu_config/* /etc/opencpu/

CMD service cron start && apachectl -DFOREGROUND
