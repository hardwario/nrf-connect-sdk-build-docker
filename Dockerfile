# Dockerfile for nRF Connect SDK v2.2.0
FROM ubuntu:22.04

# Install "openssh-client" + "unzip" + "python3-venv" packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install openssh-client python3-venv unzip \
    && rm -rf /var/lib/apt/lists/*

# Install NCS dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends \
    git cmake ninja-build gperf \
    ccache dfu-util device-tree-compiler wget \
    python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
    make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 \
    && rm -rf /var/lib/apt/lists/*

# Download GN tool
RUN wget --no-hsts --no-verbose -O gn.zip \
    https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/+/latest \
    && unzip gn.zip -d /opt/gn \
    && rm gn.zip

ENV PATH=/opt/gn:$PATH

# Set up Zephyr SDK (toolchain)
RUN wget --no-hsts --no-verbose \
    https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.1/zephyr-sdk-0.15.1_linux-x86_64.tar.gz \
    && wget --no-hsts --no-verbose -O - \
    https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.1/sha256.sum \
    | shasum --check --ignore-missing \
    && tar xf zephyr-sdk-0.15.1_linux-x86_64.tar.gz -C /opt \
    && rm zephyr-sdk-0.15.1_linux-x86_64.tar.gz \
    && /opt/zephyr-sdk-0.15.1/setup.sh -c -h -t all

# Set installation directory of Zephyr SDK
ENV ZEPHYR_SDK_INSTALL_DIR=/opt

# Create Python virtual environment
RUN python3 -m venv /venv

# Add Python virtual environment to PATH
ENV PATH=/venv/bin:$PATH

# Install required Python packages
# Source: https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v2.2.0/west.yml
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v3.2.99-ncs1/scripts/requirements.txt \
    && pip install --no-cache-dir -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v2.2.0/scripts/requirements.txt \
    && pip install --no-cache-dir -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-mcuboot/v1.9.99-ncs3/scripts/requirements.txt

# Set working directory
WORKDIR /build
