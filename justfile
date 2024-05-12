# General tasks driven by Just
# https://just.systems

# Performs setup for this project
setup:
    @echo "→ Install and activate Rust toolchain"
    rustup show active-toolchain

    @echo
    @echo "→ Installing Cargo Binstall"
    ./scripts/cargo-binstaller.sh

    @echo
    @echo "→ Installing Cargo plugins"
    cargo binstall cargo-nextest@0.9.70 -y --force
    cargo binstall cargo-cyclonedx@0.5.0 -y --force
    cargo binstall cargo-msrv@0.15.1 -y --force
    cargo binstall cargo-deny@0.14.23 -y --force
    cargo binstall cargo-zigbuild@0.18.4 -y --force
    cargo binstall cargo-get@1.1.1 -y --force

    @echo
    @echo "✅ Setup concluded"
    @echo

# Check code formatting and smells
lint:
    @echo "→ Checking code formatting (rustfmt)"
    cargo fmt --check
    @echo

    @echo "→ Checking code smells (clippy)"
    cargo clippy --all-targets --all-features -- -D warnings -W clippy::unwrap_used
    @echo

# Run Tests
tests:
    @echo "→ Run project tests"
    cargo nextest run
    @echo

# Build project against some supported targets
build-simple:
    @echo "→ Build project against some supported targets"
    ./scripts/cross-build.sh simple
    @echo

# Build project against all supported targets
build-all:
    @echo "→ Build project against all supported targets"
    ./scripts/cross-build.sh full
    @echo

# Generates supply-chain related artifacts
supply-chain:
    @echo "→ Checking minimum supported Rust version (MSRV)"
    cargo msrv verify

    @echo
    @echo "→ Enforcing rules over Cargo dependencies"
    cargo deny check
    @echo

    @echo "→ Generating SBOMs"
    cargo cyclonedx --format json
    @echo
