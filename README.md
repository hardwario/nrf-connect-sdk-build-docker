<a href="https://www.hardwario.com"><img src="https://www.hardwario.com/ci/assets/hw-logo.svg" width="200" alt="HARDWARIO Logo"></a>

# Build Environment for nRF Connect SDK

[![CI](https://github.com/hardwario/nrf-connect-sdk-build-docker/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/hardwario/nrf-connect-sdk-build-docker/actions/workflows/main.yml)

This repository contains Dockerfile definitions for all versions of nRF Connect SDK (NCS) from version `v1.8.0+`. It is useful for continuous integration builds and/or quick setup of the development environment on any desktop machine.

The environment is based on Ubuntu 20.04 and follows the instructions for [manual installation](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/gs_installing.html) provided by Nordic Semiconductor.

The pre-built Docker image is available on Docker Hub:<br>
https://hub.docker.com/r/hardwario/nrf-connect-sdk-build

## Releases

Here is the list of the supported releases:

```
nRF Connect SDK v2.0.1 (uses Zephyr Software Development Kit (SDK) v0.14.1)
nRF Connect SDK v2.0.0 (uses Zephyr Software Development Kit (SDK) v0.14.1)
nRF Connect SDK v1.9.1 (uses GNU Arm Embedded Toolchain 9-2019-q4-major)
nRF Connect SDK v1.9.0 (uses GNU Arm Embedded Toolchain 9-2019-q4-major)
nRF Connect SDK v1.8.0 (uses GNU Arm Embedded Toolchain 9-2019-q4-major)
```

## Building

Start Docker build (replace `X.Y.Z` with the desired version):

```
docker build -t nrf-connect-sdk-build:vX.Y.Z ncs-vX.Y.Z
```

## Alias

For a more convenient usage, we recommended to add this alias to your shell (replace `X.Y.Z` with the desired version):

```
alias dwest="docker run --rm -it -v `pwd`:/home/build hardwario/nrf-connect-sdk-build:vX.Y.Z west"
```

Reload your shell environment and test the functionality:

```
dwest --version
```

## Usage

In case of alias, in order to build a project, you have to call the `dwest` command from the top level directory of the West workspace.

Example:

```
dwest build -b <BOARD_NAME> zephyr/samples/basic/blinky -d zephyr/samples/basic/blinky/build
```

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT) - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ by [**HARDWARIO a.s.**](https://www.hardwario.com) in the heart of Europe.
