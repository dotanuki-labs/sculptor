#! /usr/bin/env bash

set -e

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${dir%/*}"

version=$(cargo get package.version)
echo "version=$version" >>"$GITHUB_OUTPUT"
