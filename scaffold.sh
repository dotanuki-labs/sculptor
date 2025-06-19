#! /usr/bin/env bash
# Copyright 2025 Dotanuki Labs
# SPDX-License-Identifier: MIT

readonly color_cyan="\033[1;36m"
readonly color_normal="\033[0m"

readonly target_name="$1"
readonly placeholder_name="rust-cli-tool-scaffold"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

enable_workflows() {
    readonly ci="$dir/.github/workflows/ci.yml"
    readonly cd="$dir/.github/workflows/cd.yml"

    grep -v "if: false" "$ci" >enabledci
    mv enabledci "$ci"

    grep -v "if: false" "$cd" >enabledcd
    mv enabledcd "$cd"
}

define_project_crate() {
    mv "$dir/crates/$placeholder_name" "$dir/crates/$target_name"
}

setup_git_hooks() {
    git init >/dev/null 2>&1
    mv githooks/precommit .git/hooks/pre-commit
    remove githooks
}

require_name

echo
say "🔥 Scaffolding with $(cyan "$target_name")"
echo

define_project_crate
replace_readme
patch_file "$dir/.gitignore"
patch_file "$dir/.github/workflows/ci.yml"
patch_file "$dir/.github/workflows/cd.yml"
patch_file "$dir/.github/ISSUE_TEMPLATE/bug-report.yml"
patch_file "$dir/.github/ISSUE_TEMPLATE/config.yml"
patch_file "$dir/.github/ISSUE_TEMPLATE/feature-request.yml"
patch_file "$dir/Cargo.toml"
patch_file "$dir/Cargo.lock"
patch_file "$dir/Dockerfile"
patch_file "$dir/crates/$target_name/Cargo.toml"
patch_file "$dir/crates/$target_name/src/main.rs"
patch_file "$dir/crates/$target_name/tests/integration.rs"
patch_file "$dir/crates/xtasks/src/artifacts.rs"
patch_file "$dir/crates/xtasks/Cargo.toml"
patch_file "$dir/docs/changelog.md"
patch_file "$dir/docs/contributing.md"
patch_file "$dir/docs/development.md"
patch_file "$dir/docs/releasing.md"
patch_file "$dir/docs/readme.md"
patch_file "$dir/docs/website.json"

enable_workflows

remove "$dir/.idea"
remove "$dir/.git"
remove "$dir/target"
remove "$dir/.github/workflows/scaffolding.yml"
remove "$dir/crates/$target_name/rust-cli-tool-scaffold.cdx.json"
setup_git_hooks
remove "$dir/scaffold.sh"

echo
say "✅ Done"
echo
