// Copyright 2024 Dotanuki Labs
// SPDX-License-Identifier: MIT

use crate::utils::BuildEnvironment::{CI, Local};
use std::env;

static CALLINECTES_DOCKER_IMAGE: &str = "ghcr.io/dotanuki-labs/callinectes:latest";
static CALLINECTES_DOCKER_DIGEST: &str = "cbaaa1b11bd2eec9d52ba12c70ba70b764467ff7eedf6ee1765a3297c0010e52";

pub enum BuildEnvironment {
    CI,
    Local,
}

pub fn evaluate_build_environment() -> BuildEnvironment {
    match env::var("CI") {
        Ok(_) => CI,
        Err(_) => Local,
    }
}

pub fn docker_execution_arguments() -> (String, String) {
    let docker_package = format!("{}@sha256:{}", CALLINECTES_DOCKER_IMAGE, CALLINECTES_DOCKER_DIGEST);
    let current_dir = env::current_dir().expect("Failed to get current directory");
    let pwd = current_dir
        .to_str()
        .expect("Failed to convert current directory to string");
    (format!("{}:/usr/src", pwd), docker_package)
}
