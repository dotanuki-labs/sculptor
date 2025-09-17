# sculptor

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
- Run the `sculpt.sh` script

```bash
$> git clone git@github.com:dotanuki-labs/sculptor.git
$> mv sculpt my-tool
$> cd my-tool
$> ./sculpt.sh my-tool
```

## License

Copyright (c) 2025 - Dotanuki Labs - [The MIT license](https://choosealicense.com/licenses/mit)
