#!/bin/sh

export DOCKER_CLI_EXPERIMENTAL=enabled

manifest() {
    docker manifest create clementd/nomad:$1 clementd/nomad:amd64-$1 clementd/nomad:arm64v8-$1
    docker manifest annotate clementd/nomad:$1 clementd/nomad:arm64v8-$1 --os linux --arch arm64 --variant v8
    docker manifest push clementd/nomad:$1
}

build() {
    for arch in amd64 arm64v8; do
        docker build -f Dockerfile.${arch} -t clementd/nomad:${arch}-$1 .
        docker push clementd/nomad:${arch}-$1
    done

    manifest $1
}

tag() {
    for arch in amd64 arm64v8; do
        docker tag clementd/nomad:${arch}-$1 clementd/nomad:${arch}-$2
        docker push clementd/nomad:${arch}-$2
    done

    manifest $2
}

TAG=0.11.1

build $TAG
tag $TAG ${TAG%.*}
tag $TAG latest