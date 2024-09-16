// Copyright 2024 Dotanuki Labs
// SPDX-License-Identifier: MIT

use crate::utils::{evaluate_build_environment, BuildEnvironment::Local, BuildEnvironment::CI};
use xshell::{cmd, Shell};

pub fn execute_tests(shell: &Shell) -> anyhow::Result<()> {
    println!();
    println!("🔥 Running unit and integration tests");
    println!();

    match evaluate_build_environment() {
        CI => cmd!(shell, "cargo test").run()?,
        Local => cmd!(shell, "cargo nextest run").run()?,
    };

    Ok(())
}
