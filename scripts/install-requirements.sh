#! /usr/bin/env bash
# Copyright 2024 Dotanuki Labs
# SPDX-License-Identifier: MIT

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_tools_with_asdf() {
    echo
    echo "‣ Setting up required tools with asdf"

    if ! which asdf >/dev/null; then
        echo -e "Error : 'asdf' required but not available"
        echo
        exit 1
    fi

    echo
    asdf plugin add zig || true
    asdf plugin add just || true
    asdf install
    echo
}

install_cargo_binstall() {
    echo
    echo "‣ Installing cargo-binstall"

    cd "$(mktemp -d)"
    local base_url="https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-"

    local os
    os="$(uname -s)"

    local url

    if [ "$os" == "Darwin" ]; then
        url="${base_url}universal-apple-darwin.zip"
        curl -LO --proto '=https' --tlsv1.2 -sSf "$url"
        unzip cargo-binstall-universal-apple-darwin.zip >/dev/null

    elif [ "$os" == "Linux" ]; then
        local machine
        local target

        machine="$(uname -m)"
        target="${machine}-unknown-linux-musl"
        url="${base_url}${target}.tgz"
        curl -L --proto '=https' --tlsv1.2 -sSf "$url" | tar -xvzf - >/dev/null
    else
        echo "Unsupported OS ${os}"
        exit 1
    fi

    ./cargo-binstall -y --force cargo-binstall --quiet

    CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"

    if ! [[ ":$PATH:" == *":$CARGO_HOME/bin:"* ]]; then
        echo
        echo "CARGO_HOME not found in your \$PATH"
        echo
    fi
}

install_cargo_plugins() {
    echo
    echo "‣ Installing Cargo plugins"

    cd "${script_dir%/*}"

    grep "cargo-" "cargo-plugins.toml" |
        tr -d '\"' |
        sed "s/[[:space:]]=[[:space:]]/@/g" |
        xargs -L1 -I {} cargo-binstall {} --no-confirm --force --quiet
}

install_rust_toolchain() {
    echo
    echo "‣ Installing Rust toolchain (pinned)"
    rustup show active-toolchain >/dev/null
}

install_tools_with_asdf
install_cargo_binstall
install_cargo_plugins
install_rust_toolchain

echo
echo "✅ Done!"
echo
