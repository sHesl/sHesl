eval "$(starship init zsh)"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

alias cd..='cd ..'
alias shesl='cd ~/go/src/github.com/sHesl'
alias uchown='sudo chown -R $(id -u):$(id -g)'
alias cover='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'
alias src='source ~/.zshrc'
alias myip="curl ifconfig.me"
alias docker="podman"
alias 4claude='~/code/scripts/4claude.sh'
alias main='cd /Users/shesl/code/worktrees/cluster-ops/ruddy-otter/cluster-ops'

# fluiddex viewer on :3000, live-reloading against ~/code/codex + ~/code/fluiddex (takes --port)
alias fluiddex='bun --cwd=$HOME/.claude/apps/fluiddex run dev'

# Push and watch CI (passes all args through to git push, e.g. gpw --force-with-lease)
alias gpw='~/.config/starship/git-push-watch.sh'

# PR aliases
alias pro='gh pr view --web'
alias prci='gh pr checks --web'

function pr() {
  local data number url icon checks_url
  data=$(gh pr view --json number,url,statusCheckRollup 2>/dev/null) || { echo "No PR found"; return 1; }
  number=$(printf "%s" "$data" | jq -r '.number')
  url=$(printf "%s" "$data" | jq -r '.url')
  checks_url="${url}/checks"
  icon=$(printf "%s" "$data" | jq -r '
    if (.statusCheckRollup // [] | length) == 0 then "󰁪"
    elif [.statusCheckRollup[] | select(.conclusion == null)] | length > 0 then "󰁪"
    elif [.statusCheckRollup[] | select(.conclusion != "SUCCESS" and .conclusion != "NEUTRAL" and .conclusion != "SKIPPED")] | length > 0 then "󰅖"
    else "󰄬"
    end
  ')
  printf '\033]8;;%s\033\\#%s\033]8;;\033\\ \033]8;;%s\033\\%s\033]8;;\033\\\n' "$url" "$number" "$checks_url" "$icon"
}

function gitrecent() { git for-each-ref --sort=-committerdate refs/heads/ | head -n $1; }

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

. "$HOME/.moon/bin/env"

# Print an end-of-run pass/fail recap per task after every local moon run/ci
# (values: none, minimal, normal, detailed; minimal omits task names)
export MOON_SUMMARY=normal

# depot CLI (depot.dev): not in nixpkgs, installed via https://depot.dev/install-cli.sh
export DEPOT_INSTALL_DIR="$HOME/.depot/bin"
export PATH="$DEPOT_INSTALL_DIR:$PATH"

# proto only serves repos with a committed .prototools; devbox goes on after it and wins
export PATH="$HOME/.proto/shims:$HOME/.proto/bin:$PATH"
eval "$(devbox global shellenv --init-hook 2>/dev/null)"
alias awssso='devbox global run awssso'
alias copy-stack='devbox global run copy-stack -- -C "$PWD"'

# Fix Logitech mouse scroll wheel by restarting Logi Options+ (macOS relaunches it)
alias fixmouse='sudo pkill -f "logioptionsplus"'

claude() {
  eval "$(devbox shellenv 2>/dev/null)"
  command claude "$@"
}
alias show-me='~/code/scripts/show-me.sh'
