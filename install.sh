#!/usr/bin/env bash
set -eu

cd "$(dirname "${BASH_SOURCE}")";

# fish
echo "############# fish install #############"

sudo apt update && sudo apt upgrade
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish build-essential pkg-config libssl-dev

# brew
echo "############# brew install #############"

/usr/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.profile
source ~/.profile

# rust
echo "############# rust install #############"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-update
cargo install topgrade
test -r ~/.bash_profile && echo "source ~/.cargo/env" >> ~/.bash_profile
echo "source ~/.cargo/env" >> ~/.profile
source ~/.profile

# npm
echo "############# npm install #############"

curl https://get.volta.sh | bash
source ~/.profile
volta install node
volta install npm
volta install pnpm

# oh-my-posh
echo "############# oh-my-posh install #############"

brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew update && brew upgrade oh-my-posh
