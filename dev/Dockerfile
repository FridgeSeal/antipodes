FROM ubuntu:20.04

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
