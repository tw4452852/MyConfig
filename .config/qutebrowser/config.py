config.load_autoconfig()

c.editor.command = ["editinacme", "{file}"]
c.url.searchengines = {"DEFAULT": "https://www.google.com/search?q={}"}
c.tabs.select_on_remove = "last-used"
c.tabs.background = False

config.bind(',k', 'spawn --userscript qute-pass-with-fallback --dmenu-invocation="dmenu -b"')
config.bind('aa', 'spawn foot def {primary}')

c.content.user_stylesheets = ["font.css"]
