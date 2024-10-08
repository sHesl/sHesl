# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias cd..='cd ..'
alias shesl='cd ~/go/src/github.com/sHesl'
alias uchown='sudo chown -R $(id -u):$(id -g)'
alias cover='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'
alias src='source ~/.zshrc'
alias code="open -a /Applications/Visual\ Studio\ Code.app"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias myip="curl ifconfig.me"

function gitrecent() { git for-each-ref --sort=-committerdate refs/heads/ | head -n $1; }

function enhanced_cd() {
    if [[ $1 == "." ]]; then
        builtin cd .
    elif [[ $1 =~ ^\.\.+$ ]]; then
        local levels=$((${#1} - 1))
        local path=$(printf '../%.0s' $(seq 1 $levels))
        builtin cd $path
    else
        builtin cd "$@"
    fi
}

alias cd='enhanced_cd'
alias cd.='cd ..'
alias cd..='enhanced_cd ...'
alias cd....='enhanced_cd ....'
alias cd.....='enhanced_cd .....'
alias cd......='enhanced_cd ......'
alias cd.......='enhanced_cd .......'
alias cd........='enhanced_cd ........'
alias cd.........='enhanced_cd .........'
alias cd..........='enhanced_cd ..........'
