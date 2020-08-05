FROM opencpu/base as intermediate

# install for V8 package
RUN apt-get update && apt-get install -y libnode-dev

# repo_token.txt should be something like "GITHUB_PAT=624adeaa..."
# to be able to install packages from private repo's
COPY repo_token.txt .Renviron

# install R packages needed for JAMES
RUN \
    R -e 'install.packages("remotes")' \
    R -e 'remotes::install_github("stefvanbuuren/clopus")' \
    R -e 'remotes::install_github("stefvanbuuren/dscore")' \
    R -e 'remotes::install_github("stefvanbuuren/chartbox")' \
    R -e 'remotes::install_github("stefvanbuuren/brokenstick")' \
    R -e 'remotes::install_github("stefvanbuuren/minihealth")' \
    R -e 'remotes::install_github("stefvanbuuren/jamestest")' \
    R -e 'remotes::install_github("stefvanbuuren/growthscreener")' \
    R -e 'remotes::install_github("stefvanbuuren/james")'

# rebuild layer without .Renviron
FROM opencpu/base

LABEL maintainer="stef.vanbuuren@tno.nl" 

# re-install for V8 package
RUN apt-get update && apt-get install -y libnode-dev

# copy R libraries
COPY --from=intermediate /usr/local/lib/R/site-library /usr/local/lib/R/site-library

# modify preload section
COPY james.conf /etc/opencpu/server.conf

# restart
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf
RUN a2enconf servername
RUN apachectl restart

# install Arial
RUN mkdir /usr/share/fonts/truetype/arial/
COPY fonts/truetype/arial/* /usr/share/fonts/truetype/arial/

CMD service cron start && apachectl -DFOREGROUND
