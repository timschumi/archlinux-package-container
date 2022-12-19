#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname "${0}")"
CONTAINER_ID=$(docker run -t -d -v "$(pwd):/build" docker.io/archlinux/archlinux)

docker exec "${CONTAINER_ID}" pacman -Syu --noconfirm
docker exec "${CONTAINER_ID}" pacman -S base-devel --noconfirm --needed

docker exec "${CONTAINER_ID}" useradd -m -u $UID build
docker exec "${CONTAINER_ID}" usermod -aG root build
docker exec "${CONTAINER_ID}" chmod -R g+w /build

docker exec "${CONTAINER_ID}" pacman -S sudo --noconfirm --needed
docker exec "${CONTAINER_ID}" usermod -aG wheel build
docker exec "${CONTAINER_ID}" bash -c "echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers"

docker cp "${SCRIPT_DIR}/build.sh" "${CONTAINER_ID}:/usr/bin/build.sh"

docker exec -it -u build -w /build "${CONTAINER_ID}" /bin/bash

docker rm -f -t 1 "${CONTAINER_ID}"
