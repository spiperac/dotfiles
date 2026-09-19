###############
# ZSH Config
###############

# Ghostty shell integration
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# Locale
export LANG=en_US.UTF-8

# SSH agent provided by gnome-keyring
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/keyring/ssh"

# Rootless podman/crun needs systemd's user bus (cgroup creation via sd-bus);
# point at the systemd-managed bus when the socket exists.
if [[ -S "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/bus" ]]; then
  export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/bus"
fi

# Path (-U keeps entries unique in nested shells)
typeset -U path
path=("$HOME/scripts" "$HOME/.cargo/bin" "$HOME/.local/bin" $path)
export PATH

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

# Faster compinit - full check only once per day
setopt EXTENDED_GLOB
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

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
setopt HIST_EXPIRE_DUPS_FIRST
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
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':completion:*:ssh:*' config on

# Zsh line editor and other options
setopt AUTO_LIST               # show completions automatically
setopt LIST_AMBIGUOUS          # list options when ambiguous
setopt AUTO_CD                 # cd by typing directory name
setopt CORRECT                 # suggest corrections for commands

# fzf: Ctrl-R history, Ctrl-T files, Alt-C cd
command -v fzf >/dev/null && source <(fzf --zsh)

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

# direnv
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# User configuration
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'
export EZA_ICONS_AUTO=1

#### Aliases
if command -v eza >/dev/null; then
  alias ls='eza'
  alias ll='eza -l --git'
  alias la='eza -la --git'
fi
alias vf='$EDITOR "$(fzf --preview "head -100 {}")"'
alias fz='cd "$(dirname "$(fd -t f -H -E .git -E .local -E node_modules | fzf)")"'

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

# opencode
export PATH=/home/strah/.opencode/bin:$PATH
