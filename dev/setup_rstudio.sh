#!/usr/bin/env bash
set -eux

# Setup R, and dependencies, instructions via R website
apt-get update -yqq
apt-get install --no-install-recommends software-properties-common dirmngr wget -yq
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

apt-get install --no-install-recommends r-base -yq

# Setup Rstudio server reqs
# instructions via: https://posit.co/download/rstudio-server/
apt-get install gdebi-core -yq
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.07.2-576-amd64.deb
gdebi -nq rstudio-server-2022.07.2-576-amd64.deb

# Healthcheck install:
# rstudio-server verify-installation
# rstudio starts up on install.