config.load_autoconfig()

c.tabs.select_on_remove = "last-used"
c.tabs.background = False
c.tabs.position = "bottom"

config.bind(',k', 'spawn --userscript qute-pass-with-fallback --dmenu-invocation="fuzzel --dmenu"')
config.bind('aa', 'spawn foot --log-level=error --app-id=_float def {primary}')
config.bind('<Ctrl-n>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl-p>', 'completion-item-focus prev', mode='command')
config.bind('<F12>', 'config-cycle --temp --print content.user_stylesheets ["user.css"] []')
config.bind('<F1>', 'config-cycle --temp --print content.proxy socks://127.0.0.1:7891 system')
