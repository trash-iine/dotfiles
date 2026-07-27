# dotfiles

Setting up development environment with

* Windows 11
* Visual Studio Code
* Windows Subsystem for Linux 2(WSL2)
  * brew (Linuxbrew)
  * fish
  * oh-my-posh
* Neovim

`install.sh` detects the OS with `uname` and works on both macOS and Linux/WSL2.
The apt steps are skipped on macOS, where the Xcode Command Line Tools provide
the compiler instead and fish comes from brew. Everything below the toolchain
setup (brew, Rust, mise, oh-my-posh, Neovim) is shared between the two.

## Visual Studio Code (VSCode)

Download and install from [VSCode](https://code.visualstudio.com)

## Windows Subsystem for Linux 2(WSL2)

In powershell, run as administator `wsl --install`. (cf. [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install#install-wsl-commandWindows))

```powershell
wsl --install
```

Then, restart your machine.
A console window will open and ask your user name and password.

## Font

I recommend [Roboto Mono Nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/RobotoMono).

Download `RobotoMono.zip` from Release page.

At Windows11, move to Settings --> 個人設定 --> Font and drag-and-drop `RobotoMono/*.ttf` (unzipped) to the designated area for install.

## Install prerequirements

If you trust me, run `install.sh`. Or,

### base toolchain

On Linux/WSL2:

```bash
sudo apt update && sudo apt upgrade
sudo apt install -y build-essential pkg-config libssl-dev
```

On macOS, the Xcode Command Line Tools cover the same ground:

```bash
xcode-select --install
```

### brew (linuxbrew)

Install brew according to [Homebrew](https://brew.sh/).

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Push Enter and continue.

Add linuxbrew to PATH.

```bash
test -d /opt/homebrew && eval $(/opt/homebrew/bin/brew shellenv)            # macOS (Apple silicon)
test -x /usr/local/bin/brew && eval $(/usr/local/bin/brew shellenv)         # macOS (Intel)
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
```

```bash
$brew -v
Homebrew 4.0.29
```

### fish

On Linux/WSL2:

```bash
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish
```

On macOS:

```bash
brew install fish
```

```bash
$fish -v
fish, version 3.6.1
```

### Rust

Install Rust according to [Homepage](https://www.rust-lang.org/learn/get-started).

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Select `1) Proceed with installation (default)`. (`install.sh` passes `-y` instead, so it never shows this prompt.)

Then install `cargo-update` and `topgrade`.

```bash
source "$HOME/.cargo/env"
cargo install cargo-update
cargo install topgrade
```

```bash
$topgrade
── 00:35:54 - Summary ──────────────────────────────────────────────────────────
System update: OK
config-update: OK
Brew: OK
snap: OK
rustup: OK
cargo: OK
```

### node (mise)

Node is managed with [mise](https://mise.jdx.dev). (This used to be volta, which is no longer maintained.)

```bash
brew install mise
mise use -g node@lts
mise use -g npm:pnpm
```

npm ships with node, so it needs no separate install.

mise has to be activated by your shell. `bootstrap.sh` takes care of fish; for bash, add it yourself:

```bash
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
```

```fish
# ~/.config/fish/config.fish
mise activate fish | source
```

### oh-my-posh

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew update && brew upgrade oh-my-posh
```

I recommend [easy-term theme](https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/easy-term.omp.json)

### neovim

```bash
brew install neovim ripgrep fd tree-sitter
```

The config in `.config/nvim` requires **Neovim 0.11 or newer** (it uses
`vim.lsp.config`, `vim.diagnostic.jump` and `vim.hl.on_yank`). Install it with
brew on Linux too — the apt package lags several major versions behind.

The rest of that line covers the plugins' external dependencies:

* `ripgrep` — Telescope's `live_grep`
* `fd` — Telescope's `find_files`
* `tree-sitter` (the CLI) — required by nvim-treesitter's `main` branch to build parsers
* a C compiler and `make` — `telescope-fzf-native` builds from source (covered by the base toolchain above)

`git` is needed too, for the lazy.nvim bootstrap and for mason.

Icons in neo-tree, lualine and which-key need a Nerd Font. On macOS:

```bash
brew install --cask font-roboto-mono-nerd-font
```

On Windows, install the font by hand (see [Font](#font) above) and point the
terminal at it.

The first `nvim` launch bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim)
itself and installs every plugin — let it finish before quitting. Afterwards:

```vim
:Lazy sync      " reconcile plugins with lazy-lock.json
:Mason          " manage language servers
:checkhealth    " verify the external dependencies above
```

Keymaps are documented in [`.config/nvim/KEYMAPS.md`](.config/nvim/KEYMAPS.md).
The leader key is `<Space>`.

`.vimrc` is kept for plain `vim`, which is left alone. `config.fish` sets
`EDITOR`/`VISUAL` to `nvim` when it is installed, so `git commit` and friends
open Neovim.

## Sync dotfiles

Run `bootstrap.sh` from the repository. It prompts before overwriting; pass `-f` (or `--force`) to skip the prompt.

```bash
./bootstrap.sh
```

It runs `git pull origin main` first, then copies these files into your home directory:

* `.vimrc`
* `.tmux.conf`
* `.config/fish/config.fish`
* `.config/nvim/` (the whole tree)

The files are **copied**, not symlinked, so re-run `bootstrap.sh` after every `git pull` to pick up changes. Copying your own edits back into the repository (rather than symlinking `$HOME` to it) keeps the two in sync in one direction only — edit the files here, not in `$HOME`.

### lazy-lock.json

`lazy-lock.json` is the one file Neovim writes back on its own: `:Lazy update`
rewrites `~/.config/nvim/lazy-lock.json`, and because the sync only runs
repository → `$HOME`, that change would be lost on the next `bootstrap.sh`.
After updating plugins, copy the lock file back and commit it:

```bash
cp ~/.config/nvim/lazy-lock.json .config/nvim/lazy-lock.json
```
