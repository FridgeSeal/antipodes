FROM ubuntu:20.04

ENV LANG=en_AU.UTF-8 \ LANGUAGE=en_US \ LC_ALL=en_AU.UTF-8

RUN useradd --create-home --home-dir /home/datadev --shell /bin/bash --gid root -G sudo --uid 1001 datadev
RUN echo "datadev:change_me" | chpasswd

WORKDIR /home/datadev

RUN mkdir -p renv

COPY [".Rprofile", "./"]
COPY ["renv/activate.R", "renv/settings.dcf" ,"renv/"]

COPY [".Rprofile", "etl_script.R", "renv.lock", "antipodes.Rproj", "./"]
COPY ["renv/", "./renv/"]

WORKDIR "/app"
COPY ["setup_scripts/run_services.sh", "setup_scripts/setup_jupyter.sh", "setup_scripts/setup_rstudio.sh", "./"]


# Setup Rstudio SErver
RUN ./setup_rstudio.sh
# Setup Jupyterlab
RUN ./setup_jupyter.sh

CMD ./run_services.sh

# Another approach would simply be to delegate this entire stack to a
# solution like "ml-workspace": https://github.com/ml-tooling/ml-workspace
# Where instead of building our own, we could simply rely on community-provided
# (and bugfixed) solutions, especially via their "R-flavour" docker image
