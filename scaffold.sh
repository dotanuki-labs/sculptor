#! /usr/bin/env bash
# Copyright 2025 Dotanuki Labs
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

replace_readme() {
    local target="README.md"
    local replacement="README-template.md"

    say "• Removing $(cyan "$target")"
    rm -rf "$target"

    patch_file "$replacement"

    say "• Replacing $(cyan "$target")"
    mv "$replacement" "$target"
}

enable_cd_workflow() {
    readonly cd=".github/workflows/cd.yml"
    grep -v "if: false" "$cd" >enabled
    mv enabled "$cd"
}

define_project_crate() {
    mv "crates/$placeholder_name" "crates/$target_name"
}

setup_git_hooks() {
    git init
    mv githooks/precommit .git/hooks/precommit
}

require_name

echo
say "🔥 Scaffolding with $(cyan "$target_name")"
echo

define_project_crate
replace_readme
patch_file .gitignore
patch_file .github/workflows/ci.yml
patch_file .github/workflows/cd.yml
patch_file .github/ISSUE_TEMPLATE/bug-report.yml
patch_file .github/ISSUE_TEMPLATE/config.yml
patch_file .github/ISSUE_TEMPLATE/feature-request.yml
patch_file Cargo.toml
patch_file Cargo.lock
patch_file "crates/$target_name/Cargo.toml"
patch_file "crates/$target_name/src/main.rs"
patch_file "crates/$target_name/tests/integration.rs"
patch_file "crates/xtasks/src/artifacts.rs"
patch_file "crates/xtasks/Cargo.toml"
patch_file docs/changelog.md
patch_file docs/contributing.md
patch_file docs/development.md
patch_file docs/releasing.md
enable_cd_workflow
remove .idea
remove .git
remove target
remove "crates/$target_name/rust-cli-tool-scaffold.cdx.json"
setup_git_hooks
remove scaffold.sh

echo
say "✅ Done"
echo
