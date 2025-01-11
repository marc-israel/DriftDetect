# DriftDetect

[![License](https://img.shields.io/github/license/facebookincubator/TTPForge?label=License&style=flat&color=blue&logo=github)](https://github.com/facebookincubator/TTPForge/blob/main/LICENSE)
[![Tests](https://github.com/facebookincubator/TTPForge/actions/workflows/tests.yaml/badge.svg)](https://github.com/facebookincubator/TTPForge/actions/workflows/tests.yaml)
[![🚨 Semgrep Analysis](https://github.com/facebookincubator/TTPForge/actions/workflows/semgrep.yaml/badge.svg)](https://github.com/facebookincubator/TTPForge/actions/workflows/semgrep.yaml)
[![Coverage Status](https://coveralls.io/repos/github/facebookincubator/TTPForge/badge.svg)](https://coveralls.io/github/facebookincubator/TTPForge)

DriftDetect is a tool designed and built by Marc Israel (@marc-israel)
and including subsequent contributions from many good folks
in Meta’s Red, Blue, and Purple security teams.

This project promotes a Purple
Team approach to cybersecurity with the following goals:

- To help blue teams accurately measure their detection and response
  capabilities through high-fidelity simulations of real attacker activity.
- To help red teams improve the ROI/actionability of their findings by packaging
  their attacks as automated, repeatable simulations.

DriftDetect allows you to automate drift detection and response

---

## Table of Contents

- [Installation](#installation)
- [Documentation](docs/foundations/README.md)
- [Getting Started - Developer](docs/dev/README.md)
- [Go Package Documentation](https://pkg.go.dev/github.com/facebookincubator/ttpforge@main)
- [Creating a new release](docs/release.md)

---

## Installation

1. Get latest DriftDetect release:

   ```bash
   curl \
   https://raw.githubusercontent.com/marc-israel/DriftDetect/main/dl-rl.sh \
   | bash
   ```

   At this point, the latest `DriftDetect` release should be in
   `$HOME/.local/bin/DriftDetect` and subsequently, the `$USER`'s `$PATH`.

   If running in a stripped down system, you can add DriftDetect to your `$PATH`
   with the following command:

   ```bash
   export PATH=$HOME/.local/bin:$PATH
   ```

1. Initialize DriftDetect configuration

   This command will place a configuration file at the default location
   `~/.DriftDetect/config.yaml` and configure the `examples` and `forgearmory` TTP
   repositories:

   ```bash
   DriftDetect init
   ```

1. List available TTP repositories (should show `examples` and `forgearmory`)

   ```bash
   DriftDetect list repos
   ```

   The `examples` repository contains the DriftDetect examples found in this
   repository. The
   [ForgeArmory](https://github.com/facebookincubator/ForgeArmory) repository
   contains our arsenal of attacker TTPs powered by TTPForge.

1. List available TTPs that you can run:

   ```bash
   DriftDetect list ttps
   ```

1. Examine an example TTP:

   ```bash
   DriftDetect show ttp examples//args/basic.yaml
   ```

1. Run the specified example:

   ```bash
   DriftDetect run examples//args/basic.yaml \
     --arg str_to_print=hello \
     --arg run_second_step=true
   ```

## Docker Support

DriftDetect can be run using Docker in two ways:

### Production Use
```bash
# Build the production image
docker-compose build

# Run DriftDetect
docker-compose run driftdetect [command]
```

### Development Environment
```bash
# Start development environment
make dev

# Run tests in Docker
make docker-test

# Build production image
make docker-build

# Run DriftDetect in production container
make docker-run
```

See [Development Documentation](docs/dev/README.md) for more details about the Docker development environment.
