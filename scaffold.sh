#! /usr/bin/env bash
# Copyright 2024 Dotanuki Labs
# SPDX-License-Identifier: MIT

readonly color_cyan="\033[1;36m"
readonly color_normal="\033[0m"

readonly target_name="$1"
readonly placeholder_name="rust-cli-tool-scaffold"

cyan() {
    echo "${color_cyan}$1${color_normal}"
}

say() {
    echo -e "$1"
}

line() {
    echo
}

require_name() {
    if [ -z "$target_name" ]; then
        line
        say "🚫 Error : no arguments provided"
        say "Usage : $(cyan "./scaffold <your_project_name>")"
        line
        exit 1
    fi
}

patch_file() {
    local target_file="$1"
    say "• Patching $(cyan "$target_file")"
    sed -i '' "s/$placeholder_name/$target_name/g" "$target_file"
}

remove() {
    local target="$1"
    say "• Removing $(cyan "$target")"
    rm -rf "$target"
}

require_name

echo
say "🔥 Scaffolding with $(cyan "$target_name")"
echo

patch_file README.md
patch_file .gitignore
patch_file Cargo.toml
patch_file Cargo.lock
patch_file scripts/cross-build.sh
patch_file .github/workflows/ci.yml
patch_file .github/workflows/cd.yml
patch_file src/main.rs
remove .idea
remove .git
remove target
remove scaffold.sh

echo
say "✅ Done"
echo
