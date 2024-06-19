# rust-cli-tool-scaffold

> An opinionated way to bootstrap CLI tools written in Rust 🦀

## Features

- Easy setup for local and CI development
- Simple module structure and application entrypoint driven by [clap](https://github.com/clap-rs/clap)
- Pull request automation powered by [Mergify](https://mergify.com/)
- CI and CD pipelines driven by Github Actions
- A few other niceties

## Using

- Get this project
- Rename it
- Run the `scaffold.sh` script

```bash
$> git clone git@github.com:dotanuki-labs/rust-cli-tool-scaffold.git
$> mv rust-cli-tool-scaffold my-tool
$> cd my-tool
$> ./scaffold.sh my-tool
```

## License

Copyright (c) 2024 - Dotanuki Labs - [The MIT license](https://choosealicense.com/licenses/mit)
