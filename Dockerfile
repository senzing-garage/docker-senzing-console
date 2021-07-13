ARG BASE_IMAGE=senzing/senzing-base:1.6.0
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2021-07-13

LABEL Name="senzing/senzing-console" \
      Maintainer="support@senzing.com" \
      Version="1.0.2"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
    elfutils \
    fio \
    htop \
    iotop \
    ipython3 \
    itop \
    less \
    libpq-dev \
    net-tools \
    odbc-postgresql \
    procps \
    pstack \
    python-dev \
    python-pyodbc \
    python-setuptools \
    strace \
    telnet \
    tree \
    unixodbc \
    unixodbc-dev \
    vim \
    zip \
 && rm -rf /var/lib/apt/lists/*

# Install packages via pip.

COPY requirements.txt ./
RUN pip3 install --upgrade pip \
 && pip3 install -r requirements.txt


# Copy files from repository.

COPY ./rootfs /

# Runtime execution.

WORKDIR /app
CMD ["/app/sleep-infinity.sh"]
