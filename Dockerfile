ARG BASE_IMAGE=debian:11.2-slim@sha256:4c25ffa6ef572cf0d57da8c634769a08ae94529f7de5be5587ec8ce7b9b50f9c

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} as builder

# Set Shell to use for RUN commands in builder step.

ENV REFRESHED_AT=2022-02-17

LABEL Name="senzing/senzing-console" \
      Maintainer="support@senzing.com" \
      Version="1.0.6"

# Build arguments.

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
 && wget https://github.com/axboe/fio/archive/refs/tags/fio-3.27.zip \
 && unzip fio-3.27.zip \
 && cd fio-fio-3.27/ \
 && ./configure \
 && make \
 && make install \
 && fio --version \
 && cd \
 && rm -rf /tmp/fio

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2022-02-17

LABEL Name="senzing/senzing-console" \
      Maintainer="support@senzing.com" \
      Version="1.0.6"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      curl \
      htop \
      iotop \
      jq \
      less \
      libpq-dev \
      net-tools \
      odbcinst \
      openssh-server \
      postgresql-client \
      procps \
      python3-dev \
      python3-pip \
      sqlite3 \
      strace \
      tree \
      unixodbc-dev \
      unzip \
      elvis-tiny \
      wget \
      zip \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder "/usr/local/bin/fio" "/usr/local/bin/fio"

# Install packages via pip.

COPY requirements.txt ./
RUN pip3 install --upgrade pip \
 && pip3 install -r requirements.txt \
 && rm requirements.txt

# Configure our shell.

RUN echo "export LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:/opt/IBM/db2/clidriver/lib" >> /root/.bashrc \
 && echo "export ODBCSYSINI=/etc/opt/senzing" >> /root/.bashrc \
 && echo "export PATH=${PATH}:/opt/senzing/g2/python:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin" >> /root/.bashrc \
 && echo "export PYTHONPATH=/opt/senzing/g2/python" >> /root/.bashrc \
 && echo "export SENZING_ETC_PATH=/etc/opt/senzing" >> /root/.bashrc \
 && echo "export TERM=xterm" >> /root/.bashrc \
 && echo "export LC_ALL=C" >> /root/.bashrc \
 && echo "export LANGUAGE=C" >> /root/.bashrc

# Copy files from repository.

COPY ./rootfs /

# Runtime execution.

WORKDIR /app
CMD ["/app/sleep-infinity.sh"]
