# Case insentive search by default
map -docstring "case insentive search" global normal / "/(?i)"
# Mimic vim's '#' key
map -docstring "search word under current cursor" global normal <#> <a-i>w*
