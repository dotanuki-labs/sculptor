#! /usr/bin/env bash
# Copyright 2024 Dotanuki Labs
# SPDX-License-Identifier: MIT

set -e

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${dir%/*}"

version=$(grep 'version' Cargo.toml | head -1 | sed "s/version[[:space:]]=[[:space:]]//g" | tr -d '"')
echo "version=$version" >>"$GITHUB_OUTPUT"
