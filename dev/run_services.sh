#!/usr/bin/env bash
set -eux

rstudio-server start
# Allow root call necessary on jupyter, as root access was a project requirement
# and jupyter cuts you off from the environment by default
jupyter lab -ip=0.0.0.0 --allow-root