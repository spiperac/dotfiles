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
)

source $ZSH/oh-my-zsh.sh

# User configuration

export editor='nvim'
export SSH_KEY_PATH="~/.ssh/rsa_id"

alias vim="nvim"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
