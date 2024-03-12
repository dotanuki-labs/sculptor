# Update Rust toolchain
toolchain:
    @echo "→ Install and active Rust toolchain"
    rustup show active-toolchain
    @echo

# Install required Cargo plugins
cargo-plugins:
    @echo "→ Installing Cargo plugins"
    cargo install --locked cargo-deny
    cargo install --locked cargo-cyclonedx
    @echo

# Check code formatting and smells
lint:
    @echo "→ Checking code formatting (fmt)"
    cargo fmt --check
    @echo

    @echo "→ Checking code smells (clippy)"
    cargo clippy --all-targets --all-features
    @echo

# Build project
build:
    @echo "→ Compile project and build binary"
    cargo build
    @echo

security: cargo-plugins
    @echo "→ Checking supplying chain"
    cargo deny check

    @echo "→ Generating SBOMs"
    cargo cyclonedx

# Run Tests
test: build
    @echo "→ Run project tests"
    cargo test
    @echo

# Emulates CI checks
ci: toolchain lint test
    @echo "→ Emulated a CI build with success"
    @echo
