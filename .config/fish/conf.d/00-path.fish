# The brew prefix differs between macOS (/opt/homebrew or /usr/local) and
# Linuxbrew (/home/linuxbrew/.linuxbrew), so it gets probed rather than
# hardcoded. shellenv sets MANPATH and INFOPATH along with PATH.
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew $HOME/.linuxbrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
    if test -x $brew_bin
        $brew_bin shellenv fish | source
        break
    end
end
set -e brew_bin

# rustup, and anything installed with `cargo install`.
if test -d $HOME/.cargo/bin
    fish_add_path -g $HOME/.cargo/bin
end

# pipx drops its shims here.
if test -d $HOME/.local/bin
    fish_add_path -g $HOME/.local/bin
end

# brew's llvm is keg-only, so its clang and lld are not linked into the prefix.
if type -q brew
    set -l llvm_bin (brew --prefix)/opt/llvm/bin
    if test -d $llvm_bin
        fish_add_path -g $llvm_bin
    end
end

set -gx GITLAB_HOME $HOME/Workspace/gitlab
