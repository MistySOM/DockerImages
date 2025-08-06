FROM ghcr.io/mistysom/poky-mistysom-sdk:3.1.31

ENV POKY_VERSION="3.1.31"
ENV POKY_PYTHON="/opt/poky/${POKY_VERSION}/sysroots/x86_64-pokysdk-linux/usr/bin/python3"
ENV POKY_PIP="${POKY_PYTHON} -m pip"

RUN ${POKY_PYTHON} -m ensurepip
RUN ${POKY_PIP} install meson --upgrade
