###############
# ZSH Config
###############

# Ghostty shell integration
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# Locale
export LANG=en_GB.UTF-8

# Wayland Display set
#export WAYLAND_DISPLAY=wayland-0

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/tools/scripts:$PATH"

# ZSH Configuration
autoload -U colors && colors

# Enable vcs_info
autoload -Uz vcs_info
setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats '%F{green}(%b)%f%c%u'
zstyle ':vcs_info:git*' actionformats '%F{green}(%b)%f %F{red}| %a%f'
zstyle ':vcs_info:git*' stagedstr '%F{yellow} ●%f'
zstyle ':vcs_info:git*' unstagedstr '%F{red} ●%f'

# Faster compinit - only run once per day
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Enhanced Git info in prompt
git_info() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  [[ -n $branch ]] || return
  
  local status_color="%F{green}"
  local git_status=$(git status --porcelain 2>/dev/null)
  
  if [[ -n $git_status ]]; then
    status_color="%F{red}"  # Dirty repo
  elif git log --oneline @{u}..HEAD 2>/dev/null | grep -q .; then
    status_color="%F{yellow}"  # Ahead of remote
  fi
  
  echo "$status_color( $branch)%f"
}

precmd() {
  vcs_info
  print ""
  PROMPT="%F{blue}%~%f ${vcs_info_msg_0_}"$'\n'"%(?:%F{green}❯%f:%F{red}❯%f) "
}

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FCNTL_LOCK



zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%F{blue}-- %d --%f%b'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:ssh:*' config on

# Zsh line editor and other options
setopt AUTO_LIST               # show completions automatically
setopt LIST_AMBIGUOUS          # list options when ambiguous
setopt AUTO_CD                 # cd by typing directory name
setopt CORRECT                 # suggest corrections for commands
setopt EXTENDED_GLOB           # extended globbing patterns

# Key bindings
bindkey -e
bindkey '^[[1;5C' forward-word    # Ctrl-Right
bindkey '^[[1;5D' backward-word   # Ctrl-Left
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[OA" history-beginning-search-backward-end
bindkey "^[OB" history-beginning-search-forward-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# User configuration
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'

#### Aliases
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias vf='vim $(fzf --preview "head -100 {}")'
alias fz='cd $(dirname $(find . -type f | fzf --exclude .git --exclude .local --exclude node_modules))'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# git
alias gl='git log --oneline --graph --decorate'

# Quality of life
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias tree='tree -C'
alias df='df -h'
alias du='du -h'
alias fsdir='du -sh . 2>/dev/null | awk '\''{print $1}'\'''

# Tmux
alias t='tmux attach || tmux new'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new -s'

alias claude-work='CLAUDE_CONFIG_DIR=$HOME/.claude-work claude'
alias claude-personal='CLAUDE_CONFIG_DIR=$HOME/.claude-personal claude'
