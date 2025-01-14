if [ "$TMUX" = "" ]; then tmux; fi

export ZSH="$(eval echo ~$USER)/.oh-my-zsh"
#ZSH_THEME="awesomepanda" 
ZSH_THEME="cloud"
HYPHEN_INSENSITIVE="true"

DISABLE_AUTO_UPDATE="true"
#export UPDATE_ZSH_DAYS=13

ENABLE_CORRECTION="false"
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
  colorize
  copyfile
  extract
  themes
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

export editor='nvim'
export SSH_KEY_PATH="~/.ssh/rsa_id"

# ssh
export PATH=/home/spiperac/.local/bin:$PATH
#eval $(keychain -q --eval --agents ssh id_rsa)

alias vim="nvim"
alias lg='lazygit'
