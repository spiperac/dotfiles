export ZSH="$(eval echo ~$USER)/.oh-my-zsh"
#ZSH_THEME="awesomepanda" 
ZSH_THEME="agnoster"
HYPHEN_INSENSITIVE="true"

DISABLE_AUTO_UPDATE="true"
#export UPDATE_ZSH_DAYS=13

ENABLE_CORRECTION="true"
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
  nmap
  battery
  aws
  azure
  colorize
  copyfile
  extract
  themes
)

source $ZSH/oh-my-zsh.sh

# User configuration

export editor='nvim'
export SSH_KEY_PATH="~/.ssh/rsa_id"

alias vim="nvim"
alias lg='lazygit'

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"
export PATH=/home/spiperac/.local/bin:$PATH
eval $(keychain --eval --agents ssh id_rsa)

# STARSHIP
eval "$(starship init zsh)"


export PATH=$PATH:/home/spiperac/.spicetify
