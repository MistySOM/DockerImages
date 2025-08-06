FROM ghcr.io/mistysom/poky-mistysom-sdk:3.1.31

ENV POKY_VERSION="3.1.31"
ENV POKY_PYTHON="/opt/poky/${POKY_VERSION}/sysroots/x86_64-pokysdk-linux/usr/bin/python3"
ENV POKY_PIP="${POKY_PYTHON} -m pip"

RUN ${POKY_PYTHON} -m ensurepip
RUN ${POKY_PIP} install meson --upgrade

RUN wget -q https://github.com/JCWasmx86/mesonlsp/releases/download/v4.3.7/mesonlint-x86_64-unknown-linux-musl.zip && \
    unzip -o mesonlint-x86_64-unknown-linux-musl.zip && \
    rm mesonlint-x86_64-unknown-linux-musl.zip && \
    mv mesonlint /usr/bin/mesonlsp

RUN wget -q https://github.com/JCWasmx86/mesonlsp/releases/download/v4.3.7/mesonlsp-x86_64-unknown-linux-musl.zip && \
    unzip -o mesonlsp-x86_64-unknown-linux-musl.zip && \
    rm mesonlsp-x86_64-unknown-linux-musl.zip && \
    mv mesonlsp /usr/bin/mesonlsp
