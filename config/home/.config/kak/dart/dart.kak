hook global WinSetOption filetype=dart %{
    # Indent with 2 space
    set-option global indentwidth 2
}
hook global BufWritePost .*\.dart %{
  echo %sh{
     dartfmt -w $kak_buffile
  }
}
