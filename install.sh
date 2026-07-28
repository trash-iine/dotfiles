#!/usr/bin/env bash
set -eu

cd "$(dirname "${BASH_SOURCE}")";

OS="$(uname -s)"
case "$OS" in
	Darwin|Linux) ;;
	*) echo "unsupported OS: $OS" >&2; exit 1 ;;
esac

# base toolchain
echo "############# base toolchain install #############"

if [ "$OS" = "Linux" ]; then
	sudo apt update && sudo apt upgrade -y
	sudo apt install -y build-essential pkg-config libssl-dev
else
	# The Command Line Tools give us clang and make, which telescope-fzf-native
	# and the treesitter parsers need to build. The installer opens a GUI dialog
	# and returns immediately, so the download finishes in the background.
	xcode-select -p >/dev/null 2>&1 || xcode-select --install
fi

# brew
echo "############# brew install #############"

# The installer script handles both macOS and Linux; brew has to come before
# fish because that is how fish gets installed on macOS.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d /opt/homebrew && eval $(/opt/homebrew/bin/brew shellenv)            # macOS (Apple silicon)
test -x /usr/local/bin/brew && eval $(/usr/local/bin/brew shellenv)         # macOS (Intel)
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
command -v brew >/dev/null 2>&1 || { echo "brew not on PATH after install; aborting" >&2; exit 1; }
BREW_PREFIX="$(brew --prefix)"
if test -r ~/.bash_profile; then
	grep -q "brew shellenv" ~/.bash_profile || echo "eval \$($BREW_PREFIX/bin/brew shellenv)" >> ~/.bash_profile
fi
grep -q "brew shellenv" ~/.profile 2>/dev/null || echo "eval \$($BREW_PREFIX/bin/brew shellenv)" >> ~/.profile

# fish
echo "############# fish install #############"

# Linuxbrew has no casks and the apt package is what the WSL2 setup has always
# used, so fish comes from the PPA there and from the Brewfile on macOS.
if [ "$OS" = "Linux" ]; then
	sudo apt-add-repository -y ppa:fish-shell/release-3
	sudo apt update
	sudo apt install -y fish
fi

# packages
echo "############# brew bundle #############"

# Everything else -- neovim, the CLI tools, the build toolchain -- is listed in
# the Brewfile, which splits the platform-specific entries itself.
brew bundle --file="$PWD/Brewfile"

# rust
echo "############# rust install #############"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# rustup appends this to the shell profiles itself; source it here so cargo is
# on PATH for the current run.
# shellcheck disable=SC1091
source "$HOME/.cargo/env"
# cargo-update only makes sense for crates installed with cargo, so it stays
# here rather than in the Brewfile. topgrade moved to the Brewfile.
cargo install cargo-update

# node
echo "############# mise / node install #############"

# mise comes from the Brewfile; fish activates it in conf.d/10-tools.fish, and
# bash needs the line below because it stays the non-interactive shell on WSL2.
grep -q "mise activate bash" ~/.bashrc 2>/dev/null || echo 'eval "$(mise activate bash)"' >> ~/.bashrc
mise use -g node@lts
mise use -g npm:pnpm

# login shell
echo "############# login shell #############"

# The path differs per platform -- /usr/bin/fish from apt on WSL2, the brew
# prefix on macOS -- so it is looked up rather than hardcoded. chsh asks for a
# password, which is why this runs last.
FISH="$(command -v fish)"
if [ -n "$FISH" ]; then
	grep -qx "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells >/dev/null
	if [ "${SHELL:-}" != "$FISH" ]; then
		chsh -s "$FISH"
		if [ "$OS" = "Linux" ]; then
			echo "Run 'wsl --shutdown' from Windows and reopen WSL for this to take effect."
		else
			echo "Open a new terminal for this to take effect."
		fi
	fi
fi
