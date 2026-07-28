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
setup (brew, the Brewfile, Rust, mise, Neovim) is shared between the two.

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

The glyphs in neo-tree, lualine and which-key are drawn by whatever renders the
terminal, so on WSL2 the font has to be installed on **Windows** — not inside
the distribution — and then selected in Windows Terminal or VSCode.

On macOS, drop the same `*.ttf` files into `~/Library/Fonts` (or open them in
Font Book). The font is deliberately **not** in the Brewfile: Linuxbrew has no
casks, WSL2 needs the Windows-side install regardless, and the cask refuses to
adopt a copy that was installed by hand. One procedure covers both platforms.

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

Linuxbrew has no casks and the PPA is what this setup has always used, so on
Linux/WSL2 fish comes from apt:

```bash
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish
```

On macOS it is listed in the Brewfile below and needs nothing extra.

```bash
$fish -v
fish, version 3.6.1
```

### packages (Brewfile)

Everything else is listed in [`Brewfile`](Brewfile):

```bash
brew bundle --file=Brewfile
```

The Brewfile is evaluated as Ruby, so it splits the entries that differ between
the two targets itself:

* `docker` and `docker-compose` are macOS-only — on WSL2 they come from Docker
  Desktop's WSL integration
* `llvm` is macOS-only
* `fish` is macOS-only, because Linux takes it from the PPA above

The Nerd Font is not in the Brewfile at all — see [Font](#font).

`brew bundle check --file=Brewfile` reports what is still missing without
installing anything.

### Rust

Install Rust according to [Homepage](https://www.rust-lang.org/learn/get-started).

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Select `1) Proceed with installation (default)`. (`install.sh` passes `-y` instead, so it never shows this prompt.)

Then install `cargo-update`, which only makes sense for crates installed with
cargo and so is not in the Brewfile:

```bash
source "$HOME/.cargo/env"
cargo install cargo-update
```

`topgrade` used to be installed here too; it now comes from the Brewfile.

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

mise itself comes from the Brewfile. Pick the runtimes with:

```bash
mise use -g node@lts
mise use -g npm:pnpm
```

npm ships with node, so it needs no separate install.

mise has to be activated by your shell. `.config/fish/conf.d/10-tools.fish`
takes care of fish; bash stays the non-interactive shell on WSL2, so
`install.sh` adds the line there as well:

```bash
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
```

### oh-my-posh

oh-my-posh comes from the Brewfile. The theme is set in
`.config/fish/conf.d/20-prompt.fish`; I recommend
[easy-term theme](https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/easy-term.omp.json).

It used to be installed from the `jandedobbeleer/oh-my-posh` tap. It is in
homebrew-core now, and Homebrew 6 refuses to load formulae from untrusted
third-party taps, so the Brewfile uses the core formula. If an older machine
still has the tap, the tap version shadows the core one and every `brew` command
fails with a trust error — drop it with:

```bash
HOMEBREW_NO_REQUIRE_TAP_TRUST=1 brew uninstall oh-my-posh
brew untap jandedobbeleer/oh-my-posh
brew install oh-my-posh
```

### neovim

Neovim and its external dependencies are all in the Brewfile.

The config in `.config/nvim` requires **Neovim 0.11 or newer** (it uses
`vim.lsp.config`, `vim.diagnostic.jump` and `vim.hl.on_yank`). It is installed
with brew on Linux too — the apt package lags several major versions behind.

The rest of the Neovim block in the Brewfile covers the plugins' external
dependencies:

* `ripgrep` — Telescope's `live_grep`
* `fd` — Telescope's `find_files`
* `tree-sitter` (the CLI) — required by nvim-treesitter's `main` branch to build parsers
* a C compiler and `make` — `telescope-fzf-native` builds from source (covered by the base toolchain above)

`git` is needed too, for the lazy.nvim bootstrap and for mason.

Icons need a Nerd Font — see [Font](#font) above.

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

### login shell

fish is the login shell on both platforms. `install.sh` does this last, because
`chsh` asks for a password:

```bash
FISH="$(command -v fish)"
grep -qx "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells
chsh -s "$FISH"
```

The path is looked up rather than hardcoded because it differs: `/usr/bin/fish`
from the apt PPA on WSL2, the brew prefix on macOS.

On WSL2 the change only takes effect in a new session — run `wsl --shutdown`
from Windows and reopen the distribution. On macOS, open a new terminal.

Interactive configuration lives in `.config/fish/conf.d/`, which fish reads
before `config.fish`:

| file | contents |
| --- | --- |
| `00-path.fish` | brew shellenv, cargo, pipx, llvm, `GITLAB_HOME` |
| `10-tools.fish` | mise, zoxide, direnv and fzf shell integration |
| `20-prompt.fish` | oh-my-posh |
| `30-abbr.fish` | abbreviations |

Anything machine-specific goes in `conf.d/*.local.fish`, which is gitignored.

bash and zsh are only kept working for non-interactive use: `install.sh` writes
to `~/.profile` and `~/.bashrc` on WSL2, and `.zshenv`/`.zprofile` are linked on
macOS, where zsh is still the system shell.

## Sync dotfiles

> **WSL2**: clone this repository under your Linux home (`~/dotfiles`), **not**
> under `/mnt/c/...`. The Windows drives are mounted as DrvFs, which does not
> support the symlinks below. `bootstrap.sh` refuses to run from `/mnt` rather
> than leaving you with a half-broken home directory.

Run `bootstrap.sh` from the repository:

```bash
./bootstrap.sh
```

It **symlinks** the files below into your home directory. Anything already there
is moved aside to `<path>.bak`, and it refuses to overwrite an existing `.bak`,
so a second run can never destroy the original. Re-running is otherwise a no-op.

| flag | effect |
| --- | --- |
| `-n`, `--dry-run` | print what would be linked and backed up, change nothing |
| `-f`, `--force` | skip the confirmation prompt |

Linked paths:

* `.vimrc`
* `.tmux.conf`
* `.config/fish/` (the whole tree)
* `.config/nvim/` (the whole tree)
* `.config/git/`
* `.config/bat/`
* `.config/lazygit/`
* `.claude/settings.json`
* `.zshenv`, `.zprofile` (macOS only)

Because these are symlinks and not copies, editing a file in `$HOME` and editing
it here are the same thing, and `git pull` takes effect immediately — there is
no second step. Directories are linked whole rather than file by file: anything
an app writes back (`lazy-lock.json`, `git config --global`, `fish_variables`)
is written with a lockfile and a rename, which would replace a *file* symlink
with a regular file and break the link. With the directory linked, the rename
happens inside the repository and the change shows up in `git status` straight
away.

`bootstrap.sh` also moves `~/.gitconfig` aside if it is a real file, because git
reads it after `~/.config/git/config` and it would otherwise override everything
this repository sets.

## Command line tools

The Brewfile installs these on top of the setup above; `.config/fish/conf.d/`
wires them in.

| tool | what it replaces / does | config |
| --- | --- | --- |
| [`bat`](https://github.com/sharkdp/bat) | `cat`, with syntax highlighting | `.config/bat/config` |
| [`eza`](https://github.com/eza-community/eza) | `ls`, with icons and git status | abbreviations |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | `cd` that learns your directories (`z`) | — |
| [`fzf`](https://github.com/junegunn/fzf) | fuzzy finder, plus `Ctrl-R` history search | — |
| [`git-delta`](https://github.com/dandavison/delta) | git's diff pager | `[delta]` in `.config/git/config` |
| [`lazygit`](https://github.com/jesseduffield/lazygit) | git TUI | `.config/lazygit/config.yml` |
| [`direnv`](https://direnv.net/) | per-directory environment variables | — |
| [`jq`](https://jqlang.github.io/jq/) | JSON on the command line | — |
| [`gh`](https://cli.github.com/) | GitHub CLI | — |

`bat` has no Tokyo Night theme built in, so it and delta both use `Nord`, the
closest of the bundled dark themes. `bat --list-themes` shows the alternatives.

### git

`.config/git/config` sets `pull.rebase`, `push.autoSetupRemote`, `fetch.prune`,
`rebase.autoStash`, the histogram diff algorithm, `zdiff3` conflict markers and
`rerere`. `core.autocrlf = input` is there for WSL2, where repositories are
shared with Windows tools that write CRLF.

Aliases:

| alias | expands to |
| --- | --- |
| `git st` | `status --short --branch` |
| `git sw` | `switch` |
| `git co` | `checkout` |
| `git br` | `branch` |
| `git lg` | one-line graph log |
| `git last` | `log -1 HEAD --stat` |
| `git amend` | `commit --amend --no-edit` |
| `git undo` | `reset --soft HEAD~1` |

For a machine-specific identity (a work email, a signing key), write
`.config/git/config.local` — it is gitignored and pulled in by `[include]`.

## Claude Code

`.claude/settings.json` is the global Claude Code configuration. Besides the
model, effort level and TUI renderer it sets `language` (Japanese, which the
skills and notes are written in), `cleanupPeriodDays` (90 rather than the
default 30, so `~/.claude/projects/*/` still holds enough transcript history to
look back through), `fallbackModel` (Sonnet, so a busy Opus does not stall a
session) and an empty `attribution`, which drops the `Co-Authored-By: Claude`
trailer from commits and the signature from PR bodies.

The rest of the file is permissions. They apply in the order deny > ask > allow:

* `deny` keeps Claude out of the credential stores — `~/.ssh`, `~/.gnupg`,
  `~/.password-store`, `~/.aws`, `~/.config/gh`, `~/.config/gcloud`, `~/.kube`,
  `~/.netrc`, the macOS keychain files, any `.env`, `*.pem`, `*.key` or
  `id_rsa*` anywhere on disk — and out of the commands that read them (`pass`,
  `gopass`, `op`, `gpg -d`, `security find-*-password`, `gh auth token`,
  `printenv`).
* `ask` forces a confirmation for what cannot be undone: `git push`,
  `reset --hard`, `clean`, `rebase`, `branch -d/-D`, `checkout --`, `rm -rf`.
  This is what makes auto mode safe to leave on — auto mode approves on its own,
  and these rules pull the prompt back.
* `allow` covers reading and looking around — `git status`/`diff`/`log`/`show`,
  `rg`, `fd`, `eza`, `bat`, `jq`, `mise ls`, the read-only `gh` subcommands. The
  commands are the ones the Brewfile installs. `git remote` is allowed only as
  the exact `git remote -v`, because `git remote set-url` can redirect a push.

Two caveats. Denied paths are passed to the sandbox as read-denied, but outside
the sandbox the `Bash(...)` rules are prefix matches, not a security boundary —
they stop the obvious `pass show foo`, not a deliberately obfuscated command.
And a `Read(...)` deny does not cover reads that go through the shell: allowing
`bat`, `head`, `tail` and `rg` leaves `bat ~/.ssh/id_rsa` reachable. That is a
deliberate trade for not being asked about every `rg`; what stays blocked is the
commands that *extract* a secret rather than print a file.

`~/.claude` holds session state, caches and the daemon socket, so this is the
one path linked as a single file rather than as a directory. Changing a setting
through `/config` rewrites the file and replaces the symlink with a regular
file — re-run `bootstrap.sh` if that happens, after copying anything you want to
keep back into the repository.
