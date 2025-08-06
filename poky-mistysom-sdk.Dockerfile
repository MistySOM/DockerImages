FROM ubuntu:latest AS poky_builder

ENV POKY_VERSION=3.1.31
ENV POKY_INSTALL_ZIP_FILENAME=poky-mistysom-${POKY_VERSION}.zip
ENV POKY_INSTALL_ZIP_URL=https://remote.mistywest.com/Download/mh11/rzv2l/${POKY_INSTALL_ZIP_FILENAME}
ENV POKY_INSTALL_SH_FILENAME=poky-glibc-x86_64-mistysom-image-aarch64-smarc-rzv2l-toolchain-${POKY_VERSION}.sh

WORKDIR /builder
RUN apt-get update && apt-get install -y wget unzip
RUN wget ${POKY_INSTALL_ZIP_URL}
RUN unzip ${POKY_INSTALL_ZIP_FILENAME}
RUN chmod +x ${POKY_INSTALL_SH_FILENAME}

FROM python:3.8

LABEL org.opencontainers.image.source=https://github.com/MistySOM/
RUN --mount=type=bind,from=poky_builder,source=/builder,target=/mnt \
    /mnt/*.sh -y

ENTRYPOINT ["bash"]
