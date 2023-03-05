<a href="https://www.hardwario.com"><img src="https://www.hardwario.com/ci/assets/hw-logo.svg" width="200" alt="HARDWARIO Logo"></a>

# nrf-connect-sdk-build-docker
# Build Environment for nRF Connect SDK

[![CI](https://github.com/hardwario/nrf-connect-sdk-build-docker/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/hardwario/nrf-connect-sdk-build-docker/actions/workflows/main.yml)

This repository contains **Dockerfile** for the **nRF Connect SDK** (NCS) version `v2.3.0` (this release uses **Zephyr SDK** `v0.15.2` as the validated toolchain). The **Docker** image is helpful for **CI/CD** pipelines or quick setup of the development environment on any desktop machine.

The environment is based on **Ubuntu 22.04 LTS** and follows the instructions for [**manual installation**](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/gs_installing.html) provided by **Nordic Semiconductor**.

The pre-built **Docker** image is available on **Docker Hub**:<br>
**https://hub.docker.com/r/hardwario/nrf-connect-sdk-build**

## Build Docker Image

Clone this **Git** repository:

```
git clone https://github.com/hardwario/nrf-connect-sdk-build-docker.git
```

Go to the **Git** repository:

```
cd nrf-connect-sdk-build-docker
```

Build the **Docker** image using this command:

```
docker build -t nrf-connect-sdk-build:v2.3.0 .
```

## Test Docker Image

Run this command to print the **West** tool version:

```
docker run --rm -it nrf-connect-sdk-build:v2.3.0 west --version
```

## Build Firmware

Run this command to build firmware using the **Docker** image:

```
sh -c 'docker run --rm -it -u $(id -u):$(id -g) -v $(pwd):/build -w /build/zephyr/samples/basic/blinky nrf-connect-sdk-build:v2.3.0 west build -b <BOARD_NAME>'
```

> This command must be run from the root directory of your **West** workspace. Note that the `docker` command is encapsulated under the `sh` command, so the users of the **Fish** shell can evaluate this example seamlessly. Do not forget to replace the `<BOARD_NAME>` parameter with the real board.

## License

This project is licensed under the [**MIT License**](https://opensource.org/licenses/MIT) - see the [**LICENSE**](LICENSE) file for details.

---

Made with ❤️ by [**HARDWARIO a.s.**](https://www.hardwario.com) in the heart of Europe.
