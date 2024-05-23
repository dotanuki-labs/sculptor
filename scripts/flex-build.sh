#! /usr/bin/env bash
# Copyright 2024 Dotanuki Labs
# SPDX-License-Identifier: MIT

set -euo pipefail

# https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
readonly platform="${RUNNER_OS:-local}"
readonly output_dir="target/ci"

build() {
    local target="$1"

    rustup target add "$target"
    cargo zigbuild --release --target "$target"

    local binary="target/$target/release/rust-cli-tool-scaffold"
    cp "$binary" "$output_dir"/rust-cli-tool-scaffold-"$target"
    chmod +x "$output_dir"/rust-cli-tool-scaffold-"$target"
    sha256sum "$binary" >>"$output_dir"/rust-cli-tool-scaffold-"$target"-sha256
}

local_build() {
    cargo build --release
}

ci_build_mac() {
    for arch in x86_64 aarch64; do
        build "$arch-apple-darwin"
    done
}

ci_build_linux() {
    for arch in x86_64 aarch64; do
        build "$arch-unknown-linux-gnu"
    done
}

echo

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${dir%/*}"
rm -rf "$output_dir" && mkdir -p "$output_dir"

case "$platform" in
"local")
    ci_build_mac
    ;;
"macOS")
    ci_build_mac
    ;;
"Linux")
    ci_build_linux
    ;;
*)
    echo "Error: unsupported platform → $platform"
    echo
    exit 1
    ;;
esac

echo
