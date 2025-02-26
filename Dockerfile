# Dockerfile for nRF Connect SDK v2.9.0
FROM ubuntu:22.04

# Create directory for ccache and set its permissions
RUN mkdir /var/cache/ccache && chmod 777 /var/cache/ccache

# Set environmental variable for ccache
ENV CCACHE_DIR=/var/cache/ccache

# Install "openssh-client" + "patch" + "python3-venv" + "unzip" packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy install \
    openssh-client patch python3-pip python3-venv unzip wget jq apt-utils build-essential gcc gcc-multilib g++-multilib

# Install nRF Command Line Tools
RUN wget https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/10-24-2/nrf-command-line-tools_10.24.2_amd64.deb -O nrf-command-line-tools_10.24.2_amd64.deb \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qy ./nrf-command-line-tools_10.24.2_amd64.deb \
    && rm nrf-command-line-tools_10.24.2_amd64.deb

#  Install nrfutil
RUN wget "https://files.nordicsemi.com/ui/api/v1/download?repoKey=swtools&path=external/nrfutil/executables/x86_64-unknown-linux-gnu/nrfutil&isNativeBrowsing=false" -O /usr/local/bin/nrfutil \
    && chmod +x /usr/local/bin/nrfutil

RUN nrfutil install toolchain-manager
RUN nrfutil toolchain-manager install --ncs-version v2.9.0 --install-dir /opt
RUN nrfutil toolchain-manager env --as-script --install-dir /opt

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/toolchains/b77d8c1312/usr/bin:/opt/toolchains/b77d8c1312/usr/bin:/opt/toolchains/b77d8c1312/usr/local/bin:/opt/toolchains/b77d8c1312/opt/bin:/opt/toolchains/b77d8c1312/opt/nanopb/generator-bin:/opt/toolchains/b77d8c1312/opt/zephyr-sdk/arm-zephyr-eabi/bin:/opt/toolchains/b77d8c1312/opt/zephyr-sdk/riscv64-zephyr-elf/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/toolchains/b77d8c1312/usr/lib:/opt/toolchains/b77d8c1312/usr/lib/x86_64-linux-gnu:/opt/toolchains/b77d8c1312/usr/local/lib:$LD_LIBRARY_PATH
ENV GIT_EXEC_PATH=/opt/toolchains/b77d8c1312/usr/local/libexec/git-core
ENV GIT_TEMPLATE_DIR=/opt/toolchains/b77d8c1312/usr/local/share/git-core/templates
ENV PYTHONHOME=/opt/toolchains/b77d8c1312/usr/local
ENV PYTHONPATH=/opt/toolchains/b77d8c1312/usr/local/lib/python3.12:/opt/toolchains/b77d8c1312/usr/local/lib/python3.12/site-packages
ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV ZEPHYR_SDK_INSTALL_DIR=/opt/toolchains/b77d8c1312/opt/zephyr-sdk

