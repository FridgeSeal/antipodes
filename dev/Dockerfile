FROM ubuntu:20.04

WORKDIR "/app"
COPY ["run_services.sh", "setup_jupyter.sh", "setup_rstudio.sh", "./"]

# Setup Rstudio SErver
RUN ./setup_rstudio.sh
# Setup Jupyterlab
RUN ./setup_jupyter.sh
# Run script to launch both
CMD ./run_services.sh

# Another approach would simply be to delegate this entire stack to a
# solution like "ml-workspace": https://github.com/ml-tooling/ml-workspace
# Where instead of building our own, we could simply rely on community-provided
# (and bugfixed) solutions, especially via their "R-flavour" docker image
