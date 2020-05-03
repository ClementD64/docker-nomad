#!/bin/sh

export DOCKER_CLI_EXPERIMENTAL=enabled

buildAndPush() {
    docker build -f Dockerfile.$1 -t clementd/nomad:$2 .
    docker push clementd/nomad:$2
}

tagAndPush() {
    docker tag clementd/nomad:$1 clementd/nomad:$2
    docker push clementd/nomad:$2
}

manifest() {
    docker manifest create clementd/nomad:$1 clementd/nomad:amd64-$1 clementd/nomad:arm64v8-$1
    docker manifest annotate clementd/nomad:$1 clementd/nomad:arm64v8-$1 --os linux --arch arm64 --variant v8
    docker manifest push clementd/nomad:$1
}

build() {
    for arch in amd64 arm64v8; do
        buildAndPush ${arch} ${arch}-$1
    done

    manifest $1
}

tag() {
    for arch in amd64 arm64v8; do
        tagAndPush ${arch}-$1 ${arch}-$2
    done

    manifest $2
}

TAG=0.11.1

build $TAG
tag $TAG ${TAG%.*}
tag $TAG latest

# QEMU
buildAndPush qemu.amd64 qemu-$TAG
tagAndPush qemu-$TAG qemu-${TAG%.*}
tagAndPush qemu-$TAG qemu