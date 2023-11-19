# dotfiles

Setting up development environment with

* Windows 11
* Visual Studio Code
* Windows Subsystem for Linux 2(WSL2)
  * brew (Linuxbrew)
  * fish
  * oh-my-posh

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

### apt install

```bash
sudo apt update && sudo apt upgrade
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish build-essential pkg-config libssl-dev
```

```bash
$fish -v
fish, version 3.6.1
```

### brew (linuxbrew)

Install brew according to [Homebrew](https://brew.sh/).

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Push Enter and continue.

Add linuxbrew to PATH.

```bash
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
```

```bash
$brew -v
Homebrew 4.0.29
```

### Rust

Install Rust according to [Homepage](https://www.rust-lang.org/learn/get-started).

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Select `1) Proceed with installation (default)`.

Then install `volta`, `cargo-update` and `topgrade`.

```bash
cargo install volta
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

### npm

Install npm with volta.

```bash
volta install node
volta install npm
volta install pnpm
```

## oh-my-posh

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew update && brew upgrade oh-my-posh
```

I recommend [easy-term theme](https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/easy-term.omp.json)

## vim

```bash
ln -sf $DOTFILEDIR/.vimrc $HOME/.vimrc
```

## tmux

```bash
ln -sf $DOTFILEDIR/.tmux.conf $HOME/.tmux.conf
```

## nu shell

```sh
brew install nushell
```
