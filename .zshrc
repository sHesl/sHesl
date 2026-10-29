eval "$(starship init zsh)"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

alias cd..='cd ..'
alias src='source ~/.zshrc'

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
