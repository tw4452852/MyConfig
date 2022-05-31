config.load_autoconfig()

c.editor.command = ["editinacme", "{file}"]
c.url.searchengines = {"DEFAULT": "https://www.google.com/search?q={}"}

config.bind(',k', 'spawn --userscript qute-pass --dmenu-invocation=dmenu')