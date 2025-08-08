FROM ubuntu:22.04 AS poky_builder

ENV POKY_VERSION=3.1.31
ENV POKY_INSTALL_ZIP_URL=https://remote.mistywest.com/Download/mh11/rzv2l/poky-mistysom-${POKY_VERSION}.zip

WORKDIR /builder
RUN apt-get update && apt-get install -y wget unzip
RUN wget -q ${POKY_INSTALL_ZIP_URL}
RUN unzip *.zip
RUN chmod +x *.sh

FROM ubuntu:22.04

LABEL org.opencontainers.image.source=https://github.com/MistySOM/DockerImages
ENV POKY_VERSION=3.1.31

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    file \
    python3-pip \
    xz-utils \
    && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

RUN --mount=type=bind,from=poky_builder,source=/builder,target=/mnt \
    /mnt/*.sh -y && \
    ln -s `find /opt -name "cortexa55-poky-linux"` `find /opt -name "cortexa55-poky-linux"`/../aarch64-poky-linux && \
    rm -rf /opt/poky/${POKY_VERSION}/sysroots/aarch64-poky-linux

SHELL ["/bin/bash", "-lc"]
RUN echo source /opt/poky/${POKY_VERSION}/environment-setup-aarch64-poky-linux >> ~/.profile
RUN echo export POKY_PYTHON=\"\${OECORE_NATIVE_SYSROOT}/usr/bin/python3\" >> ~/.profile
RUN echo export POKY_PIP=\"\${POKY_PYTHON} -m pip\" >> ~/.profile

ENTRYPOINT ["bash"]
