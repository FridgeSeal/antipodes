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
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.07.2-576-amd64.deb
gdebi rstudio-server-2022.07.2-576-amd64.deb

# Misc other dependencies (database etc)
wget https://packages.microsoft.com/ubuntu/20.04/prod/pool/main/m/msodbcsql18/msodbcsql18_18.1.2.1-1_amd64.deb
gdebi msodbcsql18_18.1.2.1-1_amd64.deb