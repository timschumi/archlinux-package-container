#!/usr/bin/env bash

set -e

(
    . PKGBUILD

    packages=("${depends[@]}" "${makedepends[@]}")
    for pkg in "${optdepends[@]}"; do
        packages+=("$(sed 's/:.*$//g' <<< "${pkg}")")
    done
    sudo pacman -S "${packages[@]}" --noconfirm --needed

    gpg --recv-keys "${validpgpkeys[@]}"
)

makepkg
