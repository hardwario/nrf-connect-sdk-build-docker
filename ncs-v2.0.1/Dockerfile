# Dockerfile for nRF Connect SDK v2.0.1
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND="noninteractive"

# Install SSH client
RUN apt-get update \
    && apt-get install -y openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install libncurses5
RUN apt-get update \
    && apt-get install -y libncurses5 \
    && rm -rf /var/lib/apt/lists/*

# 1. Install the required tools
# Add Kitware APT repository (needed for CMake)
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates gpg wget \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
       | gpg --dearmor - \
       | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' \
       | tee /etc/apt/sources.list.d/kitware.list >/dev/null \
    && apt-get update \
    && rm /usr/share/keyrings/kitware-archive-keyring.gpg \
    && apt-get install -y --no-install-recommends kitware-archive-keyring \
    && rm -rf /var/lib/apt/lists/*

# Install required dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \ 
    git cmake ninja-build gperf \
    ccache dfu-util device-tree-compiler wget \
    python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
    make gcc gcc-multilib g++-multilib libsdl2-dev unzip sudo \
    && rm -rf /var/lib/apt/lists/*


ENV CCACHE_DIR=/var/cache/ccache
RUN mkdir -p /var/cache/ccache && chmod 777 /var/cache/ccache

# Install GN tool
RUN wget -O gn.zip "https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/+/latest" \
    && unzip gn.zip -d /opt/gn \
    && rm gn.zip

# Add GN tool to PATH
ENV PATH=/opt/gn:$PATH

# 2. Install west
RUN pip3 install --no-cache-dir west

# 3. Get the nRF Connect SDK code - SKIP

# 4. Install additional Python dependencies
# pip3 install --user -r zephyr/scripts/requirements.txt
RUN pip3 install --no-cache-dir -r https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v3.0.99-ncs1/scripts/requirements.txt
# pip3 install --user -r nrf/scripts/requirements.txt
RUN pip3 install --no-cache-dir -r https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v2.0.0/scripts/requirements.txt
# pip3 install --user -r bootloader/mcuboot/scripts/requirements.txt
RUN pip3 install --no-cache-dir -r https://raw.githubusercontent.com/nrfconnect/sdk-mcuboot/v1.9.99-ncs1/scripts/requirements.txt

# 5. Install a Toolchain
ENV ZEPHYR_SDK_INSTALL_DIR=/opt
RUN wget --no-verbose https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.14.1/zephyr-sdk-0.14.1_linux-x86_64.tar.gz \
    && wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.14.1/sha256.sum | shasum --check --ignore-missing \
    && tar xf zephyr-sdk-0.14.1_linux-x86_64.tar.gz -C /opt \ 
    && rm zephyr-sdk-0.14.1_linux-x86_64.tar.gz \
    && /opt/zephyr-sdk-0.14.1/setup.sh -c -h -t all 

# Add user "build", switch to it, and use its home folder as a working directory
RUN useradd -ms /bin/bash build \
    && echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER build
WORKDIR /home/build
