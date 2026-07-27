if status is-interactive
    # Commands to run in interactive sessions can go here

    if type -q mise
        mise activate fish | source
    end

    if type -q oh-my-posh; and type -q brew
        oh-my-posh init fish --config (brew --prefix oh-my-posh)/themes/easy-term.omp.json | source
    end
end
