# docker-senzing-console

## Synopsis

The `senzing/senzing-console` docker image is used for creating
a running Docker container configured to run Senzing programs.

## Overview

The default behavior when running `docker run` is for the container to "sleep".
This allows a user to "`docker exec`" into the container and run Senzing programs.
Python commands located in `/opt/senzing/g2/python` can be run in the docker container.

### Contents

1. [Preamble](#preamble)
    1. [Legend](#legend)
1. [Related artifacts](#related-artifacts)
1. [Expectations](#expectations)
1. [Demonstrate using Docker](#demonstrate-using-docker)
    1. [Prerequisites for Docker](#prerequisites-for-docker)
    1. [Docker volumes](#docker-volumes)
    1. [Docker network](#docker-network)
    1. [Docker user](#docker-user)
    1. [MySQL support](#mysql-support)
    1. [Run Docker container](#run-docker-container)
1. [Develop](#develop)
    1. [Prerequisites for development](#prerequisites-for-development)
    1. [Clone repository](#clone-repository)
    1. [Build Docker image](#build-docker-image)
1. [Examples](#examples)
    1. [Examples of Docker](#examples-of-docker)
1. [Advanced](#advanced)
    1. [Configuration](#configuration)
1. [Errors](#errors)
1. [References](#references)

## Preamble

At [Senzing](http://senzing.com),
we strive to create GitHub documentation in a
"[don't make me think](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/dont-make-me-think.md)" style.
For the most part, instructions are copy and paste.
Whenever thinking is needed, it's marked with a "thinking" icon :thinking:.
Whenever customization is needed, it's marked with a "pencil" icon :pencil2:.
If the instructions are not clear, please let us know by opening a new
[Documentation issue](https://github.com/Senzing/docker-senzing-console/issues/new?template=documentation_request.md)
describing where we can improve.   Now on with the show...

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps there are some choices to be made.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Related artifacts

1. [DockerHub](https://hub.docker.com/r/senzing/senzing-console)

## Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/docker.md)

## Demonstrate using Docker

### Prerequisites for Docker

:thinking: The following tasks need to be complete before proceeding.
These are "one-time tasks" which may already have been completed.

1. The following software programs need to be installed:
    1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)
1. [Install Senzing using Docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-senzing-using-docker.md)
    1. If using Docker with a previous "system install" of Senzing,
       see [how to use Docker with system install](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/use-docker-with-system-install.md).
1. [Configure Senzing database using Docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/configure-senzing-database-using-docker.md)
1. [Configure Senzing using Docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/configure-senzing-using-docker.md)

### Docker volumes

Senzing Docker images follow the [Linux File Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf).
Inside the Docker container, Senzing artifacts will be located in `/opt/senzing`, `/etc/opt/senzing`, and `/var/opt/senzing`.

1. :pencil2: Specify the directory containing the Senzing installation on the host system
   (i.e. *outside* the Docker container).
   Use the same `SENZING_VOLUME` value used when performing
   [Prerequisites for Docker](#prerequisites-for-docker).
   Example:

    ```console
    export SENZING_VOLUME=/opt/my-senzing
    ```

    1. :warning:
       **macOS** - [File sharing](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/share-directories-with-docker.md#macos)
       must be enabled for `SENZING_VOLUME`.
    1. :warning:
       **Windows** - [File sharing](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/share-directories-with-docker.md#windows)
       must be enabled for `SENZING_VOLUME`.

1. Identify the `data_version`, `etc`, `g2`, and `var` directories.
   Example:

    ```console
    export SENZING_DATA_VERSION_DIR=${SENZING_VOLUME}/data/2.0.0
    export SENZING_ETC_DIR=${SENZING_VOLUME}/etc
    export SENZING_G2_DIR=${SENZING_VOLUME}/g2
    export SENZING_VAR_DIR=${SENZING_VOLUME}/var
    ```

    *Note:* If using a "system install",
    see [how to use Docker with system install](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/use-docker-with-system-install.md).
    for how to set environment variables.

1. Here's a simple test to see if `SENZING_G2_DIR` and `SENZING_DATA_VERSION_DIR` are correct.
   The following commands should return file contents.
   Example:

    ```console
    cat ${SENZING_G2_DIR}/g2BuildVersion.json
    cat ${SENZING_DATA_VERSION_DIR}/libpostal/data_version
    ```

### Docker network

:thinking: **Optional:**  Use if Docker container is part of a Docker network.

1. List Docker networks.
   Example:

    ```console
    sudo docker network ls
    ```

1. :pencil2: Specify Docker network.
   Choose value from NAME column of `docker network ls`.
   Example:

    ```console
    export SENZING_NETWORK=*nameofthe_network*
    ```

1. Construct parameter for `docker run`.
   Example:

    ```console
    export SENZING_NETWORK_PARAMETER="--net ${SENZING_NETWORK}"
    ```

### Docker user

:thinking: **Optional:**  The Docker container runs as "USER 1001".
Use if a different userid (UID) is required.

1. :pencil2: Identify user.
    1. **Example #1:** Use specific UID. User "0" is `root`.

        ```console
        export SENZING_RUNAS_USER="0"
        ```

    1. **Example #2:** Use current user.

        ```console
        export SENZING_RUNAS_USER=$(id -u)
        ```

1. Construct parameter for `docker run`.
   Example:

    ```console
    export SENZING_RUNAS_USER_PARAMETER="--user ${SENZING_RUNAS_USER}"
    ```

### MySQL support

:thinking: **Optional:**  If a MySQL database will be accessed, the MySQL client needs to be installed at runtime.

1. Construct parameter for `docker run`.
   Example:

    ```console
    export SENZING_INSTALL_MYSQL_CLIENT_PARAMETER="--env INSTALL_MYSQL_CLIENT=y"
    ```

### Run Docker container

Although the `Docker run` command looks complex,
it accounts for all of the optional variations described above.
Unset environment variables have no effect on the
`docker run` command and may be removed or remain.

1. Run Docker container.
   Example:

    ```console
    sudo docker run \
      --cap-add=ALL \
      --interactive \
      --rm \
      --tty \
      --volume ${SENZING_DATA_VERSION_DIR}:/opt/senzing/data \
      --volume ${SENZING_ETC_DIR}:/etc/opt/senzing \
      --volume ${SENZING_G2_DIR}:/opt/senzing/g2 \
      --volume ${SENZING_VAR_DIR}:/var/opt/senzing \
      ${SENZING_NETWORK_PARAMETER} \
      ${SENZING_RUNAS_USER_PARAMETER} \
      ${SENZING_INSTALL_MYSQL_CLIENT_PARAMETER} \
      senzing/senzing-console
    ```

1. For more examples of use, see [Examples of Docker](#examples-of-docker).

## Develop

The following instructions are used when modifying and building the Docker image.

### Prerequisites for development

:thinking: The following tasks need to be complete before proceeding.
These are "one-time tasks" which may already have been completed.

1. The following software programs need to be installed:
    1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
    1. [make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
    1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)

### Clone repository

For more information on environment variables,
see [Environment Variables](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md).

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-senzing-console
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Using the environment variables values just set, follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

### Build Docker image

1. **Option #1:** Using `docker` command and GitHub.

    ```console
    sudo docker build \
      --tag senzing/senzing-console \
      https://github.com/senzing/docker-senzing-console.git
    ```

1. **Option #2:** Using `docker` command and local repository.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo docker build --tag senzing/senzing-console .
    ```

1. **Option #3:** Using `make` command.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo make docker-build
    ```

    Note: `sudo make docker-build-development-cache` can be used to create cached Docker layers.

## Examples

### Examples of Docker

The following examples require initialization described in
[Demonstrate using Docker](#demonstrate-using-docker).

## Advanced

### Configuration

Configuration values specified by environment variable or command line parameter.

- **[SENZING_DATA_VERSION_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_data_version_dir)**
- **[SENZING_ETC_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_etc_dir)**
- **[SENZING_G2_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_g2_dir)**
- **[SENZING_NETWORK](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_network)**
- **[SENZING_RUNAS_USER](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_runas_user)**
- **[SENZING_VAR_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_var_dir)**

## Errors

1. See [docs/errors.md](docs/errors.md).

## References
