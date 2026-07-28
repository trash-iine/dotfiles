# Installed with `brew bundle --file=Brewfile`.
#
# A Brewfile is evaluated as Ruby, so OS.mac? / OS.linux? split the packages
# that differ between the two targets. WSL2 is the primary environment, so
# anything the Windows host provides is left out -- and there are no casks at
# all, because Linuxbrew has none.

# shell and prompt
brew "fish" if OS.mac? # Linux/WSL2 takes fish from the apt PPA -- see install.sh
brew "oh-my-posh"

# core
brew "git" # macOS would otherwise use the Xcode-bundled build
brew "gh"
brew "tmux"
brew "mise"
brew "jq"

# neovim and the external dependencies its plugins shell out to
brew "neovim"
brew "ripgrep"    # telescope live_grep
brew "fd"         # telescope find_files
brew "tree-sitter" # nvim-treesitter's main branch builds parsers with the CLI
brew "fzf"        # telescope-fzf-native and the fish key bindings

# command line tools wired up in .config/fish/conf.d/
brew "bat"
brew "eza"
brew "zoxide"
brew "git-delta" # git's pager, configured in .config/git/config
brew "lazygit"
brew "direnv"
brew "topgrade"

# build toolchain and everything else already in use
brew "cmake"
brew "pandoc"
brew "pipx"
brew "python@3.13"
brew "watch"
brew "git-filter-repo"
brew "llvm" if OS.mac?

# On WSL2 these come from Docker Desktop's WSL integration.
brew "docker" if OS.mac?
brew "docker-compose" if OS.mac?

# No Nerd Font here on purpose. On WSL2 the glyphs are drawn by the Windows
# terminal, so the font has to be installed on Windows by hand anyway, and
# Linuxbrew has no casks. Installing it by hand on macOS too keeps one procedure
# for both platforms -- and the cask refuses to adopt a hand-installed copy.
# See the Font section of the README.
