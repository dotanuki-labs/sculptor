cargo_binstall := "https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh"

# Update Rust toolchain
toolchain:
    @echo "→ Install and active Rust toolchain"
    rustup show active-toolchain
    @echo

# Install required Cargo plugins
cargo-plugins:
    @echo "→ Installing Cargo Binstall"
    ./scripts/cargo-binstaller.sh
    @echo

    @echo "→ Installing Cargo plugins"
    yes | cargo binstall cargo-deny --secure --force
    yes | cargo binstall cargo-cyclonedx --secure --force
    yes | cargo binstall cargo-nextest --secure --force
    yes | cargo binstall cross --secure --force
    @echo

# Performs setup for this project
setup: toolchain cargo-plugins
    @echo "✅ Setup concluded"
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

# Build against several target platform
cross-build: setup
    @echo "→ Compiles project and builds binaries targeting different platforms"
    # cross build --target x86_64-unknown-linux-musl --release
    # cross build --target aarch64-unknown-linux-musl --release
    cross build --target x86_64-unknown-linux-gnu --release
    cross build --target aarch64-unknown-linux-gnu --release
    cross build --target aarch64-apple-darwin --release
    cross build --target x86_64-apple-darwin --release
    @echo

security: cargo-plugins
    @echo "→ Checking supplying chain"
    cargo deny check

    @echo "→ Generating SBOMs"
    cargo cyclonedx --format json

# Run Tests
test: build
    @echo "→ Run project tests"
    cargo nextest run
    @echo

# Emulates CI checks
ci: lint test
    @echo "✅ Emulated a CI build with success"
    @echo
