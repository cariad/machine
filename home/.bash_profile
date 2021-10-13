#!/usr/bin/env bash

set -euo pipefail

export CFLAGS="-O2"

export GENERATE_COVERAGE=true  # freyda.io

export PIPENV_VENV_IN_PROJECT=1

export PYENV_ROOT="${HOME:?}/.pyenv"
export PYENV_VERSION=3.10.0

export PATH="${PYENV_ROOT:?}/bin:${PATH:?}"

eval "$(pyenv init -)"
eval "$(pyenv init --path)"
