# Case insentive search by default
map -docstring "case insentive search" global normal / "/(?i)"
# Mimic vim's '#' key
map -docstring "search word under current cursor" global normal <#> <a-i>w*
# Clear current search register
map -docstring "clear current search register" global user <space> ": reg '/' ''<ret>jk"
# Highlight current search content
# add-highlighter global/search dynregex '%reg{/}' 0:default,+bi
