#! /usr/bin/env bash

set -euo pipefail

readonly output_dir="target/ci"

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${dir%/*}"

rm -rf "$output_dir" && mkdir -p ""$output_dir""

cross_compile() {
    local target="$1"

    rustup target add "$target"
    cargo zigbuild --release --target "$target"

    cp target/"$target"/release/rust-cli-tool-scaffold "$output_dir"/rust-cli-tool-"$target"
}

for platform in apple-darwin  unknown-linux-gnu; do
    for arch in x86_64 aarch64; do
        cross_compile "$arch-$platform"
    done
done
