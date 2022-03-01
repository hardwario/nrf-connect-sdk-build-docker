FROM ubuntu:20.04

ARG DEBIAN_FRONTEND="noninteractive"

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
       make gcc gcc-multilib g++-multilib libsdl2-dev unzip \
    && rm -rf /var/lib/apt/lists/*

# Install GNU Arm Embedded Toolchain
RUN wget -O archive.tar.bz2 "https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2?revision=108bd959-44bd-4619-9c19-26187abf5225&la=en&hash=E788CE92E5DFD64B2A8C246BBA91A249CB8E2D2D" \
    && echo fe0029de4f4ec43cf7008944e34ff8cc archive.tar.bz2 > /tmp/archive.md5 \
    && md5sum -c /tmp/archive.md5 \
    && rm /tmp/archive.md5 \
    && tar xf archive.tar.bz2 -C /opt \
    && rm archive.tar.bz2

# Set Zephyr build environment variables
ENV GNUARMEMB_TOOLCHAIN_PATH=/opt/gcc-arm-none-eabi-9-2019-q4-major/
ENV ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb

# Install GN tool
RUN wget -O gn.zip https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/+/latest \
    && unzip gn.zip -d /opt/gn \
    && rm gn.zip

# Add GN tool to PATH
ENV PATH=/opt/gn:$PATH

# Install West tool
RUN pip3 install --no-cache-dir west

# The following step replaces complete West workspace initialization just to install
# required Python dependencies from multiple Git repositories
RUN mkdir -p /tmp/nrf/scripts \
    && cd /tmp/nrf/scripts \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v1.8.0/scripts/requirements.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v1.8.0/scripts/requirements-base.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v1.8.0/scripts/requirements-build.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-nrf/v1.8.0/scripts/requirements-doc.txt \
    && mkdir -p /tmp/zephyr/scripts \
    && cd /tmp/zephyr/scripts \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v2.7.0-ncs1/scripts/requirements.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v2.7.0-ncs1/scripts/requirements-base.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v2.7.0-ncs1/scripts/requirements-build-test.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v2.7.0-ncs1/scripts/requirements-doc.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v2.7.0-ncs1/scripts/requirements-run-test.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v2.7.0-ncs1/scripts/requirements-extras.txt \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-zephyr/v2.7.0-ncs1/scripts/requirements-compliance.txt \
    && mkdir -p /tmp/bootloader/mcuboot/scripts \
    && cd /tmp/bootloader/mcuboot/scripts \
    && wget https://raw.githubusercontent.com/nrfconnect/sdk-mcuboot/v1.7.99-ncs4/scripts/requirements.txt \
    && cd /tmp \
    && pip3 install --no-cache-dir -r zephyr/scripts/requirements.txt \
    && pip3 install --no-cache-dir -r nrf/scripts/requirements.txt \
    && pip3 install --no-cache-dir -r bootloader/mcuboot/scripts/requirements.txt \
    && rm -rf /tmp/*

# Create directory for Ccache with proper rights
RUN mkdir -p /.ccache \
    && chmod 777 /.ccache

WORKDIR /build
