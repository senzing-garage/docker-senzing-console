# docker-senzing-console

## Synopsis

The `senzing/senzing-console` docker image is used for creating
a running Docker container configured to run Senzing programs.

## Overview

The default behavior when running `docker run` is for the container to "sleep".
This allows a user to "`docker exec`" into the container and run Senzing programs.
Python commands located in `/opt/senzing/g2/python` can be run in the docker container.

### Contents

1. [Legend](#legend)
1. [Expectations](#expectations)
1. [Demonstrate using Docker](#demonstrate-using-docker)
    1. [Prerequisites for Docker](#prerequisites-for-docker)
    1. [Docker volumes](#docker-volumes)
    1. [MySQL support](#mysql-support)
    1. [Run Docker container](#run-docker-container)
1. [License](#license)
1. [References](#references)

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps there are some choices to be made.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/docker.md)

## Demonstrate using Docker

### Prerequisites for Docker

:thinking: The following tasks need to be complete before proceeding.
These are "one-time tasks" which may already have been completed.

1. The following software programs need to be installed:
    1. [docker](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/docker.md)
1. [Install Senzing using Docker](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-senzing-using-docker.md)
    1. If using Docker with a previous "system install" of Senzing,
       see [how to use Docker with system install](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/use-docker-with-system-install.md).
1. [Configure Senzing database using Docker](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/configure-senzing-database-using-docker.md)
1. [Configure Senzing using Docker](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/configure-senzing-using-docker.md)

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

    1. BASH example:

        ```console
        sudo docker run \
          --cap-add=ALL \
          --interactive \
          --rm \
          --tty \
          ${SENZING_INSTALL_MYSQL_CLIENT_PARAMETER} \
          senzing/senzing-console
        ```

    1. ZSH example:
    :warning: if using the the z-shell (`zsh`) then you'll need to modify how you run the container.

        ```console
        sudo docker run \
          --cap-add=ALL \
          --interactive \
          --rm \
          --tty \
          ${=SENZING_INSTALL_MYSQL_CLIENT_PARAMETER} \
          senzing/senzing-console
        ```

## License

View
[license information](https://senzing.com/end-user-license-agreement/)
for the software container in this Docker image.
Note that this license does not permit further distribution.

This Docker image may also contain software from the
[Senzing GitHub community](https://github.com/Senzing/)
under the
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

Further, as with all Docker images,
this likely also contains other software which may be under other licenses
(such as Bash, etc. from the base distribution,
along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage,
it is the image user's responsibility to ensure that any use of this image complies
with any relevant licenses for all software contained within.

## References

- [Development](docs/development.md)
- [Errors](docs/errors.md)
- [Examples](docs/examples.md)
- Related artifacts
  - [DockerHub](https://hub.docker.com/r/senzing/senzing-console)
