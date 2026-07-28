#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# WSL2 mounts the Windows drives as DrvFs, which does not support the symlinks
# this script relies on. Catch that before touching anything.
case "$REPO" in
	/mnt/*)
		cat >&2 <<-EOF
		The repository lives on a Windows drive ($REPO).

		DrvFs does not support the symlinks this script creates. Clone the
		repository under your Linux home instead:

		    git clone https://github.com/trash-iine/dotfiles.git ~/dotfiles
		EOF
		exit 1
		;;
esac

# Paths are relative to both $REPO and $HOME.
#
# Directories are linked whole rather than file by file. Anything the app writes
# back -- lazy-lock.json, `git config --global`, fish_variables -- is written
# with a lockfile and a rename, which replaces a file symlink with a regular
# file and breaks the link. With the directory linked, the rename happens inside
# the repository and the change is tracked straight away.
LINKS=(
	.tmux.conf
	.vimrc
	.config/fish
	.config/nvim
	.config/git
	.config/bat
	.config/lazygit
)

# ~/.claude holds session state, caches and the daemon socket, so only the one
# file can be linked. Claude Code rewrites settings.json when you change a
# setting through /config, which replaces the symlink -- re-run this script if
# that happens.
LINKS+=(.claude/settings.json)

# fish is the login shell on both platforms. These only matter on macOS, where
# zsh is the system default and still runs for non-interactive shells; on
# WSL2 that role belongs to bash, which install.sh configures directly.
if [ "$(uname -s)" = "Darwin" ]; then
	LINKS+=(.zshenv .zprofile)
fi

DRY_RUN=0
FORCE=0

for arg in "$@"; do
	case "$arg" in
		-n|--dry-run) DRY_RUN=1 ;;
		-f|--force) FORCE=1 ;;
		-h|--help)
			echo "usage: $0 [-n|--dry-run] [-f|--force]"
			exit 0
			;;
		*) echo "unknown option: $arg" >&2; exit 1 ;;
	esac
done

say() {
	if [ "$DRY_RUN" -eq 1 ]; then
		echo "[dry-run] $*"
	else
		echo "$*"
	fi
}

run() {
	[ "$DRY_RUN" -eq 1 ] || "$@"
}

# Move an existing path aside. Refuses to clobber an older backup, so a second
# run can never destroy the original.
backup() {
	local target="$1"
	if [ -e "$target.bak" ] || [ -L "$target.bak" ]; then
		echo "error: $target.bak already exists; move it aside first" >&2
		exit 1
	fi
	say "backup  $target -> $target.bak"
	run mv "$target" "$target.bak"
}

link() {
	local rel="$1"
	local src="$REPO/$rel"
	local target="$HOME/$rel"

	if [ ! -e "$src" ]; then
		echo "error: $src does not exist" >&2
		exit 1
	fi

	if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
		echo "ok      $rel (already linked)"
		return
	fi

	# A symlink pointing elsewhere is stale rather than precious, so it goes
	# without a backup; a real file or directory is the user's and is kept.
	if [ -L "$target" ]; then
		say "replace $rel (stale symlink)"
		run rm "$target"
	elif [ -e "$target" ]; then
		# Nothing to preserve if the contents already match, and skipping the
		# backup keeps a stale .bak from blocking the run over an identical file.
		if diff -rq "$target" "$src" >/dev/null 2>&1; then
			say "replace $rel (identical to the repository)"
			run rm -rf "$target"
		else
			backup "$target"
		fi
	fi

	say "link    $rel"
	run mkdir -p "$(dirname "$target")"
	run ln -sfn "$src" "$target"
}

sync_dotfiles() {
	local rel
	for rel in "${LINKS[@]}"; do
		link "$rel"
	done

	# git reads ~/.gitconfig after ~/.config/git/config, so leaving it in place
	# would silently override everything the repository sets.
	if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
		backup "$HOME/.gitconfig"
	fi
}

if [ "$DRY_RUN" -eq 1 ] || [ "$FORCE" -eq 1 ]; then
	sync_dotfiles
else
	echo "This links files in your home directory to $REPO."
	echo "Anything already there is moved aside to <path>.bak."
	read -r -p "Continue? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sync_dotfiles
	fi
fi
