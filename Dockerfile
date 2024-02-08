# Dockerfile for nRF Connect SDK v2.5.0
FROM ubuntu:22.04

# Create directory for ccache and set its permissions
RUN mkdir /var/cache/ccache && chmod 777 /var/cache/ccache

# Set environmental variable for ccache
ENV CCACHE_DIR=/var/cache/ccache

# Install "openssh-client" + "patch" + "python3-venv" + "unzip" packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install openssh-client patch python3-venv unzip jq \
    && rm -rf /var/lib/apt/lists/*

# Install NCS dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends \
    git cmake ninja-build gperf \
    ccache dfu-util device-tree-compiler wget \
    python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
    make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download GN tool
RUN wget -q -O gn.zip \
    https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/+/latest \
    && unzip gn.zip -d /opt/gn \
    && rm gn.zip

# Add GN tool to PATH
ENV PATH=/opt/gn:$PATH

# Set up Zephyr SDK (toolchain)
RUN wget -q \
    https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.1/zephyr-sdk-0.16.1_linux-x86_64.tar.xz \
    && wget -q -O - \
    https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.1/sha256.sum \
    | shasum --check --ignore-missing \
    && tar xf zephyr-sdk-0.16.1_linux-x86_64.tar.xz -C /opt \
    && rm zephyr-sdk-0.16.1_linux-x86_64.tar.xz \
    && /opt/zephyr-sdk-0.16.1/setup.sh -t all -h -c \
    && bash -c 'rm -rf /opt/zephyr-sdk-0.16.1/{aarch64*,arc64*,arc*,microblazeel*,mips*,nios2*,riscv64*,sparc*,x86_64*,xtensa*}'

RUN ls -lha /opt/zephyr-sdk-0.16.1

# Set installation directory of Zephyr SDK
ENV ZEPHYR_SDK_INSTALL_DIR=/opt

# Install required Python packages
# Source: https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v2.5.0/west.yml
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v3.4.99-ncs1/scripts/requirements.txt \
    && pip install --no-cache-dir -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v2.5.0/scripts/requirements.txt \
    && pip install --no-cache-dir -r \
    https://raw.githubusercontent.com/nrfconnect/sdk-mcuboot/v1.10.99-ncs1/scripts/requirements.txt
