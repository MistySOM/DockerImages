FROM ubuntu:22.04 AS builder

WORKDIR /builder

RUN apt-get update && apt-get install -y wget unzip

RUN wget -q https://github.com/microsoft/onnxruntime/releases/download/v1.18.1/onnxruntime-linux-x64-1.18.1.tgz -O onnxruntime.tar.gz
RUN tar -xvzf onnxruntime.tar.gz -C /opt/

RUN wget -q https://remote.mistywest.com/download/mh11/rzv2l/drpai-translator/r20ut5035ej0185-drp-ai-translator.zip
RUN unzip -o r20ut5035ej0185-drp-ai-translator.zip -d r20ut5035ej0185-drp-ai-translator
RUN mv r20ut5035ej0185-drp-ai-translator/* .
RUN chmod a+x ./DRP-AI_Translator-v*-Linux-x86_64-Install

FROM ghcr.io/mistysom/poky-mistysom-sdk:3.1.31

ARG PRODUCT="V2L"

# Install packages
RUN apt-get update && apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && apt-get clean
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    llvm-14-dev \
    libgl1-mesa-dev \
    locales \
    && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

RUN locale-gen en_US.UTF-8
ENV TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install onnxruntime
COPY --from=builder /opt/onnxruntime-linux-x64-1.18.1 /opt

# Install DRP-AI Translator
RUN --mount=type=bind,from=builder,source=/builder,target=/mnt \
    cd /opt && yes | /mnt/DRP-AI_Translator-v*-Linux-x86_64-Install

# Install Python packages
RUN pip3 install decorator psutil scipy attrs
RUN pip3 install torchvision==0.12.0 --index-url https://download.pytorch.org/whl/cpu
RUN pip3 install tensorflow tflite

# Clone repository
ENV TVM_ROOT="/drp-ai_tvm"
RUN git clone --recursive -depth 1 https://github.com/renesas-rz/rzv_drp-ai_tvm.git  ${TVM_ROOT}

# Set environment variables
ENV TVM_HOME="${TVM_ROOT}/tvm"
ENV PYTHONPATH="$TVM_HOME/python"
RUN echo 'export SDK="/opt/poky/`ls /opt/poky/`"' >> ~/.bashrc
ENV TRANSLATOR="/opt/drp-ai_translator_release"
ENV PRODUCT="${PRODUCT}"

# Setup environment
RUN cd ${TVM_ROOT} && bash setup/make_drp_env.sh

# Set WORKDIR
WORKDIR ${TVM_ROOT}
