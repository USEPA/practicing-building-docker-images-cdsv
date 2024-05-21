# The image is based off of the rocker base image, which you can learn about here:
# https://rocker-project.org/
# The image is based off of ubuntu, but then runs a few scripts to install R and R shiny
FROM rocker/shiny:4.4.0

# I added this label, though it doesn't do anything
LABEL name=ContDataSumViz

# This part is the part that installs the system packages, usually needed for use in compiling some R package.
# I just added packages to this list as I got errors
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    default-jdk \
    r-cran-rjava \
    r-base-dev dh-r automake \
    libharfbuzz-dev  libfribidi-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    libgdal-dev \
    libudunits2-dev \
    cmake \
    && apt-get clean

# This sets the main path in the docker image to /app, which is a standard practice.
WORKDIR /app

# Fix for compilation issues related to 
# > format not a string literal and no format arguments
# This overrides default compilation parameters to disable some security checks which
# prevent some R packages from compiling
# DISABLING!! This fixes don't seem to be needed in 4.3.0. 
# RUN mkdir ~/.R
# RUN echo "CFLAGS=-Wno-format-security" > ~/.R/Makevars
# This one seemed to break some packages:
# RUN echo "PKG_CPPFLAGS=-Wno-format-security" >> ~/.R/Makevars

# changed this part to not use renv (I'm experimenting)
RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'install_all_packages_in_lockfile.R'

# This part copies in the rest of the project
COPY . /app

# This sets what is run when the docker image is run
CMD ["Rscript", "run.R"]
