config.load_autoconfig()

c.editor.command = ["editinacme", "{file}"]
c.url.searchengines = {"DEFAULT": "https://www.google.com/search?q={}"}
c.tabs.select_on_remove = "last-used"
c.tabs.background = False

config.bind(',k', 'spawn --userscript qute-pass --dmenu-invocation=dmenu')
config.bind('aa', 'spawn -o curl -s dict://dict.org/d:{primary}:wn')