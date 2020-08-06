install.packages(c('remotes'),
                 repos = 'http://cran.us.r-project.org',
                 dependencies = c("Depends", "Imports", "LinkingTo"))
pat <- Sys.getenv("GITHUB_PAT")
pat
remotes::install_github("stefvanbuuren/james")
