FROM ubuntu:22.10

# Setup Rstudio SErver
RUN ./setup_rstudio.sh
# Setup Jupyterlab
RUN ./setup_jupyter.sh
# Run script to launch both
CMD ./run_services.sh