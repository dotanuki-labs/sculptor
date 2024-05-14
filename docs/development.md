# Development Guidelines

## Requirements

> [!NOTE]
> We officially support development over `macOS` and `Linux` boxes for now.

This project is written in Rust, and it assumes a valid Rust installation on your local machine.
We definitely recommend [rustup](https://rustup.rs/) to get this sorted.

In addition to that, we also require too additional software components on your system:

- [just](https://just.systems), used as a task runner
- [ziglang](https://ziglang.org/), used as a linker for cross-compilation

You can install those with your package manager of choice, for instance running:

```bash
brew install just zig
```

## Project setup

As mentioned before, this project uses [just](https://just.systems) as a task runner and
defines a few recipes to make things straightforward. You can check them by running:

```bash
just

Available recipes:
    setup        # Performs setup for this project
    lint         # Check code formatting and smells
    tests        # Run Tests
    build-simple # Build project against some supported targets
    build-all    # Build project against all supported targets
    supply-chain # Generates supply-chain related artifacts
```

We definitely recommend getting started by setting up the latest version of Rust along with
all required Cargo subcommands by running:

```bash
just setup
```

## Code Style

This project adotps a few customizations on top of the standard
[rustfmt](https://rust-lang.github.io/rustfmt)
conventions. In addition, it also provides a
[.editorconfig](https://editorconfig.org/)
file to make it straightforward to get code formatting right on you editor or IDE.

In addition to that, this project uses
[Clippy](https://rust-lang.github.io/rust-clippy)
to catch the most straightforward code smells, not enforcing any additional warnings on
specific patterns, but denying any warnings emitted by `clippy`.

## Commit Conventions

This project does not adopt any specific commit conventions for now.

## Code Conventions

This project encourages
[easy-mode Rust](https://llogiq.github.io/2024/03/28/easy.html)
by default, focusing on simplicity and code readability.

Since this is a very small CLI tool focused on one-off executions, we explicitly avoid advanced
Rust features like `lifetimes` and `macros` for now.

In addition, this project leverages
[anyhow](https://docs.rs/anyhow/latest/anyhow/)
for better error signaling, errors transformations and error propagation.

## Continuous Integration

According to our policies, all code contributions to this project must go through a Pull Request,
and all required status checks must pass.

This project adopts
[GiHub Actions](https://github.com/dotanuki-labs/rust-cli-tool-scaffold/actions)
as it CI system. Most of the verifications we'll run on CI are provided by the `just` recipes,
as previously mentioned.

In addition to that, we also run a specific `Job` to enforce code quality standards for docs,
Bash scripts and others. In particular, this project enforces the proper open-source license
tracking on all Rust and Bash files.
