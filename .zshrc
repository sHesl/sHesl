# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias cd..='cd ..'
alias shesl='cd ~/go/src/github.com/sHesl'
alias tm='cd ~/go/src/github.com/thought-machine'
alias uchown='sudo chown -R $(id -u):$(id -g)'
alias cover='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'
alias src='source ~/.zshrc'
alias code="open -a /Applications/Visual\ Studio\ Code.app"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias aws-lab-nuke="gh workflow run Nuke -R sHesl/aws-lab-nuke"

function gitrecent() { git for-each-ref --sort=-committerdate refs/heads/ | head -n $1; }
