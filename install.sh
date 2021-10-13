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

if ! command -v git &> /dev/null
then
  info "Installing Git"
  sudo apt install git -y
fi

info "Installing .gitconfig"
ln -sf "${PWD}/.gitconfig" "${HOME}/.gitconfig"

if [ ! -d "${HOME}/.machine.secrets" ]
then
  # Intentionally use HTTP authentication since we don't have our SSH keys yet:

  echo
  echo "⚠️  Visit https://github.com/settings/tokens/new to create a GitHub"
  echo "⚠️  personal access token. The token can be revoked after"
  echo "⚠️  machine.secrets has been cloned; your cloned SSH key will be used"
  echo "⚠️  for subsequent pulls."
  git clone https://github.com/cariad/machine.secrets.git "${HOME}/.machine.secrets"
else
  echo
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
