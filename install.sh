#!/usr/bin/env bash
set -eu

cd "$(dirname "${BASH_SOURCE}")";

# fish
echo "############# fish install #############"

sudo apt update && sudo apt upgrade -y
sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish build-essential pkg-config libssl-dev

# brew
echo "############# brew install #############"

/usr/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
command -v brew >/dev/null 2>&1 || { echo "brew not on PATH after install; aborting" >&2; exit 1; }
BREW_PREFIX="$(brew --prefix)"
test -r ~/.bash_profile && echo "eval \$($BREW_PREFIX/bin/brew shellenv)" >> ~/.bash_profile
echo "eval \$($BREW_PREFIX/bin/brew shellenv)" >> ~/.profile

# rust
echo "############# rust install #############"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# rustup appends this to the shell profiles itself; source it here so cargo is
# on PATH for the current run.
# shellcheck disable=SC1091
source "$HOME/.cargo/env"
cargo install cargo-update
cargo install topgrade

# node
echo "############# mise / node install #############"

# brew shellenv above already put mise on PATH; npm ships with node.
brew install mise
grep -q "mise activate bash" ~/.bashrc 2>/dev/null || echo 'eval "$(mise activate bash)"' >> ~/.bashrc
mise use -g node@lts
mise use -g npm:pnpm

# oh-my-posh
echo "############# oh-my-posh install #############"

brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew update && brew upgrade oh-my-posh
