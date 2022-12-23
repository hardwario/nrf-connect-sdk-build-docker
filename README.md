<a href="https://www.hardwario.com"><img src="https://www.hardwario.com/ci/assets/hw-logo.svg" width="200" alt="HARDWARIO Logo"></a>

# nrf-connect-sdk-build-docker
# Build Environment for nRF Connect SDK

[![CI](https://github.com/hardwario/nrf-connect-sdk-build-docker/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/hardwario/nrf-connect-sdk-build-docker/actions/workflows/main.yml)

This repository contains **Dockerfile** definitions for the **nRF Connect SDK** (NCS) version `v2.2.0` (uses **Zephyr SDK** `v0.15.1`). It is useful for continuous integration builds and/or quick setup of the development environment on any desktop machine.

The environment is based on **Ubuntu 22.04** and follows the instructions for [**manual installation**](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/gs_installing.html) provided by **Nordic Semiconductor**.

The pre-built **Docker** image is available on **Docker Hub**:<br>
https://hub.docker.com/r/hardwario/nrf-connect-sdk-build

## Building

Start **Docker** build:

```
docker build -t hardwario/nrf-connect-sdk-build:v2.2.0 .
```

## Alias

For more convenient usage, we recommended adding this alias to your shell:

```
alias dwest="docker run --rm -it -v `pwd`:/home/build/workspace hardwario/nrf-connect-sdk-build:v2.2.0 west"
```

Reload your shell environment and test the functionality:

```
dwest --version
```

## Usage

In the case of an alias, to build a project, you have to call the `dwest` command from the top-level directory of the **West** workspace.

Example:

```
dwest build -b <BOARD_NAME> zephyr/samples/basic/blinky -d zephyr/samples/basic/blinky/build
```

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT) - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ by [**HARDWARIO a.s.**](https://www.hardwario.com) in the heart of Europe.
