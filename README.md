# My $HOME

Prefer using `jj`:

```
git clone --bare https://codeberg.org/Totorow/home.git /path/home.git
mkdir -p /path/home.git/info && echo '*' >> /path/home.git/info/exclude
cd ~ && jj git init --git-repo /path/home.git
```

Or just `git`:

```
cd ~
git init
git remote add origin https://github.com/tw4452852/MyConfig # Or ssh://git@codeberg.org/Totorow/home.git
git fetch
git checkout -ft origin/master
echo '*' >> .git/info/exclude
git config status.showUntrackedFiles no
```
