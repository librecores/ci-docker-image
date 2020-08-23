# The MIT License
#
#  Copyright (c) 2016, Oleg Nenashev

#
# Stage: Verilator
#
# TODO: move this upstream: change is install to opt
FROM ubuntu:20.04 as verilator-builder
ARG VERILATOR_VERSION
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get install --no-install-recommends -y \
                        autoconf \
                        bc \
                        bison \
                        build-essential \
                        ca-certificates \
                        ccache \
                        flex \
                        git \
                        libfl-dev \
                        libgoogle-perftools-dev \
                        perl \
                        python3
RUN git clone https://github.com/verilator/verilator /tmp/verilator
WORKDIR /tmp/verilator
RUN git checkout "v${VERILATOR_VERSION}"
RUN autoconf
RUN ./configure --prefix=/opt/verilator
RUN make -j "$(nproc)"
RUN make install

#
# Stage: icarus
#
FROM ubuntu:20.04 as icarus-builder
ARG ICARUS_VERSION
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get install --no-install-recommends -y \
                        autoconf \
                        bison \
                        build-essential \
                        ca-certificates \
                        flex \
                        git \
                        gperf
RUN git clone https://github.com/steveicarus/iverilog /tmp/iverilog
WORKDIR /tmp/iverilog
RUN git checkout "v${ICARUS_VERSION}"
RUN autoconf
RUN ./configure --prefix=/opt/iverilog
RUN make -j "$(nproc)"
RUN make install

#
# Stage: Verible
#
FROM ubuntu:20.04 as verible-builder
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y wget
ARG VERIBLE_VERSION
RUN wget https://github.com/google/verible/releases/download/${VERIBLE_VERSION}/verible-${VERIBLE_VERSION}-Ubuntu-19.10-eoan-x86_64.tar.gz  -O verible.tar.gz
RUN mkdir /opt/verible
RUN tar xzf verible.tar.gz -C /opt/verible --strip 1

#
# Stage: yosys
#
FROM ubuntu:20.04 as yosys-builder
ARG YOSYS_VERSION
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bison \
    ca-certificates \
    curl \
    gcc \
    git \
    flex \
    gawk \
    libffi-dev \
    libreadline-dev \
    pkg-config \
    python3 \
    tcl-dev
RUN git clone https://github.com/YosysHQ/yosys /tmp/yosys
WORKDIR /tmp/yosys
RUN git checkout yosys-${YOSYS_VERSION}
ENV PREFIX=/opt/yosys
RUN make config-gcc
RUN make -j "$(nproc)"
RUN make install

#
# Stage: Our actual image
#
FROM ubuntu:20.04
LABEL maintainer "Oleg Nenashev <o.v.nenashev@gmail.com>"
LABEL maintainer "Stefan Wallentowitz <stefan@wallentowitz.de>"
LABEL Description="This is the default LibreCores CI Image" Vendor="Librecores" Version="2020.6"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 python3-pip python-is-python3 perl git ccache \
    libtcl \
    gcc-riscv64-linux-gnu g++-riscv64-linux-gnu \
    libelf-dev

ARG FUSESOC_VERSION
RUN pip3 install fusesoc==${FUSESOC_VERSION}

ARG COCOTB_VERSION
RUN pip3 install cocotb==${COCOTB_VERSION}

ARG PYTEST_VERSION
RUN pip3 install pytest==${PYTEST_VERSION}

ARG TAPPY_VERSION
RUN pip3 install tap.py==${TAPPY_VERSION}

COPY --from=verilator-builder /opt/verilator /opt/verilator
ENV PATH=/opt/verilator/bin:${PATH}

COPY --from=icarus-builder /opt/iverilog /opt/iverilog
ENV PATH=/opt/iverilog/bin:${PATH}

COPY --from=verible-builder /opt/verible /opt/verible
ENV PATH=/opt/verible/bin:${PATH}

COPY --from=yosys-builder /opt/yosys /opt/yosys
ENV PATH=/opt/yosys/bin:${PATH}

