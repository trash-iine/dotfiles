if status is-interactive
    if type -q oh-my-posh; and type -q brew
        oh-my-posh init fish --config (brew --prefix oh-my-posh)/themes/easy-term.omp.json | source
    end
end
