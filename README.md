# docker-nomad

Nomad in Docker

## Usage

Nomad start by default in dev mode and bind listener to 0.0.0.0

Put your configuration inside `/nomad/config` or inside the `NOMAD_LOCAL_CONFIG` env variable.

To disable the dev mode, start the container with the `agent` parameter (`-data-dir` and `-config` are automaticaly set)

### Server

```sh
docker run -d \
    --name nomad-server \
    --net host \
    -e NOMAD_LOCAL_CONFIG='
server {
  enabled = true
  bootstrap_expect = 3
}

datacenter = "dc1"

bind_addr = "192.168.1.20"
' \
    clementd/nomad agent
```

### Client

use the `privileged` flag to run correctly  
don't forget to mount the Docker sock to enable the Docker driver

```sh
docker run -d \
    --name nomad-client \
    --net host \
    --privileged \
    -e NOMAD_LOCAL_CONFIG='
client {
  enabled = true
}

datacenter = "dc1"

bind_addr = "0.0.0.0"
' \
    -v "/var/run/docker.sock:/var/run/docker.sock:ro" \
    clementd/nomad agent
```

## Configure the data directory

If you want to bind an host dir for the data directory, you need to configure **the same path** inside the container.

```sh
NOMAD_DATA_DIR=/host/path/to/nomad/data

docker run \
  ...\
  -v "$NOMAD_DATA_DIR:$NOMAD_DATA_DIR:rw" \
  -e "NOMAD_DATA_DIR=$NOMAD_DATA_DIR" \
  clementd/nomad
```