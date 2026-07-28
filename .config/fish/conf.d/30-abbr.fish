if status is-interactive
    # -g keeps these out of fish_variables, which is gitignored but still lives
    # inside the symlinked repository.
    if type -q eza
        abbr -a -g ls 'eza --icons --group-directories-first'
        abbr -a -g ll 'eza -l --icons --group-directories-first --git'
        abbr -a -g la 'eza -la --icons --group-directories-first --git'
        abbr -a -g lt 'eza --tree --level=2 --icons'
    end

    if type -q bat
        abbr -a -g cat bat
    end

    if type -q lazygit
        abbr -a -g lg lazygit
    end

    if type -q nvim
        abbr -a -g v nvim
    end

    abbr -a -g g git
    abbr -a -g gs 'git status --short --branch'
    abbr -a -g ga 'git add'
    abbr -a -g gc 'git commit'
    abbr -a -g gd 'git diff'
    abbr -a -g gp 'git push'
    abbr -a -g gsw 'git switch'
    abbr -a -g glg 'git lg'

    abbr -a -g t tmux
    abbr -a -g ta 'tmux attach'
end
