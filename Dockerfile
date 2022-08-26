ARG BASE_IMAGE=senzing/senzingapi-tools:3.2.0

ARG IMAGE_NAME="senzing/senzing-console"
ARG IMAGE_MAINTAINER="support@senzing.com"
ARG IMAGE_VERSION="1.2.0"

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS builder

# Set Shell to use for RUN commands in builder step.

ENV REFRESHED_AT=2022-08-26

# Run as "root" for system installation.

USER root

# Install packages via apt for building fio.

RUN apt-get update \
 && apt-get -y install \
      gcc \
      make \
      pkg-config \
      unzip \
      wget \
 && rm -rf /var/lib/apt/lists/*

# Work around until Debian repos catch up to modern versions of fio.

RUN mkdir /tmp/fio \
 && cd /tmp/fio \
 && wget https://github.com/axboe/fio/archive/refs/tags/fio-3.30.zip \
 && unzip fio-3.30.zip \
 && cd fio-fio-3.30/ \
 && ./configure \
 && make \
 && make install \
 && fio --version \
 && cd \
 && rm -rf /tmp/fio

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

# Create the runtime image.

FROM ${BASE_IMAGE} AS runner

ARG IMAGE_NAME
ARG IMAGE_MAINTAINER
ARG IMAGE_VERSION

LABEL Name=${IMAGE_NAME} \
      Maintainer=${IMAGE_MAINTAINER} \
      Version=${IMAGE_VERSION}

# Define health check.

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      elvis-tiny \
      htop \
      iotop \
      jq \
      net-tools \
      openssh-server \
      postgresql-client \
      procps \
      python3-dev \
      python3-pip \
      strace \
      tree \
      unzip \
      wget \
      zip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install packages via pip.

COPY requirements.txt .
RUN pip3 install --upgrade pip \
 && pip3 install -r requirements.txt \
 && rm /requirements.txt

# Copy files from repository.

COPY ./rootfs /

# Copy files from prior stages.

COPY --from=builder "/usr/local/bin/fio" "/usr/local/bin/fio"

# Runtime environment variables.

ENV SENZING_ETC_PATH=/etc/opt/senzing \
    SENZING_SSHD_SHOW_PERFORMANCE_WARNING=true

# Runtime execution.

WORKDIR /app
CMD ["/app/sleep-infinity.sh"]
