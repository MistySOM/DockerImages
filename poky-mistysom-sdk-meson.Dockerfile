FROM ghcr.io/mistysom/poky-mistysom-sdk:3.1.31

SHELL ["/bin/bash", "-lc"]

ENV POKY_PYTHON="${OECORE_NATIVE_SYSROOT}/usr/bin/python3"
ENV POKY_PIP="${POKY_PYTHON} -m pip"

RUN ${POKY_PYTHON} -m ensurepip
RUN ${POKY_PIP} install meson --upgrade

RUN wget -q https://github.com/JCWasmx86/mesonlsp/releases/download/v4.3.7/mesonlint-x86_64-unknown-linux-musl.zip && \
    unzip -o mesonlint-x86_64-unknown-linux-musl.zip && \
    mv mesonlint /usr/bin/mesonlsp && \    
    rm -rf ./*

RUN wget -q https://github.com/JCWasmx86/mesonlsp/releases/download/v4.3.7/mesonlsp-x86_64-unknown-linux-musl.zip && \
    unzip -o mesonlsp-x86_64-unknown-linux-musl.zip && \
    mv mesonlsp /usr/bin/mesonlsp && \
    rm -rf ./*
