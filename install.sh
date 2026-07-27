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

if [ "$OS" = "Linux" ]; then
	sudo apt-add-repository -y ppa:fish-shell/release-3
	sudo apt update
	sudo apt install -y fish
else
	brew install fish
fi

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

# neovim
echo "############# neovim install #############"

# The config in .config/nvim needs Neovim >= 0.11 (vim.lsp.config,
# vim.diagnostic.jump, vim.hl.on_yank), so brew is used on Linux too -- the apt
# package is far too old. ripgrep and fd back Telescope's grep and file search,
# and the tree-sitter CLI is required by nvim-treesitter's main branch.
brew install neovim ripgrep fd tree-sitter

if [ "$OS" = "Darwin" ]; then
	# neo-tree, lualine and which-key render Nerd Font glyphs. On Windows the
	# font is installed by hand (see README).
	brew install --cask font-roboto-mono-nerd-font
fi
