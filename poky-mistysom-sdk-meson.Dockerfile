FROM ubuntu:22.04 AS builder

WORKDIR /builder

RUN apt-get update && apt-get install -y wget unzip

RUN wget -q https://github.com/JCWasmx86/mesonlsp/releases/download/v4.3.7/mesonlint-x86_64-unknown-linux-musl.zip && \
    unzip -o mesonlint-x86_64-unknown-linux-musl.zip

RUN wget -q https://github.com/JCWasmx86/mesonlsp/releases/download/v4.3.7/mesonlsp-x86_64-unknown-linux-musl.zip && \
    unzip -o mesonlsp-x86_64-unknown-linux-musl.zip

FROM ghcr.io/mistysom/poky-mistysom-sdk:3.1.31

LABEL org.opencontainers.image.source=https://github.com/MistySOM/DockerImages

RUN ${POKY_PYTHON} -m ensurepip
RUN ${POKY_PIP} install meson --upgrade

COPY --from=builder /builder/mesonlint /usr/bin/mesonlint
COPY --from=builder /builder/mesonlsp /usr/bin/mesonlsp
