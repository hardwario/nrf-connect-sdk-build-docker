<a href="https://www.hardwario.com/"><img src="https://www.hardwario.com/ci/assets/hw-logo.svg" width="200" alt="HARDWARIO Logo" align="right"></a>

# Build environment for nRF Connect SDK (NCS)

[![CI](https://github.com/hardwario/nrf-connect-sdk-build-docker/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/hardwario/nrf-connect-sdk-build-docker/actions/workflows/main.yml)

Docker for building firmware based on the [nRF Connect SDK](https://www.nordicsemi.com/Products/Development-software/nRF-Connect-SDK) 


https://hub.docker.com/r/hardwario/nrf-connect-sdk-build


## Tags 

### v1.9.0-1

Contains:
* tools for build nRF Connect SDK v1.9.0
* GNU Arm Embedded Toolchain 9-2019-q4-major

### v1.8.0-1

Contains:
* tools for build nRF Connect SDK v1.8.0
* GNU Arm Embedded Toolchain 9-2019-q4-major

## Docs

* https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/gs_installing.html







## Example

```
cd application
docker run --rm -it -v `pwd`/..:`pwd`/.. -w `pwd` -u `id -u`:`id -g` hardwario/zephyr-build:latest west build
```


## Hint
For easier using recommended add alias to ~/.bashrc
```
alias dwest='docker run --rm -it -v `pwd`/..:`pwd`/.. -w `pwd` -u `id -u`:`id -g` hardwario/zephyr-build:latest'
```

## Workdir
* /builds

## Local build

```
docker build -t hardwario/zephyr-build:latest .
```


docker build -t hardwario/chester-app-build:latest .


docker build -t hardwario/nrf-connect-sdk-build:latest .

docker run --rm -it -v `pwd`/../../..:`pwd`/../../.. -w `pwd` -u `id -u`:`id -g` hardwario/nrf-connect-sdk-build:latest west build

chester-app-build
chester-lte-build

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT/) - see the [LICENSE](LICENSE) file for details.

---

Made with &#x2764;&nbsp; by [**HARDWARIO s.r.o.**](https://www.hardwario.com/) in the heart of Europe.
