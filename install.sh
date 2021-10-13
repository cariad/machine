#!/usr/bin/env bash
set -euo pipefail

info() {
  echo
  echo "🚀 ${1:?}"
  echo
}

info "Updating system"
sudo apt update -y

info "Upgrading system"
sudo apt upgrade -y

info "Minimising system"
sudo apt autoremove -y

info "Installing home"
pushd home > /dev/null
ln -sf "${PWD}/.bash_profile" "${HOME}/.bash_profile"
ln -sf "${PWD}/.gitconfig"    "${HOME}/.gitconfig"
popd > /dev/null

if ! command -v git &> /dev/null
then
  info "Installing Git"
  sudo apt install git -y
fi

if [ ! -d "${HOME}/.machine.secrets" ]
then
  # Intentionally use HTTP authentication since we don't have our SSH keys yet:

  echo "⚠️  Visit https://github.com/settings/tokens/new to create a GitHub"
  echo "⚠️  personal access token. The token can be revoked after"
  echo "⚠️  machine.secrets has been cloned; your cloned SSH key will be used"
  echo "⚠️  for subsequent pulls."
  git clone https://github.com/cariad/machine.secrets.git "${HOME}/.machine.secrets"
else
  info "Updating machine.secrets"
  pushd "${HOME}/.machine.secrets" > /dev/null
  git pull git@github.com:cariad/machine.secrets.git
  popd > /dev/null
fi

info "Installing .ssh"
ln -sf "${HOME}/.machine.secrets/.ssh/config"         "${HOME}/.ssh/config"
ln -sf "${HOME}/.machine.secrets/.ssh/id_ed25519"     "${HOME}/.ssh/id_ed25519"
ln -sf "${HOME}/.machine.secrets/.ssh/id_ed25519.pub" "${HOME}/.ssh/id_ed25519.pub"

if ! command -v code &> /dev/null
then
  info "Installing Visual Studio Code"
  wget -O /tmp/vs.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  sudo apt install /tmp/vs.deb
  rm /tmp/vs.deb
fi

info "Installing Python build dependencies"

sudo apt install   \
  make             \
  build-essential  \
  libssl-dev       \
  zlib1g-dev       \
  libbz2-dev       \
  libreadline-dev  \
  libsqlite3-dev   \
  curl             \
  llvm             \
  libncursesw5-dev \
  xz-utils         \
  tk-dev           \
  libxml2-dev      \
  libxmlsec1-dev   \
  libffi-dev       \
  liblzma-dev      \
  -y

if [ ! -d "${HOME}/.pyenv" ]
then
  info "Cloning pyenv"
  git clone https://github.com/pyenv/pyenv.git "${HOME}/.pyenv"
else
  info "Pulling pyenv"
  pushd "${HOME}/.pyenv" > /dev/null
  git pull https://github.com/pyenv/pyenv.git
  popd > /dev/null
fi

info "Compiling pyenv extension"
pushd "${HOME}/.pyenv" > /dev/null
src/configure
make -C src
popd > /dev/null

source ~/.bash_profile

info "Installing Python ${PYENV_VERSION}"
pyenv install "${PYENV_VERSION}" --skip-existing

info "Downloading AWS CLI"
wget -O /tmp/aws.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
pushd /tmp > /dev/null
unzip -o aws.zip
rm aws.zip

if command -v aws &> /dev/null
then
  info "Upgrading AWS CLI"
  sudo ./aws/install --update
else
  info "Installing AWS CLI"
  sudo ./aws/install
fi

rm -rf aws
popd > /dev/null

info "Done!"
