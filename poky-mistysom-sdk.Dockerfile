FROM ubuntu:latest AS poky_builder

ENV POKY_VERSION=3.1.31
ENV POKY_INSTALL_ZIP_URL=https://remote.mistywest.com/Download/mh11/rzv2l/poky-mistysom-${POKY_VERSION}.zip

WORKDIR /builder
RUN apt-get update && apt-get install -y wget unzip
RUN wget -q ${POKY_INSTALL_ZIP_URL}
RUN unzip *.zip
RUN chmod +x *.sh

FROM python:3.8

LABEL org.opencontainers.image.source=https://github.com/MistySOM/DockerImages
ENV POKY_VERSION=3.1.31

RUN --mount=type=bind,from=poky_builder,source=/builder,target=/mnt \
    /mnt/*.sh -y && \
    rm -rf /opt/poky/${POKY_VERSION}/sysroots/aarch64-poky-linux

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

SHELL ["/bin/bash", "-lc"]
RUN echo "source /opt/poky/${POKY_VERSION}/environment-setup-aarch64-poky-linux" >> ~/.bashrc
RUN echo "export POKY_PYTHON='${OECORE_NATIVE_SYSROOT}/usr/bin/python3'" >> ~/.bashrc
RUN echo "export POKY_PIP='${POKY_PYTHON} -m pip'" >> ~/.bashrc

ENTRYPOINT ["bash"]
