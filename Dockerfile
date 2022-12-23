# Dockerfile for nRF Connect SDK v2.2.0
FROM ubuntu:22.04

# Add user (and group) "build"
RUN useradd -ms /bin/bash build

# Install "openssh-client" + "unzip" packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install openssh-client unzip \
    && rm -rf /var/lib/apt/lists/*

# Install NCS dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends \
    git cmake ninja-build gperf \
    ccache dfu-util device-tree-compiler wget \
    python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
    make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 \
    && rm -rf /var/lib/apt/lists/*

# Switch to user "build"
USER build

# Set working directory
WORKDIR /home/build

# Create "~/.local/opt" directory
RUN mkdir -m 700 -p ~/.local/opt

# Download GN tool
RUN wget --no-hsts --no-verbose -O gn.zip \
    https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/+/latest \
    && unzip gn.zip -d ~/.local/opt/gn \
    && rm gn.zip

# Set up Zephyr SDK (toolchain)
RUN wget --no-hsts --no-verbose \
    https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.1/zephyr-sdk-0.15.1_linux-x86_64.tar.gz \
    && wget --no-hsts --no-verbose -O - \
    https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.1/sha256.sum \
    | shasum --check --ignore-missing \
    && tar xf zephyr-sdk-0.15.1_linux-x86_64.tar.gz -C ~/.local/opt \
    && rm zephyr-sdk-0.15.1_linux-x86_64.tar.gz \
    && ~/.local/opt/zephyr-sdk-0.15.1/setup.sh -c -h -t all

# Install required Python packages
# Source: https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v2.2.0/west.yml
RUN pip3 install --user --no-cache-dir --no-warn-script-location -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v3.2.99-ncs1/scripts/requirements.txt \
    && pip3 install --user --no-cache-dir --no-warn-script-location -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v2.2.0/scripts/requirements.txt \
    && pip3 install --user --no-cache-dir --no-warn-script-location -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-mcuboot/v1.9.99-ncs3/scripts/requirements.txt

# Create "workspace" directory
RUN mkdir workspace

# Use "workspace" as working directory
WORKDIR /home/build/workspace

# Set environmental variables
ENV PATH=/home/build/.local/bin:/home/build/.local/opt/gn:$PATH
ENV ZEPHYR_SDK_INSTALL_DIR=/home/build/opt
