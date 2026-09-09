eval "$(starship init zsh)"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

alias cd..='cd ..'
alias shesl='cd ~/go/src/github.com/sHesl'
alias uchown='sudo chown -R $(id -u):$(id -g)'
alias cover='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'
alias src='source ~/.zshrc'
alias myip="curl ifconfig.me"
alias docker="podman"

# Push and watch CI (passes all args through to git push, e.g. gpw --force-with-lease)
alias gpw='~/.config/starship/git-push-watch.sh'

# PR aliases
alias pro='gh pr view --web'
alias prci='gh pr checks --web'

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

# devbox global: personal ambient tooling on PATH in every shell (worktree-independent)
eval "$(devbox global shellenv --init-hook 2>/dev/null)"
# re-assert proto LAST so the .prototools-pinned toolchain always wins over nix/devbox
export PATH="$HOME/.proto/shims:$HOME/.proto/bin:$PATH"
alias awssso='devbox global run awssso'

# Fix Logitech mouse scroll wheel by restarting Logi Options+ (macOS relaunches it)
alias fixmouse='sudo pkill -f "logioptionsplus"'
