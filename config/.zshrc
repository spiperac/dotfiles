# Lines configured by zsh-newuser-install
# History
export LC_TIME=en_GB.UTF-8
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward

setopt autocd
setopt correct 
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/strah/.zshrc'

# git
autoload -Uz vcs_info
setopt prompt_subst
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'

# compinit
autoload -Uz compinit
compinit

# Prompt
PS1='
%F{blue}%B%~%b%f%F{yellow}${vcs_info_msg_0_}%f
%F{green}❯%f '

# Aliases
alias ls='ls --color=auto -hv'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -c=auto'
alias ll='ls -las'
alias o='xdg-open'
