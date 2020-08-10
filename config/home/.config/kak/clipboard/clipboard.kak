hook global RegisterModified '"' %{
    nop %sh{
        printf %s "$kak_main_reg_dquote" | xsel -i -p && xsel -o -p | xsel -i -b
    }
}
