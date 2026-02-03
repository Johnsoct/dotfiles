alias cl="clear"
alias gtmix="cd ~/mix/mix"
alias gtdev="cd ~/dev"
alias gtbobbe="cd ~/dev/bobtail"
alias gtbobfe="cd ~/dev/bobtail/client"
alias bobdb="dropdb bobtail_dev && createdb bobtail_dev && npm run migration:run:dev && npm run seed:dev"
alias ..='cd ..'
alias pg_start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg_stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias py="python3"
#alias vim="/usr/bin/gvim -v"
alias nr="npm run"
alias nri="rm -rf node_modules && npm install"
alias pn="pnpm"
alias pr="pnpm run"

# LINUX
alias battery="upower -i $(upower -e | grep BAT)"
alias bright="brightnessctl"

# File system
alias ls='eza -lh --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
# alias cd='z'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias n='nvim'
alias g='git'
alias d='docker'
alias r='rails'
alias bat='batcat'
alias lzg='lazygit'
alias lzd='lazydocker'

# Git commit
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcmsg='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcans!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'

# Git add
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

# Git branch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'

# Git bisect
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# Git checkout
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout main'

# Git config
alias gcf='git config --list'

# Git clone
alias gcl='git clone --recursive'

# Git clean
alias gclean='git clean -fd'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'

# Git cherry-pick
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# Git diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdw='git diff --word-diff'
alias gdt='git diff-tree --no-commit-id --name-only -r'

# Git fetch
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

# Git pull
alias gl='git pull'
alias gup='git pull --rebase'
alias ggpull='git pull origin $(git_current_branch)'
alias gupv='git pull --rebase -v'
alias glum='git pull upstream main'

# Git push
alias ggpush='git push origin $(git_current_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
alias gpu='git push upstream'
alias gpv='git push -v'

# Git merge
alias gm='git merge'
alias gmom='git merge origin/main'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/main'
alias gma='git merge --abort'

# Git remote
alias gr='git remote'
alias gra='git remote add'

# Git rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase main'
alias grbs='git rebase --skip'

# Git remote
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grup='git remote update'
alias grv='git remote -v'

# Git status
alias gsb='git status -sb'
alias gss='git status -s'
alias gst='git status'

# Git stash
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
