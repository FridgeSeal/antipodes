FROM ubuntu:20.04

ARG USER_PW
ENV USER_PASSWORD=$USER_PW
ENV LANG=en_AU.UTF-8 \ LANGUAGE=en_US \ LC_ALL=en_AU.UTF-8

RUN useradd --create-home --home-dir /home/datadev --shell /bin/bash --gid root -G sudo --uid 1001 datadev
RUN echo "datadev:test123" | chpasswd

WORKDIR /home/datadev

RUN mkdir -p renv

COPY [".Rprofile", "./"]
COPY ["renv/activate.R", "renv/settings.dcf" ,"renv/"]

COPY [".Rprofile", "etl_script.R", "renv.lock", "antipodes.Rproj", "./"]
COPY ["renv/", "./renv/"]

WORKDIR "/app"
COPY ["startup_scripts/run_services.sh", "startup_scripts/setup_jupyter.sh", "startup_scripts/setup_rstudio.sh", "./"]


# Setup Rstudio SErver
RUN ./setup_rstudio.sh
# Setup Jupyterlab
RUN ./setup_jupyter.sh

# Setup package management as per docs
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@0.16.0')"
RUN R -e "renv::restore()"
# Run script to launch both
CMD ./run_services.sh

# Another approach would simply be to delegate this entire stack to a
# solution like "ml-workspace": https://github.com/ml-tooling/ml-workspace
# Where instead of building our own, we could simply rely on community-provided
# (and bugfixed) solutions, especially via their "R-flavour" docker image
