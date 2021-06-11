# docker JAMES - BDS version
FROM opencpu/base
ENV TZ="Europe/Amsterdam"
LABEL maintainer="stef.vanbuuren@tno.nl"

# install libnode-dev for V8 package
# install libfontconfig1-dev for systemfonts package
# create directory for Arial font
RUN apt-get update && \
    apt-get install -y libnode-dev && \
    apt -y install libfontconfig1-dev && \
    mkdir /usr/share/fonts/truetype/arial/

# Put a copy of our R code into the container
# WORKDIR /usr/local/src
# COPY . /usr/local/src/app
COPY docker/fonts/truetype/arial/* /usr/share/fonts/truetype/arial/
COPY docker/opencpu_config/Renviron .Renviron

# install R packages needed for JAMES
RUN R -e 'install.packages("remotes")' && \
    R -e 'remotes::install_github("growthcharts/james")' && \
    rm .Renviron

# Move OpenCPU configuration files into place - opt 3
COPY docker/opencpu_config/server.conf /etc/opencpu/
# Enable rewrite, then move apache2 config file into place
RUN a2enmod rewrite
ADD docker/apache2.conf /etc/apache2/

# Replace default apache2.conf containing rewrites
COPY docker/opencpu_config/apache2.conf /etc/apache2/

CMD service cron start && apachectl -DFOREGROUND
