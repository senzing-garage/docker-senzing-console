ARG BASE_IMAGE=senzing/senzingapi-tools:3.12.8@sha256:dd393e76374a8c925892418877e767cf1afbe609f1aa107a4336227c348f1448

ARG IMAGE_NAME="senzing/senzing-console"
ARG IMAGE_MAINTAINER="support@senzing.com"
ARG IMAGE_VERSION="1.2.11"

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS builder

# Set Shell to use for RUN commands in builder step.

ENV REFRESHED_AT=2024-06-24

# Run as "root" for system installation.

USER root

# Install packages via apt for building fio.

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
  gcc \
  make \
  pkg-config \
  unzip \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Work around until Debian repos catch up to modern versions of fio.

RUN mkdir /tmp/fio \
  && wget -P /tmp/fio https://github.com/axboe/fio/archive/refs/tags/fio-3.30.zip \
  && unzip /tmp/fio/fio-3.30.zip \
  && ls -al \
  && ls -al /tmp/fio/ \
  && /tmp/fio/fio-fio-3.30/configure \
  && make \
  && make install \
  && fio --version \
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

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
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
  python3-pyodbc \
  strace \
  tree \
  unzip \
  wget \
  zip \
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

USER 1001

# Runtime environment variables.

ENV SENZING_ETC_PATH=/etc/opt/senzing \
  SENZING_SSHD_SHOW_PERFORMANCE_WARNING=true

# Runtime execution.

WORKDIR /app
CMD ["/app/sleep-infinity.sh"]
