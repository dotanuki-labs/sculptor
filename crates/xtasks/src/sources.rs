// Copyright 2024 Dotanuki Labs
// SPDX-License-Identifier: MIT

use crate::utils::{
    docker_execution_arguments, evaluate_build_environment, BuildEnvironment::Local, BuildEnvironment::CI,
};
use xshell::{cmd, Shell};

pub fn check_source_files(shell: &Shell) -> anyhow::Result<()> {
    check_code_formatting(shell)?;
    check_code_smells(shell)?;
    Ok(())
}

fn check_code_formatting(shell: &Shell) -> anyhow::Result<()> {
    println!();
    println!("🔥 Checking formatting of Rust code (rustfmt)");
    println!();

    match evaluate_build_environment() {
        CI => {
            let (volume, image) = docker_execution_arguments();
            cmd!(shell, "docker run --rm -v {volume} {image} fmt").run()?;
        },
        Local => {
            cmd!(shell, "cargo fmt --check").run()?;
        },
    };

    Ok(())
}

fn check_code_smells(shell: &Shell) -> anyhow::Result<()> {
    println!();
    println!("🔥 Checking smells in Rust code (clippy)");
    println!();

    match evaluate_build_environment() {
        CI => {
            let (volume, image) = docker_execution_arguments();
            cmd!(shell, "docker run --rm -v {volume} {image} clippy").run()?;
        },
        Local => {
            cmd!(shell, "cargo clippy --all-targets --all-features -- -D warnings").run()?;
        },
    };

    Ok(())
}

#[allow(dead_code)]
fn check_msrv(shell: &Shell) -> anyhow::Result<()> {
    println!();
    println!("🔥 Checking minimal supported Rust version (cargo-mrsv)");
    println!();

    match evaluate_build_environment() {
        CI => {
            let (volume, image) = docker_execution_arguments();
            cmd!(shell, "docker run --rm -v {volume} {image} msrv").run()?;
        },
        Local => {
            cmd!(shell, "cargo msrv verify").run()?;
        },
    };

    Ok(())
}
