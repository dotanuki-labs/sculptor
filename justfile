# Update Rust toolchain
toolchain:
    @echo "→ Checking active Rust toolchain"
    rustup show active-toolchain
    @echo ""

    @echo "→ Updating to the latest toolchain (if needed)"
    rustup update
    @echo ""

# Check code formatting and smells
lint:
    @echo "→ Checking code formatting (fmt)"
    cargo fmt --check
    @echo ""

    @echo "→ Checking code smells (clippy)"
    cargo clippy --all-targets --all-features
    @echo ""

# Build project
build:
    @echo "→ Build project for debug"
    cargo build
    @echo ""

# Run Tests
test: build
    @echo "→ Run project tests"
    cargo test
    @echo ""

# Emulates CI checks
ci: toolchain lint test
    @echo "→ Emulated a CI build with success"
    @echo ""
