#!/bin/bash
set -e
docker build . -t buildroot
docker run -it -v $(pwd)/.ccache:/ccache -v $(pwd)/output:/buildroot/output buildroot
