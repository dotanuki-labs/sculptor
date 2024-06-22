#! /usr/bin/env bash
# Copyright 2024 Dotanuki Labs
# SPDX-License-Identifier: MIT

set -e

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$dir"

readonly callinectes="ghcr.io/dotanuki-labs/callinectes:ae3795ac90f810c36a8475deb62ac855b501b296"
readonly task="$1"

usage() {
    echo
    echo "Available tasks:"
    echo
    echo "setup      # Installs required Cargo extensions"
    echo "lint       # Check code formatting and smells"
    echo "tests      # Run tests for Rust modules and integration tests"
    echo "assemble   # Builds binaries according to the environment (local or CI)"
    echo "security   # Run security checks and generates supply-chain artifacts"
    echo
}

setup_rust_toolchain() {
    echo "🔥 Installing and activating Rust toolchain"
    rustup show active-toolchain
    echo
}

check_code_smells() {
    echo
    echo "🔥 Checking code smells for Rust code"
    echo
    docker run --rm -v "${PWD}:/usr/src" "$callinectes" code
}

run_cargo_tests() {
    echo
    echo "🔥 Running unit + integration tests for Rust code"
    echo
    cargo test
    echo
}

build_binaries() {
    echo
    echo "🔥 Building project according to environment"
    echo
    ./scripts/flex-build.sh
    echo
}

check_supply_chain() {
    echo
    echo "🔥 Checking dependencies and supply-chain"
    echo
    docker run --rm -v "${PWD}:/usr/src" "$callinectes" deps
}

if [[ -z "$task" ]]; then
    usage
    exit 0
fi

case "$task" in
"setup")
    setup_rust_toolchain
    ;;
"lint")
    check_code_smells
    ;;
"tests")
    run_cargo_tests
    ;;
"assemble")
    build_binaries
    ;;
"security")
    check_supply_chain
    ;;
*)
    echo "Error: unsupported task → $task"
    usage
    exit 1
    ;;
esac
