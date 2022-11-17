#!/usr/bin/env bash
set -eux
apt-get install python3 pip -yq
pip install jupyter -U
pip install jupyterlab