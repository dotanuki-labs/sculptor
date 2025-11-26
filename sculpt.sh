#! /usr/bin/env bash
# Copyright 2025 Dotanuki Labs
# SPDX-License-Identifier: MIT

readonly color_cyan="\033[1;36m"
readonly color_normal="\033[0m"

readonly target_name="$1"
readonly placeholder_name="sculptor"
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
        say "Usage : $(cyan "./sculpt <your_project_name>")"
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
    readonly cd="$dir/.github/workflows/cd-rust.yml"

    grep -v "if: false" "$cd" >enabledcd
    mv enabledcd "$cd"
}

enable_mergify() {
    mv "$dir/.mergify-template.yml" "$dir/.mergify.yml"
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
say "🔥 Sculpting with $(cyan "$target_name")"
echo

define_project_crate
replace_readme
patch_file "$dir/.gitignore"
patch_file "$dir/.github/workflows/ci-all.yml"
patch_file "$dir/.github/workflows/ci-compliance.yml"
patch_file "$dir/.github/workflows/ci-docker.yml"
patch_file "$dir/.github/workflows/ci-docs.yml"
patch_file "$dir/.github/workflows/ci-rust.yml"
patch_file "$dir/.github/workflows/cd-all.yml"
patch_file "$dir/.github/workflows/cd-docker.yml"
patch_file "$dir/.github/workflows/cd-docs.yml"
patch_file "$dir/.github/workflows/cd-rust.yml"
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
remove "$dir/.idea"
remove "$dir/.git"
remove "$dir/target"
remove "$dir/.github/workflows/dogfood.yml"
remove "$dir/.mergify"
remove "$dir/crates/$target_name/sculptor.cdx.json"
remove "$dir/sculpt.sh"

setup_git_hooks
enable_workflows
enable_mergify

echo
say "✅ Done"
echo
echo "Don't forget to:"
echo
say "Ensure proper description is set on Cargo.toml files"
say "Ensure proper categories set on cargo.toml files"
say "Perform changes at the related Github repo (e.g. setting up secrets)"
echo
