hook global RegisterModified '"' %{
    nop %sh{
        printf %s "$kak_main_reg_dquote" | wl-copy > /dev/null 2>&1 &
        [ -n "$TMUX" ] && tmux set-buffer -- "$kak_main_reg_dquote" &
    }
}
