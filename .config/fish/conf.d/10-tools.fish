if status is-interactive
    # Each tool is guarded on its own so a missing one cannot take the rest of
    # the shell startup down with it.
    if type -q mise
        mise activate fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q direnv
        direnv hook fish | source
    end

    # `fzf --fish` needs fzf 0.48 or newer. The apt PPA that supplies fish on
    # WSL2 is unrelated to fzf, but an older fzf may still be on PATH, so the
    # flag is probed before its output is sourced.
    if type -q fzf; and fzf --fish >/dev/null 2>&1
        fzf --fish | source
    end
end
