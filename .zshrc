alias cd..='cd ..'
alias shesl='cd ~/go/src/github.com/sHesl'
alias uchown='sudo chown -R $(id -u):$(id -g)'
alias cover='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'
alias src='source ~/.zshrc'
alias myip="curl ifconfig.me"

function gitrecent() { git for-each-ref --sort=-committerdate refs/heads/ | head -n $1; }
