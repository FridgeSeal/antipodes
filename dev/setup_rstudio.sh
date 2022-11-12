#!/usr/bin/env bash
set -eux

# Setup R, and dependencies, instructions via R website
sudo apt update -qq
sudo apt install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

sudo apt install --no-install-recommends r-base

# Setup Rstudio server reqs
# instructions via: https://posit.co/download/rstudio-server/
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.07.2-576-amd64.deb
sudo gdebi rstudio-server-2022.07.2-576-amd64.deb

# Healthcheck install:
sudo rstudio-server verify-installation